#!/bin/bash
# Setup LightRAG MCP for Claude Desktop - Automated Script

set -e

echo "======================================"
echo "🚀 LightRAG MCP Setup Script"
echo "======================================"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Python
echo -e "${YELLOW}1️⃣  Checking Python...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 not found${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python3 found: $(python3 --version)${NC}"

# Check venv
echo -e "${YELLOW}2️⃣  Activating virtual environment...${NC}"
cd /Applications/Soft/LightRAG
if [ ! -d ".venv" ]; then
    echo -e "${RED}❌ .venv not found. Run: python3 -m venv .venv${NC}"
    exit 1
fi
source .venv/bin/activate
echo -e "${GREEN}✅ Activated .venv${NC}"

# Install FastMCP
echo -e "${YELLOW}3️⃣  Installing FastMCP...${NC}"
pip install -q fastmcp
echo -e "${GREEN}✅ FastMCP installed${NC}"

# Verify MCP server
echo -e "${YELLOW}4️⃣  Testing MCP server...${NC}"
if python3 -c "from lightrag_mcp_server import mcp; print('✅ MCP server loads OK')" 2>/dev/null; then
    echo -e "${GREEN}✅ MCP server verified${NC}"
else
    echo -e "${RED}❌ MCP server failed to load${NC}"
    exit 1
fi

# Update Claude config
echo -e "${YELLOW}5️⃣  Setting up Claude config...${NC}"
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
if [ ! -d "$CLAUDE_CONFIG_DIR" ]; then
    mkdir -p "$CLAUDE_CONFIG_DIR"
fi

cp /Applications/Soft/LightRAG/claude_desktop_config.json \
   "$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

echo -e "${GREEN}✅ Claude config updated: $CLAUDE_CONFIG_DIR/claude_desktop_config.json${NC}"

# Summary
echo ""
echo "======================================"
echo "✅ Setup Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Start LightRAG backend:"
echo "   cd /Applications/Soft/LightRAG && ./start-backend.sh"
echo ""
echo "2. Restart Claude Desktop (close and reopen)"
echo ""
echo "3. Test in Claude:"
echo "   'Query my knowledge base about...'"
echo ""
echo "4. (Optional) Run test:"
echo "   python3 /Applications/Soft/LightRAG/test_mcp.py"
echo ""
echo "======================================"
