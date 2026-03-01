# 🚀 LightRAG MCP - Getting Started

## What is MCP?
MCP cho Claude **truy cập LightRAG như một tool** - Claude có thể tự động query knowledge base, xem documents, và phân tích mối quan hệ.

## ⚡ Quick Setup (5 minutes)

### 1️⃣ Auto Setup (Recommended)
```bash
cd /Applications/Soft/LightRAG
bash setup_mcp.sh
```

### 2️⃣ Start Backend
```bash
cd /Applications/Soft/LightRAG
./start-backend.sh
```
Wait for: `Server is ready to accept connections! 🚀`

### 3️⃣ Restart Claude Desktop
Close and reopen Claude.

## ✨ Done! Now Use It

### Ask Claude:
```
"From my knowledge base, who are the most important people?"
```

Claude tự động:
1. Gọi `lightrag_query` tool
2. Lấy dữ liệu từ KB
3. Trả lời với references

## 📚 Available Tools

| Tool | What it does |
|------|--------------|
| `lightrag_query` | Ask questions to knowledge base |
| `lightrag_documents` | List all documents |
| `lightrag_graph` | View entities and relationships |
| `lightrag_health` | Check server status |

## 🔍 Example Conversations

**Example 1:**
```
You: "Summarize the main themes in my documents"
Claude: *calls lightrag_query* → returns summary with references
```

**Example 2:**
```
You: "How many documents do I have?"
Claude: *calls lightrag_documents* → tells you document count
```

**Example 3:**
```
You: "Show me the relationship graph"
Claude: *calls lightrag_graph* → describes the entity relationships
```

## 📁 Files Overview

```
lightrag_mcp_server.py      ← Main MCP server (tools implementation)
claude_desktop_config.json  ← Claude Desktop config (copy to ~/Library/...)
setup_mcp.sh               ← Auto setup script
test_mcp.py                ← Test tools locally
MCP_QUICKSTART.md          ← 5-minute guide
MCP_SETUP.md               ← Detailed setup
MCP_GUIDE.md               ← Complete reference
MCP_IMPLEMENTATION.md      ← Technical details
```

## 🧪 Test It Works

```bash
python3 /Applications/Soft/LightRAG/test_mcp.py
```

Should see:
```
✅ Health check passed
✅ Query returned: {...}
✅ Graph: 100 nodes, 92 edges
```

## ❓ FAQ

**Q: Does Claude see the tools?**
A: If Claude shows a hammer icon (🔨) or mentions tools, yes! Otherwise check config.

**Q: Can Claude upload files?**
A: Not via MCP yet. Use WebUI at http://localhost:9621/webui/

**Q: How fast are queries?**
A: ~2-3 seconds (depends on Gemini API response time)

**Q: Can I ask in Vietnamese?**
A: Yes! All tools support Vietnamese fully.

**Q: What if backend stops?**
A: Queries will fail. Restart: `./start-backend.sh`

## 🔧 Troubleshoot

**Claude doesn't see LightRAG?**
```bash
# Verify config
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | python3 -m json.tool

# Restart Claude completely
```

**Test tool manually:**
```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
python3 test_mcp.py
```

**Check backend:**
```bash
curl -H "X-API-Key: lightrag-secure-key-2025" \
     -H "Content-Type: application/json" \
     -X POST http://localhost:9621/query \
     -d '{"query":"test"}'
```

## 📖 Need Help?

1. **Quick start:** Read `MCP_QUICKSTART.md`
2. **Detailed setup:** Read `MCP_SETUP.md`
3. **Technical details:** Read `MCP_GUIDE.md`
4. **Implementation:** Read `MCP_IMPLEMENTATION.md`
5. **Test tools:** Run `python3 test_mcp.py`

## 🎯 Key Points

✅ MCP server runs as subprocess (managed by Claude)
✅ Auto-authenticates using X-API-Key header
✅ Supports Vietnamese in questions and responses
✅ Full async/await for performance
✅ Error handling with fallbacks
✅ Tests included to verify setup

## 🚀 Next Steps

1. ✅ Setup complete
2. Run `./start-backend.sh`
3. Restart Claude
4. Ask a question!

---

**Questions?** Check the markdown files or run `test_mcp.py`

**Ready?** Open Claude and start asking!
