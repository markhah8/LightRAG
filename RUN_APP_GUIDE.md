# 🚀 HƯỚNG DẪN CHẠY LIGHTRAG - ĐỎI CỨU CHI TIẾT

## ⚡ TÓM TẮT (Read This First)

**Chỉ cần 1 dòng lệnh này:**

```bash
cd /Applications/Soft/LightRAG && ./start-backend.sh
```

Rồi mở browser: **http://localhost:9621/webui/**

**Done!** Thế thôi, không cần gì khác.

---

## 📋 BỀN LẦN ĐẦU TIÊN - SETUP DEPENDENCIES

**Chỉ làm 1 lần duy nhất:**

### 1️⃣ Tạo Python Virtual Environment

```bash
cd /Applications/Soft/LightRAG
python -m venv .venv
```

### 2️⃣ Activate Virtual Environment

```bash
source .venv/bin/activate
```

Sau bước này, terminal sẽ thay đổi thành:
```
(.venv) admin@192 LightRAG %
```

### 3️⃣ Cài đặt Python Dependencies

```bash
pip install -e .[api]
pip install pipmaster
```

### 4️⃣ Tạo .env file (nếu chưa có)

```bash
cp env.example .env
```

✅ **Xong setup! Không cần làm lại.**

---

## ▶️ CHẠY APP (Mỗi lần)

### **Cách 1: Dùng Script (Dễ nhất - TỪ ĐÂY ĐẦU)**

```bash
cd /Applications/Soft/LightRAG
./start-backend.sh
```

Output sẽ hiển thị:
```
╔════════════════════════════════════════════════════════════════╗
║          LightRAG Server Starting on Port 9621                ║
╚════════════════════════════════════════════════════════════════╝

📍 Access Points:
   🌐 Frontend: http://localhost:9621/webui/
   📚 API Docs: http://localhost:9621/docs
   🔌 API: http://localhost:9621

⏳ Initializing... (wait 10-15 seconds for full startup)
```

Chờ khoảng **15 giây** cho tới khi thấy:
```
Server is ready to accept connections! 🚀
```

Rồi mở browser: **http://localhost:9621/webui/**

---

### **Cách 2: Manual (Nếu script không chạy được)**

```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
lightrag-server
```

Same output như cách 1. Chờ cho tới khi `Server is ready to accept connections! 🚀`

Rồi mở: **http://localhost:9621/webui/**

---

## 🌐 SỬ DỤNG APP

### Access Points (Tất cả trên cùng port 9621)

| Mục đích | URL |
|---------|-----|
| **Frontend** | http://localhost:9621/webui/ |
| **API Docs** | http://localhost:9621/docs |
| **Health Check** | http://localhost:9621/api/health |

---

## 🆘 LỖI VÀ CÁC CÁC FIX

### ❌ Lỗi: "Port 9621 Already in Use"

**Nghĩa:** Port 9621 đang bị dùng bởi process khác.

**Fix:**

```bash
lsof -i :9621 | grep LISTEN | awk '{print $2}' | xargs kill -9
sleep 2
./start-backend.sh
```

Hoặc nếu lệnh trên không chạy:

```bash
pkill -f lightrag-server
sleep 2
./start-backend.sh
```

---

### ❌ Lỗi: "ModuleNotFoundError: No module named 'pipmaster'"

**Nghĩa:** Chưa cài đặt dependencies.

**Fix:**

```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
pip install -e .[api]
pip install pipmaster
./start-backend.sh
```

---

### ❌ Lỗi: "command not found: lightrag-server"

**Nghĩa:** Virtual environment chưa activate hoặc dependencies chưa cài.

**Fix:**

```bash
cd /Applications/Soft/LightRAG
source .venv/bin/activate
pip install -e .[api]
./start-backend.sh
```

---

### ❌ Frontend không tải lên (Blank page)

**Nguyên nhân:** Backend chưa fully start.

**Fix:** Chờ thêm 10-15 giây, reload browser (Cmd+R hoặc Ctrl+R).

---

### ❌ "Failed to load documents 500 Internal Server Error"

**Nguyên nhân:** Backend gặp lỗi khi query documents.

**Fix:**

```bash
# Kill server
pkill -f lightrag-server
sleep 2

# Xóa storage bị lỗi (nếu cần)
# rm -rf /Applications/Soft/LightRAG/rag_storage/

# Restart
./start-backend.sh
```

---

## 🔍 KIỂM TRA HỆ THỐNG

Để chắc chắn mọi thứ ổn:

```bash
cd /Applications/Soft/LightRAG
./check-system.sh
```

Output sẽ hiển thị:
- ✅ Tất cả passed = OK, chạy `./start-backend.sh`
- ❌ Có failed = Cần fix theo lỗi hiển thị

---

## 📝 QUICK CHECKLIST

Trước khi chạy, confirm:

- [ ] `cd /Applications/Soft/LightRAG`
- [ ] File `.env` tồn tại (chứa `PORT=9621`)
- [ ] Folder `.venv` tồn tại
- [ ] File `start-backend.sh` executable (`chmod +x start-backend.sh`)

Nếu sai điều gì → xem phần "BẦN LẦN ĐẦU TIÊN" ở trên.

---

## 🎯 FLOW CHÍNH XÁCNHẤT

```
1. cd /Applications/Soft/LightRAG
2. source .venv/bin/activate    (nếu chưa activate)
3. ./start-backend.sh
4. Chờ "Server is ready to accept connections! 🚀"
5. Mở http://localhost:9621/webui/ trong browser
6. Sử dụng app
```

---

## ⚠️ KHÔNG LÀM CÁI NÀY

❌ **KHÔNG** chạy Vite dev server riêng (`npm run dev` hay `bun run dev`)  
❌ **KHÔNG** cần 2 ports khác nhau (5173, 9621)  
❌ **KHÔNG** rebuild frontend (`bun run build`) - chỉ cần 1 lần lúc update  
❌ **KHÔNG** tạo vài cái frontend separate  

**Một backend, một port (9621), mọi thứ đều có.**

---

## 💾 LƯỚI KỲ THÊM (Nếu muốn restart hoàn toàn)

```bash
# Kill mọi process LightRAG
pkill -f lightrag-server

# Clean port 9621
lsof -i :9621 | grep LISTEN | awk '{print $2}' | xargs kill -9 2>/dev/null || true

# Chờ
sleep 2

# Restart
cd /Applications/Soft/LightRAG
./start-backend.sh
```

---

## 🎓 LỜI NHẮC HẮN

**Hệ thống chỉ có 1 cách chạy duy nhất:**

```bash
./start-backend.sh
```

**Everything else is wrong.**

Không có cách khác. Không có "variants". Chỉ có 1 cách này.

---

## 📞 TROUBLESHOOT STEP-BY-STEP

**Nếu không chạy được:**

1. Chạy: `./check-system.sh`
2. Xem output → Fix lỗi nào được nêu
3. Chạy lại: `./start-backend.sh`
4. Nếu vẫn lỗi → Check logs:
   ```bash
   tail -100 /Applications/Soft/LightRAG/lightrag.log
   ```

---

**Chúc bạn sử dụng vui vẻ! ✨**
