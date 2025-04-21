#!/bin/bash

set -e  # Exit on any error

echo "🛑 Stopping Apache..."
sudo systemctl stop apache2

echo "🧹 Cleaning old app files..."
sudo rm -rf /var/www/html/*

echo "📦 Extracting new app files..."
unzip -o myapp.zip -d /var/www/html/

echo "🔒 Setting proper permissions..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

echo "🚀 Starting Apache..."
sudo systemctl start apache2

echo "🔍 Running smoke test..."
curl -I http://localhost | grep "200 OK" || {
  echo "❌ Smoke test failed"
  exit 1
}

echo "✅ Deployment complete."
