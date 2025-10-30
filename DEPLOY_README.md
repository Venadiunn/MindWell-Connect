# Python Deployment for Flutter Web

This project now includes Python-based deployment scripts to bypass Vercel's UTF-8 encoding issues.

## Quick Deploy

**Windows:**
```cmd
deploy.bat
```

**Mac/Linux:**
```bash
python3 deploy.py
```

## What it does

1. ✅ Checks dependencies (Flutter, Firebase CLI)
2. 🔧 Fixes UTF-8 encoding issues in Dart files
3. 🧹 Cleans previous build artifacts
4. 🏗️ Builds Flutter web app with proper settings
5. 🚀 Deploys to Firebase Hosting

## Prerequisites

1. **Python 3.7+** - [Download here](https://python.org)
2. **Flutter SDK** - Already installed ✅
3. **Firebase CLI** - Install with: `npm install -g firebase-tools`
4. **Firebase Login** - Run: `firebase login`

## Manual Steps (if needed)

```bash
# 1. Fix encoding and build
python3 deploy.py

# 2. Or step by step:
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit
firebase deploy --only hosting
```

## Firebase Hosting URL

Your app will be deployed to your Firebase project's hosting URL.
Check your [Firebase Console](https://console.firebase.google.com) for the exact URL.

## Features Included

- ✅ Mental health resources dashboard
- ✅ Lotus Companion AI chatbot with OpenRouter API
- ✅ Therapeutic conversation system
- ✅ Quick action preset buttons
- ✅ Responsive design for web
- ✅ SPA routing for seamless navigation

## Troubleshooting

If deployment fails:
1. Make sure you're logged into Firebase: `firebase login`
2. Check your Firebase project is selected: `firebase use --add`
3. Verify your Firebase project has Hosting enabled
4. Run the script again

The Python script handles UTF-8 encoding issues automatically, so it should work where Vercel failed.