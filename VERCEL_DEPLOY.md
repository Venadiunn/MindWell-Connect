# Vercel Deployment Guide

## What caused 404s
- Vercel wasn't configured to build and serve the Flutter web output (build/web).
- Single-page-app routes returned 404 because there was no rewrite to index.html.

## What was changed
- Added package.json with build script that runs vercel-build.sh.
- Added vercel.json to instruct Vercel to use @vercel/static-build with distDir: build/web and a rewrite rule to index.html so client-side routes won't 404.

## Vercel configuration
1. In the Vercel project settings:
   - Build Command: npm run build
   - Output Directory: leave blank (vercel.json specifies distDir) or set to build/web
2. Make sure the project is deploying from the repository root.

## Follow-up
- If Vercel still shows 404 after these changes: ensure the project import/build settings use npm run build and the root directory is correct.
