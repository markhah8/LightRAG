# LightRAG Quick Start - Simple & Stable

## 🚀 **One Command to Start Everything**

```bash
cd /Applications/Soft/LightRAG
./start-backend.sh
```

Then open your browser:
- **Frontend:** http://localhost:9621/webui/
- **API Docs:** http://localhost:9621/docs

That's it! Everything runs on **port 9621**.

---

## ✅ **What This Does**

The backend server includes:
- ✅ Python FastAPI backend
- ✅ Built-in React frontend (pre-built)
- ✅ API on same port
- ✅ All running on port 9621

---

## 🔧 **Prerequisites (One-time Setup)**

```bash
# 1. Create .env (if not exists)
cd /Applications/Soft/LightRAG
cp env.example .env

# 2. Create Python venv (if not exists)
python -m venv .venv

# 3. Activate and install dependencies
source .venv/bin/activate
pip install -e .[api]
pip install pipmaster

# 4. Make script executable
chmod +x start-backend.sh

# Done! Now just run:
./start-backend.sh
```

---

## 🆘 **If Something Goes Wrong**

### **Port 9621 Already in Use**
```bash
lsof -i :9621 | grep LISTEN | awk '{print $2}' | xargs kill -9
sleep 2
./start-backend.sh
```

### **Module Errors**
```bash
source .venv/bin/activate
pip install -e .[api]
pip install pipmaster
./start-backend.sh
```

### **System Check**
```bash
./check-system.sh
```

---

## 📍 **Access Points (All on Port 9621)**

| URL | Purpose |
|-----|---------|
| http://localhost:9621/webui/ | Frontend UI |
| http://localhost:9621/docs | API Documentation |
| http://localhost:9621/api/health | Health Check |
| http://localhost:9621 | API Root |

---

## 🎯 **That's Literally All You Need to Know**

1. `./start-backend.sh`
2. Wait 10 seconds for startup message
3. Open http://localhost:9621/webui/
4. Done!

No separate frontend dev server. No multiple ports. Just one simple command.
