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

REM Stop IIS site using PowerShell
echo 🛑 Stopping IIS website...
powershell -Command "Import-Module WebAdministration; Stop-Website -Name 'Default Web Site'"

REM Define target directory
set "WEBROOT=C:\inetpub\wwwroot\Optimus Apps\MyWebApp"

echo 📁 Checking if %WEBROOT% exists...
IF NOT EXIST "%WEBROOT%" (
    echo ❌ %WEBROOT% does not exist. Exiting...
    exit /b 1
)

REM Clean contents of the directory but keep the folder
echo 🧹 Cleaning contents of %WEBROOT%...
del /f /q "%WEBROOT%\*" > nul
for /d %%x in ("%WEBROOT%\*") do rmdir /s /q "%%x"

REM Extract app using built-in PowerShell
echo 📦 Extracting myapp.zip...
powershell -Command "Expand-Archive -Path 'myapp.zip' -DestinationPath '%WEBROOT%' -Force"

REM Set permissions
echo 🔒 Setting permissions...
icacls "%WEBROOT%" /grant "IIS AppPool\OBNAPPTESTSVR:(OI)(CI)F"

REM Start IIS site using PowerShell
echo 🚀 Starting IIS website...
powershell -Command "Import-Module WebAdministration; Start-Website -Name 'Default Web Site'"

REM Smoke test
echo 🔍 Running smoke test...
curl -s -o nul -w "%%{http_code}" http://localhost | findstr /C:"200" > nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Smoke test failed
    exit /b 1
)

echo ✅ Deployment complete.
