# LightRAG MCP Integration - Complete Guide

## Summary
Tạo MCP server cho LightRAG để Claude có thể:
- ✅ Tự động query knowledge base
- ✅ Liệt kê documents  
- ✅ Xem graph entities & relations
- ✅ Kiểm tra server health

## Architecture
```
Claude Desktop
    ↓
MCP Protocol (stdio)
    ↓
LightRAG MCP Server (lightrag_mcp_server.py)
    ↓
LightRAG API (http://localhost:9621)
```

## Files Created

| File | Purpose |
|------|---------|
| `lightrag_mcp_server.py` | MCP server implementation (4 tools) |
| `claude_desktop_config.json` | Claude Desktop config template |
| `MCP_SETUP.md` | Full detailed setup guide |
| `MCP_QUICKSTART.md` | Quick 5-minute setup |
| `test_mcp.py` | MCP tools tester |

## Quick Start

### 1. Install FastMCP
```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
pip install fastmcp
```

### 2. Update Claude Config
```bash
cp /Applications/Soft/LightRAG/claude_desktop_config.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### 3. Start Backend
```bash
cd /Applications/Soft/LightRAG
./start-backend.sh
```

### 4. Restart Claude Desktop
Close and reopen Claude.

## Available Tools

### 1. lightrag_query(query, mode)
Query knowledge base with 3 modes:
- `local`: Fast, document-only search
- `global`: Comprehensive graph analysis  
- `hybrid`: Balanced (default)

**Example:**
```python
result = await lightrag_query("What are main topics?")
```

### 2. lightrag_documents(offset, limit)
List documents with metadata and status

**Example:**
```python
result = await lightrag_documents(offset=0, limit=10)
```

### 3. lightrag_graph(label, max_depth, max_nodes)
Get graph structure - entities and relationships

**Example:**
```python
result = await lightrag_graph(max_nodes=100)
```

### 4. lightrag_health()
Check server status and configuration

**Example:**
```python
result = await lightrag_health()
```

## Usage in Claude

Once configured, just ask Claude naturally:

```
User: "Từ knowledge base, ai là người quan trọng nhất?"
↓
Claude: automatically calls lightrag_query
↓
Returns: Detailed answer with references
```

## Testing

Test MCP server locally:
```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
python3 test_mcp.py
```

Expected output:
```
✅ Health check passed
✅ Found documents: [...]
✅ Query returned: {...}
✅ Graph: 100 nodes, 92 edges
```

## Configuration

### API Key
MCP server automatically uses: `lightrag-secure-key-2025`

### Backend URL
Configured to: `http://localhost:9621`

To change, edit `lightrag_mcp_server.py`:
```python
LIGHTRAG_API_URL = "http://localhost:9621"
LIGHTRAG_API_KEY = "lightrag-secure-key-2025"
```

## Troubleshooting

### Claude doesn't see LightRAG?
1. Verify config: `cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | python3 -m json.tool`
2. Restart Claude
3. Check backend running: `curl -H "X-API-Key: lightrag-secure-key-2025" http://localhost:9621/query`

### MCP server won't start?
```bash
# Test manually
cd /Applications/Soft/LightRAG
source .venv/bin/activate
python3 lightrag_mcp_server.py
```

Check error output and verify:
- FastMCP installed: `pip list | grep fastmcp`
- httpx installed: `pip list | grep httpx`
- Backend running: `ps aux | grep lightrag-server`

### Query returns empty results?
- Ensure documents are processed (check WebUI)
- Try `mode="global"` for comprehensive search
- Check backend logs: `tail -f /Applications/Soft/LightRAG/lightrag.log`

## Next Steps

1. ✅ Setup MCP (done)
2. ✅ Install dependencies (done)
3. ✅ Test tools (use test_mcp.py)
4. Configure Claude Desktop (copy config)
5. Start chatting with Claude using LightRAG knowledge!

## Advanced: Custom Tools

To add more tools, edit `lightrag_mcp_server.py`:

```python
@mcp.tool()
async def my_custom_tool(param: str) -> str:
    """Description of what tool does"""
    result = await call_lightrag_api("/endpoint", method="GET")
    return json.dumps(result, indent=2)
```

Tools automatically register and appear in Claude!

---

✅ LightRAG is now accessible from Claude via MCP!
