@echo off
echo 🚀 Deploying FTL Mental Health App...

echo 📁 Navigating to project directory...
cd ftlmentalhealth

echo 📦 Cleaning and getting dependencies...
flutter clean
flutter pub get

echo 🔨 Building for web...
flutter build web --release

echo 📁 Going back to root...
cd ..

echo 🌐 Deploying to Firebase...
firebase deploy

echo ✅ Deployment complete! Check: https://ftl-project-b5756.web.app
pause