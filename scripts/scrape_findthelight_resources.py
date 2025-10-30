"""
Local scraper to fetch resource data from Find The Light Foundation Resources portal.

Usage:
  - Install dependencies (prefer a venv):
      python -m pip install requests beautifulsoup4
  - Run the script in PowerShell from repository root:
      python .\tools\scrape_findthelight_resources.py --output .\ftlmentalhealth\assets\app_resources_full.json

Notes:
  - This is a best-effort scraper. If the portal returns data via JavaScript/XHR, run it with a browser-enabled scraper (Playwright) or use the portal's API if available.
  - The script tries several common endpoints and attempts to extract resource entries from JSON-LD blocks, embedded <script> tags, or table/list markup.

If it successfully fetches and writes JSON with 227 entries, let me know and I will import it into the app asset and run analysis for you.
"""

import argparse
import json
import sys
import time
from typing import List, Dict, Optional

import requests
from bs4 import BeautifulSoup

CANDIDATE_URLS = [
    "https://resources.findthelightfoundation.org/portal/resources",
    "https://resources.findthelightfoundation.org/library",
    "https://resources.findthelightfoundation.org/portal/library",
    "https://resources.findthelightfoundation.org/portal/resources.json",
    "https://resources.findthelightfoundation.org/portal/api/resources",
    "https://resources.findthelightfoundation.org/api/resources",
]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"
}


def try_fetch_json(url: str) -> Optional[List[Dict]]:
    try:
        resp = requests.get(url, headers=HEADERS, timeout=15)
        if resp.status_code != 200:
            return None
        try:
            data = resp.json()
            if isinstance(data, list):
                return data
            # Some APIs nest data under a key
            if isinstance(data, dict):
                for k in ("data", "results", "resources", "items"):
                    if k in data and isinstance(data[k], list):
                        return data[k]
        except Exception:
            return None
    except Exception:
        return None
    return None


def extract_from_html(html: str) -> List[Dict]:
    soup = BeautifulSoup(html, "html.parser")
    results: List[Dict] = []

    # Look for JSON-LD script blocks
    for s in soup.select('script[type="application/ld+json"]'):
        try:
            payload = json.loads(s.string or "{}")
            # If payload is a list, extend
            if isinstance(payload, list):
                for item in payload:
                    if isinstance(item, dict):
                        results.append(item)
            elif isinstance(payload, dict):
                # If it contains an array under a key
                for k in ("resources", "items", "data"):
                    if k in payload and isinstance(payload[k], list):
                        results.extend(payload[k])
                # Otherwise, heuristic: if payload looks like a resource, include
                if any(k in payload for k in ("title", "linkURL", "description", "RID")):
                    results.append(payload)
        except Exception:
            continue

    # Look for inline script variable that holds a JSON array (common in SPAs)
    for s in soup.find_all("script"):
        text = s.string
        if not text:
            continue
        # crude heuristic: find 'window.__INITIAL_STATE__ =' or 'var resources =' patterns
        markers = ["window.__INITIAL_STATE__", "var resources", "resources =", "window.resources"]
        for m in markers:
            if m in text:
                # attempt to find first JSON array in the script text
                start = text.find('[')
                end = text.rfind(']')
                if start != -1 and end != -1 and end > start:
                    candidate = text[start:end+1]
                    try:
                        parsed = json.loads(candidate)
                        if isinstance(parsed, list):
                            results.extend([p for p in parsed if isinstance(p, dict)])
                    except Exception:
                        pass

    # Attempt to parse resource rows from common HTML patterns (cards, tables, lists)
    # Look for elements with class containing 'resource' or 'card'
    for card in soup.select(".resource, .resource-card, .card, [data-resource-id]"):
        try:
            title_el = card.select_one(".title, h2, h3, .resource-title")
            title = title_el.get_text(strip=True) if title_el else None
            desc_el = card.select_one(".description, p, .resource-desc")
            description = desc_el.get_text(strip=True) if desc_el else None
            link_el = card.select_one("a[href]")
            link = link_el["href"] if link_el else None
            rid = card.get("data-resource-id") or None
            if title or description or link:
                results.append({
                    "RID": rid or "",
                    "title": title or "",
                    "description": description or "",
                    "linkURL": link or "",
                })
        except Exception:
            continue

    return results


def crawl_and_extract() -> List[Dict]:
    all_items: List[Dict] = []

    for url in CANDIDATE_URLS:
        print(f"Trying {url} ...")
        # First try JSON fetch
        data = try_fetch_json(url)
        if data:
            print(f"Found JSON at {url}, items: {len(data)}")
            all_items.extend(data)
            # If we already have many items, break
            if len(all_items) >= 227:
                break
            continue

        # Otherwise fetch HTML and parse
        try:
            resp = requests.get(url, headers=HEADERS, timeout=15)
            if resp.status_code != 200:
                print(f"Skipping {url}, status {resp.status_code}")
                continue
            extracted = extract_from_html(resp.text)
            print(f"Extracted {len(extracted)} candidate items from {url}")
            all_items.extend(extracted)
            if len(all_items) >= 227:
                break
        except Exception as e:
            print(f"Error fetching {url}: {e}")
            continue
        time.sleep(0.5)

    # Deduplicate by RID, title+link fallback
    unique = {}
    for item in all_items:
        key = item.get("RID") or (item.get("title", "") + "|" + item.get("linkURL", ""))
        if key in unique:
            continue
        unique[key] = item

    items = list(unique.values())
    print(f"Total unique items found: {len(items)}")
    return items


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", "-o", default="./ftlmentalhealth/assets/app_resources_full.json")
    args = parser.parse_args()

    items = crawl_and_extract()

    # Write output
    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False, indent=2)

    print(f"Wrote {len(items)} items to {args.output}")

    if len(items) < 227:
        print("WARNING: fewer than 227 items were found. If the portal relies on JavaScript to render data, consider running a Playwright script or provide an API endpoint or the raw JSON file.")
        sys.exit(2)
    else:
        print("Success: Found 227 or more items.")


if __name__ == '__main__':
    main()
