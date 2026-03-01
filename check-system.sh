#!/bin/bash
# LightRAG System Health Check & Setup Validator

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         LightRAG System Health Check & Setup Validator        ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_count=0
pass_count=0
fail_count=0

# Function to check and report
check() {
    local name="$1"
    local command="$2"
    check_count=$((check_count + 1))
    
    echo -n "[$check_count] $name... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅${NC}"
        pass_count=$((pass_count + 1))
    else
        echo -e "${RED}❌${NC}"
        fail_count=$((fail_count + 1))
    fi
}

echo "📋 Checking Files & Configuration..."
check "Python venv exists" "[ -d '.venv' ]"
check ".env file exists" "[ -f '.env' ]"
check ".env has PORT" "grep -q '^PORT=' .env"
check "Frontend .env.development exists" "[ -f 'lightrag_webui/.env.development' ] || [ -f 'lightrag_webui/.env.local' ]"
check "start-backend.sh executable" "[ -x 'start-backend.sh' ]"
check "start-frontend.sh executable" "[ -x 'start-frontend.sh' ]"
check "start-all.sh executable" "[ -x 'start-all.sh' ]"

echo ""
echo "🔧 Checking Installation & Dependencies..."

# Activate venv for Python checks
source .venv/bin/activate

check "Python 3.10+" "python --version | grep -qE '3\.(1[0-9]|[0-9]+)'"
check "pipmaster installed" "python -c 'import pipmaster' 2>/dev/null"
check "uvicorn installed" "python -c 'import uvicorn' 2>/dev/null"
check "fastapi installed" "python -c 'import fastapi' 2>/dev/null"
check "lightrag package installed" "python -c 'from lightrag import LightRAG' 2>/dev/null"

echo ""
echo "🎨 Checking Frontend Setup..."
check "Node/Bun available" "command -v bun"
check "lightrag_webui/node_modules exists" "[ -d 'lightrag_webui/node_modules' ]"
check "package.json exists" "[ -f 'lightrag_webui/package.json' ]"
check "Vite config exists" "[ -f 'lightrag_webui/vite.config.ts' ]"

echo ""
echo "🔌 Checking Port Availability..."
check "Port 9621 available" "! lsof -i :9621 > /dev/null 2>&1"
check "Port 5173 available" "! lsof -i :5173 > /dev/null 2>&1"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo -e "Results: ${GREEN}$pass_count passed${NC} / ${RED}$fail_count failed${NC} / Total $check_count"
echo "════════════════════════════════════════════════════════════════"
echo ""

if [ $fail_count -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed! System is ready to start.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./start-all.sh"
    echo "  2. Open: http://localhost:5173/webui/"
    exit 0
else
    echo -e "${RED}❌ Some checks failed. Fix issues above and try again.${NC}"
    echo ""
    echo "Common fixes:"
    if [ ! -f '.env' ]; then
        echo "  • Create .env: cp env.example .env"
    fi
    if [ ! -d '.venv' ]; then
        echo "  • Create venv: python -m venv .venv"
        echo "  • Activate: source .venv/bin/activate"
        echo "  • Install: pip install -e .[api]"
    fi
    if [ ! -x 'start-backend.sh' ]; then
        echo "  • Make scripts executable: chmod +x start-*.sh"
    fi
    if ! command -v bun > /dev/null 2>&1; then
        echo "  • Install Bun: curl -fsSL https://bun.sh/install | bash"
    fi
    echo ""
    exit 1
fi
