#!/usr/bin/env bash
set -euo pipefail

echo "Downloading Flutter SDK 3.27.1..."
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.1-stable.tar.xz" -o flutter.tar.xz

echo "Extracting Flutter SDK..."
tar xf flutter.tar.xz

echo "Setting up Flutter..."
export PATH="$PWD/flutter/bin:$PATH"
export PUB_CACHE="$PWD/.pub-cache"

# Fix git ownership warning
git config --global --add safe.directory "$PWD/flutter"

flutter --version
flutter config --enable-web --no-analytics

echo "Installing dependencies..."
flutter pub get

echo "Cleaning previous build artifacts..."
flutter clean

echo "Fixing potential UTF-8 encoding issues..."
# Convert all Dart files to ensure proper UTF-8 encoding
find lib -name "*.dart" -type f -exec sh -c '
  for file; do
    # Create a temp file with proper UTF-8 encoding
    iconv -f UTF-8 -t UTF-8 -c "$file" > "${file}.tmp" 2>/dev/null && mv "${file}.tmp" "$file" || rm -f "${file}.tmp"
  done
' sh {} +

echo "Building Flutter web app..."
flutter build web --release --web-renderer canvaskit

echo "Build complete!"