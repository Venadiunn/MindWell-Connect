#!/usr/bin/env python3
"""
Flutter Web Deployment Script for Firebase Hosting
Builds and deploys the mental health app with Lotus Companion AI chatbot
"""

import os
import sys
import subprocess
import shutil
import platform
from pathlib import Path

def run_command(cmd, cwd=None, check=True):
    """Run a shell command and return the result"""
    print(f"🔄 Running: {cmd}")
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            cwd=cwd, 
            check=check,
            capture_output=True,
            text=True,
            encoding='utf-8'
        )
        if result.stdout:
            print(result.stdout)
        return result
    except subprocess.CalledProcessError as e:
        print(f"❌ Error: {e}")
        if e.stderr:
            print(f"Error output: {e.stderr}")
        if check:
            sys.exit(1)
        return e

def check_dependencies():
    """Check if required tools are installed"""
    print("🔍 Checking dependencies...")
    
    # Check Flutter
    try:
        result = run_command("flutter --version", check=False)
        if result.returncode == 0:
            print("✅ Flutter is installed")
        else:
            print("❌ Flutter is not installed or not in PATH")
            return False
    except:
        print("❌ Flutter is not installed or not in PATH")
        return False
    
    # Check Firebase CLI
    try:
        result = run_command("firebase --version", check=False)
        if result.returncode == 0:
            print("✅ Firebase CLI is installed")
        else:
            print("❌ Firebase CLI is not installed")
            print("💡 Install with: npm install -g firebase-tools")
            return False
    except:
        print("❌ Firebase CLI is not installed")
        print("💡 Install with: npm install -g firebase-tools")
        return False
    
    return True

def fix_file_encoding():
    """Fix UTF-8 encoding issues in Dart files"""
    print("🔧 Fixing UTF-8 encoding in Dart files...")
    
    lib_dir = Path("lib")
    if not lib_dir.exists():
        print("❌ lib directory not found")
        return False
    
    dart_files = list(lib_dir.rglob("*.dart"))
    
    for dart_file in dart_files:
        try:
            # Read file with error handling
            with open(dart_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            # Write back with clean UTF-8
            with open(dart_file, 'w', encoding='utf-8', newline='\n') as f:
                f.write(content)
            
            print(f"✅ Fixed encoding: {dart_file}")
        
        except Exception as e:
            print(f"⚠️  Warning: Could not fix {dart_file}: {e}")
    
    return True

def clean_build():
    """Clean previous build artifacts"""
    print("🧹 Cleaning previous build artifacts...")
    
    # Remove build directories
    dirs_to_clean = [
        "build",
        ".dart_tool/flutter_build",
        "web/build"
    ]
    
    for dir_path in dirs_to_clean:
        if os.path.exists(dir_path):
            shutil.rmtree(dir_path)
            print(f"🗑️  Removed: {dir_path}")
    
    # Run flutter clean
    run_command("flutter clean")
    print("✅ Clean completed")

def build_web():
    """Build Flutter web app"""
    print("🏗️  Building Flutter web app...")
    
    # Get dependencies
    run_command("flutter pub get")
    
    # Build for web
    build_cmd = "flutter build web --release --web-renderer canvaskit --dart-define=FLUTTER_WEB_USE_SKIA=true"
    result = run_command(build_cmd)
    
    if result.returncode == 0:
        print("✅ Build completed successfully!")
        return True
    else:
        print("❌ Build failed")
        return False

def deploy_to_firebase():
    """Deploy to Firebase Hosting"""
    print("🚀 Deploying to Firebase Hosting...")
    
    # Check if firebase.json exists
    if not os.path.exists("firebase.json"):
        print("❌ firebase.json not found")
        return False
    
    # Deploy
    result = run_command("firebase deploy --only hosting", check=False)
    
    if result.returncode == 0:
        print("✅ Deployment successful!")
        print("🌐 Your app is now live on Firebase Hosting!")
        return True
    else:
        print("❌ Deployment failed")
        print("💡 Make sure you're logged in: firebase login")
        return False

def main():
    """Main deployment process"""
    print("🚀 Flutter Web Deployment Script")
    print("=" * 50)
    
    # Check we're in the right directory
    if not os.path.exists("pubspec.yaml"):
        print("❌ pubspec.yaml not found. Please run this from your Flutter project root.")
        sys.exit(1)
    
    # Check dependencies
    if not check_dependencies():
        print("❌ Missing dependencies. Please install and try again.")
        sys.exit(1)
    
    # Fix encoding issues
    if not fix_file_encoding():
        print("⚠️  Warning: Could not fix all encoding issues")
    
    # Clean previous builds
    clean_build()
    
    # Build the app
    if not build_web():
        print("❌ Build failed. Deployment aborted.")
        sys.exit(1)
    
    # Deploy to Firebase
    if not deploy_to_firebase():
        print("❌ Deployment failed.")
        sys.exit(1)
    
    print("\n🎉 Deployment completed successfully!")
    print("🌸 Your Lotus Companion AI mental health app is now live!")

if __name__ == "__main__":
    main()