#!/bin/bash
# Start LightRAG Backend Server on port 9621 with built-in WebUI

set -e

cd "$(dirname "$0")"

# Activate virtual environment
source .venv/bin/activate

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env from env.example"
    exit 1
fi

# Get port from .env or use default
PORT=$(grep "^PORT=" .env | cut -d'=' -f2 || echo "9621")
HOST=$(grep "^HOST=" .env | cut -d'=' -f2 || echo "0.0.0.0")

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          LightRAG Server Starting on Port $PORT                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📍 Access Points:"
echo "   🌐 Frontend: http://localhost:$PORT/webui/"
echo "   📚 API Docs: http://localhost:$PORT/docs"
echo "   🔌 API: http://localhost:$PORT"
echo ""
echo "⏳ Initializing... (wait 10-15 seconds for full startup)"
echo ""

# Start the server
lightrag-server
