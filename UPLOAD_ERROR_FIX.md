# Upload File Error - "Some files failed to upload"

## Problem
When trying to upload files to LightRAG, you get the error message: **"Some files failed to upload"**

## Root Cause
The error occurs because **Ollama is not running**. LightRAG requires Ollama to:
1. Extract content from uploaded files (PDFs, DOCx, etc.)
2. Generate embeddings for the extracted text
3. Process the documents for knowledge graph construction

## Error Details from Server Log
```
ConnectionError: Failed to connect to Ollama. Please check that Ollama is downloaded, running and accessible. https://ollama.com/download
```

## Solution

### Option 1: Install and Run Ollama (Recommended for Local Development)

1. **Download Ollama** from https://ollama.com/download
2. **Install** according to your OS instructions (macOS, Linux, Windows)
3. **Start Ollama service**:
   ```bash
   # macOS/Linux - if installed as service
   ollama serve
   # or if installed as an app, just launch it
   ```

4. **Pull required models**:
   ```bash
   # Embedding model (required)
   ollama pull nomic-embed-text
   
   # LLM model (for extraction and summarization)
   ollama pull mistral-nemo
   ```

5. **Verify Ollama is running**:
   ```bash
   curl http://localhost:11434/api/tags
   ```
   You should see a JSON response with available models.

### Option 2: Use Alternative LLM/Embedding Providers

If you don't want to run Ollama locally, configure LightRAG to use alternative providers by updating the `.env` file:

#### Using OpenAI:
```env
# In .env file
LLM_BINDING=openai
LLM_MODEL_NAME=gpt-3.5-turbo
OPENAI_API_KEY=your-api-key-here

EMBEDDING_BINDING=openai
EMBEDDING_MODEL_NAME=text-embedding-3-small
```

#### Using Azure OpenAI:
```env
LLM_BINDING=azure_openai
LLM_MODEL_NAME=gpt-35-turbo
AZURE_OPENAI_API_KEY=your-key
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/

EMBEDDING_BINDING=azure_openai
EMBEDDING_MODEL_NAME=text-embedding-3-small
```

#### Using Gemini:
```env
LLM_BINDING=gemini
LLM_MODEL_NAME=gemini-pro
GEMINI_API_KEY=your-api-key

EMBEDDING_BINDING=gemini
EMBEDDING_MODEL_NAME=text-embedding-004
```

Then restart the server:
```bash
pkill -f "lightrag.api.lightrag_server"
cd /Applications/Soft/LightRAG
.venv/bin/python -m lightrag.api.lightrag_server --host 0.0.0.0 --port 9621 &
```

### Option 3: Use Offline LLM/Embedding

If you prefer completely offline operation with no external API calls:

1. **Install offline dependencies**:
   ```bash
   pip install -e ".[api]" -r requirements-offline.txt
   ```

2. **Configure in `.env`**:
   ```env
   LLM_BINDING=lollms
   EMBEDDING_BINDING=ollama
   ```

3. **Use local models** like Hugging Face models without API keys

## Current Server Configuration

Based on your current `.env` file:
- **LLM Binding**: Ollama (mistral-nemo:latest)
- **Embedding Binding**: Ollama
- **Server**: http://localhost:11434 (expected Ollama location)

## Testing the Fix

After implementing the solution:

1. **Verify connection**:
   ```bash
   curl http://localhost:11434/api/tags
   ```

2. **Try uploading a file** through the WebUI at http://localhost:9621

3. **Check server logs**:
   ```bash
   tail -f /Applications/Soft/LightRAG/lightrag.log
   ```
   You should see successful document processing logs instead of connection errors.

## File Upload Process (Once Fixed)

1. Upload → Frontend validates file type & size
2. File saved to `/Applications/Soft/LightRAG/inputs/`
3. Backend queues document for processing
4. Background task extracts content using configured LLM
5. Embeddings generated using configured embedding model
6. Knowledge graph constructed
7. Document indexed for retrieval

## Supported File Types

The system supports: PDF, DOCX, PPTX, XLSX, TXT, MD, JSON, and more.

## Additional Notes

- File upload limit: 200MB (configurable via `MAX_UPLOAD_SIZE`)
- Processing is asynchronous (returns immediately, processes in background)
- Check processing status via the Documents panel
- If you have multiple files, they're processed sequentially (not parallel)
