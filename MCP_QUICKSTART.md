# 🚀 LightRAG MCP Quick Start

## What is MCP?
MCP allows Claude to use LightRAG like a tool - Claude tự động có thể query knowledge base, truy cập documents, và xem đồ thị.

## Setup (5 minutes)

### Step 1: Install FastMCP
```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
pip install fastmcp
```

### Step 2: Update Claude Config
Edit: `~/Library/Application Support/Claude/claude_desktop_config.json`

Replace content with:
```json
{
  "mcpServers": {
    "lightrag": {
      "command": "python3",
      "args": ["-u", "/Applications/Soft/LightRAG/lightrag_mcp_server.py"],
      "env": {"PYTHONUNBUFFERED": "1"}
    }
  }
}
```

Or just copy:
```bash
cp /Applications/Soft/LightRAG/claude_desktop_config.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Step 3: Start LightRAG
```bash
cd /Applications/Soft/LightRAG
./start-backend.sh
```

Wait for: `Server is ready to accept connections! 🚀`

### Step 4: Restart Claude Desktop
Close and reopen Claude.

## Available Tools

| Tool | Purpose |
|------|---------|
| `lightrag_query` | Ask questions to knowledge base |
| `lightrag_documents` | List all documents |
| `lightrag_graph` | View entity relationships |
| `lightrag_health` | Check server status |

## Use Cases

### 1️⃣ Ask Questions
```
User: "Dùng dữ liệu từ documents, ai là người quan trọng nhất?"
↓
Claude automatically calls lightrag_query → returns answer from KB
```

### 2️⃣ View Documents  
```
User: "Bao nhiêu documents?"
↓
Claude calls lightrag_documents → lists 10 documents
```

### 3️⃣ Analyze Graph
```
User: "Vẽ mối quan hệ giữa entities"
↓
Claude calls lightrag_graph → shows graph structure
```

## 🔧 Troubleshooting

**Claude không thấy LightRAG?**
```bash
# Check config is valid JSON
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | python3 -m json.tool
```

**Backend không kết nối?**
```bash
# Verify server running
curl -H "X-API-Key: lightrag-secure-key-2025" http://localhost:9621/api/health
```

**MCP server không start?**
```bash
# Test manually
cd /Applications/Soft/LightRAG
source .venv/bin/activate
python3 lightrag_mcp_server.py
```

## 📋 Files
- `lightrag_mcp_server.py` - MCP server implementation
- `claude_desktop_config.json` - Claude config template
- `MCP_SETUP.md` - Full setup guide

---

✅ After setup, Claude has full access to your knowledge base!
