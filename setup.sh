#!/bin/bash
# Czkawka Setup Script for TrueNAS
# Creates necessary directories and initializes configuration

set -e

echo "🔍 Czkawka Duplicate Finder Setup"
echo "=================================="

# Check if running on TrueNAS
if [ ! -d "/mnt/app-pool" ]; then
    echo "❌ Error: /mnt/app-pool not found. Run this on TrueNAS!"
    exit 1
fi

# Create config directory
echo "📁 Creating config directory..."
mkdir -p /mnt/app-pool/configs/czkawka/config
chown -R 1000:1000 /mnt/app-pool/configs/czkawka

# Create duplicates staging directory
echo "📁 Creating duplicates staging directory..."
mkdir -p /mnt/media-pool/photos-duplicates
chown -R 1000:1000 /mnt/media-pool/photos-duplicates

# Check photo library
if [ -d "/mnt/media-pool/photos" ]; then
    PHOTO_COUNT=$(find /mnt/media-pool/photos -type f | wc -l)
    echo "✅ Photo library found: $PHOTO_COUNT files"
else
    echo "⚠️  Warning: /mnt/media-pool/photos not found"
fi

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env and set VNC_PASSWORD if desired"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Review docker-compose.yml configuration"
echo "2. Set VNC_PASSWORD in .env file (optional)"
echo "3. Deploy: docker compose up -d"
echo "4. Access: https://czkawka.media.erdlabs.com"
echo ""
echo "📊 Recommended scan settings:"
echo "   - Duplicate Files: Hash=Blake3, Min=10KB"
echo "   - Similar Images: Similarity=High, Min=50KB"
