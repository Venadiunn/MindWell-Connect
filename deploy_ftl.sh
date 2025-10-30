#!/bin/bash

echo "🚀 Deploying FTL Mental Health App..."

# Navigate to the ftlmentalhealth project
cd ftlmentalhealth

echo "📦 Cleaning and getting dependencies..."
flutter clean
flutter pub get

echo "🔨 Building for web..."
flutter build web --release

# Go back to root for firebase deployment
cd ..

echo "🌐 Deploying to Firebase..."
firebase deploy

echo "✅ Deployment complete! Check: https://ftl-project-b5756.web.app"