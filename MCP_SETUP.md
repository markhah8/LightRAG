# LightRAG MCP Server Setup Guide

## Cái gì là MCP?
MCP (Model Context Protocol) cho phép Claude gọi LightRAG như một tool - tức Claude có thể tự động query knowledge base, truy cập tài liệu, và xem đồ thị.

## 1️⃣ Install Dependencies

```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
pip install fastmcp
```

## 2️⃣ Cài Claude Desktop MCP Config

Mở `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) hoặc `%APPDATA%\Claude\claude_desktop_config.json` (Windows)

Thêm vào:

```json
{
  "mcpServers": {
    "lightrag": {
      "command": "python3",
      "args": ["/Applications/Soft/LightRAG/lightrag_mcp_server.py"]
    }
  }
}
```

Hoặc copy cấu hình có sẵn:
```bash
cp /Applications/Soft/LightRAG/claude_mcp_config.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

## 3️⃣ Khởi động LightRAG

```bash
cd /Applications/Soft/LightRAG
./start-backend.sh
```

Chờ tới khi thấy: `Server is ready to accept connections! 🚀`

## 4️⃣ Restart Claude Desktop

Đóng Claude Desktop hoàn toàn rồi mở lại. Nó sẽ nạp MCP server.

## 5️⃣ Kiểm tra trong Claude

Viết một câu hỏi bất kỳ. Claude sẽ tự động:
- ✅ Query LightRAG nếu cần context từ documents
- ✅ Kéo dữ liệu từ knowledge graph
- ✅ Liệt kê documents có sẵn

## Tools Có Sẵn

### 1. `lightrag_query`
Query knowledge base:
```
Tìm trong documents về AI là gì?
```
Claude tự động dùng: `lightrag_query(query="AI là gì?")`

### 2. `lightrag_documents`
Liệt kê documents:
```
Có bao nhiêu documents trong knowledge base?
```

### 3. `lightrag_graph`
Xem đồ thị entities và relations:
```
Vẽ đồ thị các entity và mối quan hệ
```

### 4. `lightrag_health`
Kiểm tra server:
```
LightRAG server có sẵn không?
```

## 🔧 Troubleshoot

**Claude không thấy tools?**
```bash
# Check config syntax
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | python3 -m json.tool

# Check MCP server chạy được
python3 /Applications/Soft/LightRAG/lightrag_mcp_server.py
```

**Backend không kết nối?**
```bash
# Kiểm tra LightRAG running
curl -H "X-API-Key: lightrag-secure-key-2025" \
     http://localhost:9621/api/health

# Xem logs
tail -f /Applications/Soft/LightRAG/lightrag.log
```

## 📋 Use Cases

### Case 1: Research với Knowledge Base
```
User: "Tóm tắt tất cả insights từ documents về machine learning"
↓
Claude: Tự động query LightRAG → trả về context → tóm tắt
```

### Case 2: Graph Analysis
```
User: "Vẽ mối quan hệ giữa các concept trong KB"
↓
Claude: Gọi lightrag_graph → phân tích → mô tả đồ thị
```

### Case 3: Document Discovery
```
User: "Cái document nào có info về X?"
↓
Claude: Gọi lightrag_documents → filter → gợi ý
```

## 🚀 Advanced: Custom Tools

Muốn thêm tools khác? Edit `lightrag_mcp_server.py` và thêm vào `list_tools()`:

```python
Tool(
    name="custom_tool",
    description="...",
    inputSchema={...}
)
```

Rồi implement logic ở `call_tool()`.

## 📝 Notes

- MCP server chạy qua stdio - Claude Desktop giao tiếp với nó trực tiếp
- API Key `lightrag-secure-key-2025` được dùng tự động
- Không cần manual API calls từ Claude - tất cả là tool calls
- Tools là non-blocking - Claude có thể dùng multiple tools song song

---

✅ Sau đó, Claude sẽ có full access vào LightRAG knowledge base!
