# 🚀 LightRAG Performance Tuning Guide

## Problem: 600s Timeout

600 seconds = 10 minutes timeout cho document processing. Đây là:
- `TIMEOUT=600` - General operation timeout
- `LLM_TIMEOUT=300` - LLM API timeout (Gemini)
- `EMBEDDING_TIMEOUT=60` - Embedding timeout (Ollama)

## ⚡ Solutions to Speed Up

### 1️⃣ **Enable Parallel Processing** (RECOMMENDED)

Edit `.env`:

```env
# Current settings
MAX_ASYNC=4                    # Max concurrent LLM calls
MAX_PARALLEL_INSERT=2          # Parallel document inserts
EMBEDDING_FUNC_MAX_ASYNC=8     # Parallel embeddings

# Recommended for FASTER processing:
MAX_ASYNC=8                    # Increase LLM parallelism
MAX_PARALLEL_INSERT=4          # Increase document parallel inserts
EMBEDDING_FUNC_MAX_ASYNC=16    # Max out embedding parallelism
```

**Impact:** 2-4x speed improvement

---

### 2️⃣ **Reduce Timeout (if safe)**

Only if you have **fast backend** (low latency):

```env
TIMEOUT=300           # Down from 600 (5 minutes)
LLM_TIMEOUT=180       # Down from 300 (3 minutes)
EMBEDDING_TIMEOUT=30  # Down from 60 (30 seconds)
```

**⚠️ Risk:** Timeouts on slow API calls

---

### 3️⃣ **Use Faster LLM Model**

Currently using: `gemini-2.5-flash` (already optimized)

If even slower, consider:
- ✅ `gemini-2.5-flash` - FASTEST (current)
- ⚠️ `gemini-2.0-flash` - Slower
- ❌ `gemini-1.5-pro` - Slowest but most accurate

---

### 4️⃣ **Optimize Document Chunking**

Edit `.env`:

```env
# Current
CHUNK_SIZE=1200
CHUNK_OVERLAP=100

# For faster processing (less accurate):
CHUNK_SIZE=2000      # Larger chunks = fewer chunks = faster
CHUNK_OVERLAP=0      # No overlap = simpler processing
```

**Trade-off:** Speed vs. accuracy

---

### 5️⃣ **Skip Graph Merging** (Aggressive)

```env
# Set high threshold to skip expensive merges
MAX_MERGE_SIZE=1000  # Only merge if > 1000 nodes
FORCE_LLM_SUMMARY_ON_MERGE=10000  # Almost never merge
```

---

## 📊 **Performance Comparison**

| Setting | Speed | Accuracy | Recommendation |
|---------|-------|----------|-----------------|
| **Default** | Baseline | ✅ Good | Safe, balanced |
| **Parallel x2** | 2x faster | ✅ Same | RECOMMENDED |
| **Parallel x4** | 3-4x faster | ✅ Same | Good for big docs |
| **Larger chunks** | 1.5x faster | ⚠️ Lower | Use with caution |
| **Reduced timeout** | N/A (faster fail) | ❌ Risk | Only if reliable |

---

## 🎯 **Quick Tuning Recipe**

### For **Fast Processing** (recommended):

```env
# Edit .env and set:
MAX_ASYNC=8
MAX_PARALLEL_INSERT=4
EMBEDDING_FUNC_MAX_ASYNC=16
CHUNK_SIZE=1500
CHUNK_OVERLAP=50
```

Then restart:
```bash
pkill -f lightrag-server
./start-backend.sh
```

### For **Large Documents**:

```env
MAX_ASYNC=4
MAX_PARALLEL_INSERT=4
EMBEDDING_FUNC_MAX_ASYNC=8
TIMEOUT=900        # 15 minutes for big files
CHUNK_SIZE=2000    # Process fewer, larger chunks
```

---

## 🔍 **Monitor Performance**

Check logs while processing:

```bash
tail -f /Applications/Soft/LightRAG/lightrag.log | grep -E "Phase|Merged|Completed|Embedding"
```

Look for:
- ✅ `Phase 1: Processing X entities` - Entity extraction
- ✅ `Phase 2: Processing Y relations` - Relation merging
- ✅ `Phase 3: Updating Z entities` - Final update
- ✅ `Completed` - Done!

---

## 📈 **Current Status**

Check current values:

```bash
cd /Applications/Soft/LightRAG && grep -E "^(MAX_ASYNC|MAX_PARALLEL|EMBEDDING_FUNC|CHUNK_SIZE|TIMEOUT)" .env
```

Current:
```
TIMEOUT=600
MAX_ASYNC=4
MAX_PARALLEL_INSERT=2
EMBEDDING_FUNC_MAX_ASYNC=8
CHUNK_SIZE=1200
CHUNK_OVERLAP=100
```

---

## ⚙️ **Advanced: Configure per Component**

### For **LLM (Gemini)**:
- `LLM_TIMEOUT=300` - Gemini response timeout
- `MAX_ASYNC=8` - Parallel Gemini requests
- `LLM_CACHE=true` - Cache LLM responses

### For **Embedding (Ollama)**:
- `EMBEDDING_TIMEOUT=60` - Ollama response time
- `EMBEDDING_FUNC_MAX_ASYNC=16` - Parallel embeddings

### For **Document Processing**:
- `MAX_PARALLEL_INSERT=4` - Parallel doc inserts
- `CHUNK_SIZE=1500` - Chunk granularity
- `FORCE_LLM_SUMMARY_ON_MERGE=8` - Merge threshold

---

## 🚨 **Common Issues**

### "Operation Timeout"
→ Increase timeout or reduce document size

### "Too many parallel requests"
→ Reduce `MAX_ASYNC` or `MAX_PARALLEL_INSERT`

### "Memory usage high"
→ Reduce `MAX_ASYNC` and `MAX_PARALLEL_INSERT`

### "Gemini rate limit"
→ Reduce `MAX_ASYNC` to 2-4
→ Use Ollama if available

---

## 💡 **Best Settings by Use Case**

### Small documents (< 50 pages):
```env
MAX_ASYNC=4
MAX_PARALLEL_INSERT=2
TIMEOUT=300
```

### Medium documents (50-200 pages):
```env
MAX_ASYNC=8
MAX_PARALLEL_INSERT=4
TIMEOUT=600
```

### Large documents (200+ pages):
```env
MAX_ASYNC=4
MAX_PARALLEL_INSERT=2
TIMEOUT=1200
CHUNK_SIZE=2000
```

---

## 📝 **Summary**

✅ **To get 2-4x speedup:** Enable parallel processing
✅ **To handle large files:** Increase timeout and chunk size
✅ **To reduce cost:** Use Ollama instead of Gemini
✅ **Default:** Balanced approach (safest)

**Quick command to apply recommended settings:**

```bash
cat > /tmp/optimize.sh << 'EOF'
cd /Applications/Soft/LightRAG
sed -i '' 's/^MAX_ASYNC=.*/MAX_ASYNC=8/' .env
sed -i '' 's/^MAX_PARALLEL_INSERT=.*/MAX_PARALLEL_INSERT=4/' .env
sed -i '' 's/^EMBEDDING_FUNC_MAX_ASYNC=.*/EMBEDDING_FUNC_MAX_ASYNC=16/' .env
echo "✅ Settings optimized"
grep -E "MAX_ASYNC|MAX_PARALLEL|EMBEDDING_FUNC" .env
EOF
bash /tmp/optimize.sh
```

Then restart backend and process new documents!
