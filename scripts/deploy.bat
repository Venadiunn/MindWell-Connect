@echo off
echo 🚀 Flutter Web Deployment to Firebase
echo =====================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed or not in PATH
    echo 💡 Please install Python 3.7+ and try again
    pause
    exit /b 1
)

echo ✅ Python found
echo.

REM Run the deployment script
echo 🔄 Starting deployment process...
python deploy.py

if errorlevel 1 (
    echo.
    echo ❌ Deployment failed. Check the output above for details.
    pause
    exit /b 1
)

echo.
echo 🎉 Deployment completed successfully!
echo 🌸 Your Lotus Companion app is now live!
echo.
pause