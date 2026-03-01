# ⚡ LIGHTRAG - QUICK COMMAND REFERENCE

```bash
# 1️⃣ CHẠY APP (mỗi lần)
cd /Applications/Soft/LightRAG && ./start-backend.sh

# 2️⃣ MỞ BROWSER
http://localhost:9621/webui/

# ✅ DONE!
```

---

## 🔧 LẦN ĐẦU - SETUP (chỉ làm 1 lần)

```bash
# Activate venv
cd /Applications/Soft/LightRAG
source .venv/bin/activate

# Cài dependencies
pip install -e .[api]
pip install pipmaster
```

---

## 🐛 CÓ LỖI PORT?

```bash
lsof -i :9621 | grep LISTEN | awk '{print $2}' | xargs kill -9
sleep 2
cd /Applications/Soft/LightRAG && ./start-backend.sh
```

---

## 📖 FULL GUIDE

```bash
cat /Applications/Soft/LightRAG/RUN_APP_GUIDE.md
```

---

**LƯU Ý:** Không cần chạy bất cứ frontend dev server nào. Tất cả đã có sẵn trên port 9621.
