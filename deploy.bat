@echo off
REM This script is for deploying the application to IIS

echo Current working directory:
cd

REM Check for myapp.zip before proceeding
IF NOT EXIST "myapp.zip" (
    echo ❌ myapp.zip not found in %cd%
    dir
    exit /b 1
)

REM Stop IIS
echo 🛑 Stopping IIS...
iisreset /stop

REM Clean and recreate target directory
set WEBROOT=C:\inetpub\wwwroot\MyWebApp

echo 📁 Checking if %WEBROOT% exists...
IF EXIST "%WEBROOT%" (
    echo 🧹 Removing existing %WEBROOT%...
    rmdir /s /q "%WEBROOT%"
)

echo 📂 Creating %WEBROOT%...
mkdir "%WEBROOT%"

REM Extract app
echo 📦 Extracting myapp.zip...
"C:\Program Files\7-Zip\7z.exe" x "myapp.zip" -o"%WEBROOT%" -y

REM Set permissions
echo 🔒 Setting permissions...
icacls "%WEBROOT%" /grant "IISAppPool\iis-agent-01:(OI)(CI)F"

REM Start IIS
echo 🚀 Starting IIS...
iisreset /start

REM Smoke test
echo 🔍 Running smoke test...
curl -s -o nul -w "%%{http_code}" http://localhost | findstr /C:"200" > nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Smoke test failed
    exit /b 1
)

echo ✅ Deployment complete.
