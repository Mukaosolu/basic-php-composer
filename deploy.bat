# Exit on any error
$ErrorActionPreference = "Stop"

echo "🛑 Stopping IIS..."
iisreset /stop

echo "📦 Extracting new app files without deleting old files..."
# Update files by extracting over existing files
Expand-Archive -Path myapp.zip -DestinationPath C:\inetpub\wwwroot\ -Force

echo "🔒 Setting proper permissions..."
$folderPath = "C:\inetpub\wwwroot"
$acl = Get-Acl $folderPath
$permission = "IIS AppPool\DefaultAppPool", "Modify", "Allow"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.AddAccessRule($rule)
Set-Acl $folderPath $acl

echo "🚀 Starting IIS..."
iisreset /start

echo "🔍 Running smoke test..."
$response = Invoke-WebRequest -Uri "http://localhost" -Method Head -UseBasicP
if ($response.StatusCode -eq 200) {
    echo "✅ Smoke test passed."
} else {
    echo "❌ Smoke test failed"
    exit 1
}

echo "✅ Deployment complete."
