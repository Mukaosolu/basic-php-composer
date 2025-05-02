@echo off
:: Ensure Chocolatey runs with elevated privileges
:: This will invoke cmd.exe to run the command with elevated privileges

echo Installing PHP 8.2 using Chocolatey...
cd /d "%~dp0"  :: Change to the directory where this script is located

:: Run the chocolatey command as administrator
start "" /b cmd.exe /c "choco install php --version 8.2 -y"
