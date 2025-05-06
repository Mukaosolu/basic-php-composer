@echo off
REM This script is for deploying the application to IIS

echo 🛑 Stopping IIS...
iisreset /stop

REM Check if MyWebApp folder exists, if not create it
echo 📁 Checking if MyWebApp directory exists...
IF NOT EXIST "C:\inetpub\wwwroot\MyWebApp" (
    echo 📂 Creating MyWebApp directory...
    mkdir "C:\inetpub\wwwroot\MyWebApp"
)

echo 🧹 Cleaning old app files...
rmdir /s /q "C:\inetpub\wwwroot\MyWebApp"

echo 📦 Extracting new app files...
"C:\Program Files\7-Zip\7z.exe" x "C:\inetpub\wwwroot\MyWebApp\myapp.zip" -oC:\inetpub\wwwroot\MyWebApp

echo 🔒 Setting proper permissions...
icacls "C:\inetpub\wwwroot\MyWebApp" /grant "IIS AppPool\DefaultAppPool:(OI)(CI)F"
icacls "C:\inetpub\wwwroot\MyWebApp" /grant "iis-agent-01:(OI)(CI)F"  REM Granting permissions for the iis-agent-01

echo 🚀 Starting IIS...
iisreset /start

echo 🔍 Running smoke test...
curl -s -o nul -w "%{http_code}" http://localhost | findstr /C:"200" > nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Smoke test failed
    exit /b 1
)

echo ✅ Deployment complete.
