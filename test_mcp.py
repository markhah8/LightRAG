#!/usr/bin/env python3
"""
Test LightRAG MCP Server - Verify all tools work
"""

import asyncio
import sys
import json
from lightrag_mcp_server import (
    lightrag_query,
    lightrag_documents,
    lightrag_graph,
    lightrag_health
)


async def test_mcp():
    """Test all MCP tools"""
    print("=" * 60)
    print("🧪 Testing LightRAG MCP Server")
    print("=" * 60)
    
    tests_passed = 0
    tests_failed = 0
    
    # Test 1: Health Check
    print("\n1️⃣  Testing lightrag_health...")
    try:
        result = await lightrag_health()
        data = json.loads(result)
        if "status" in data or "error" not in data:
            print("   ✅ Health check passed")
            tests_passed += 1
        else:
            print(f"   ❌ Unexpected response: {result[:100]}")
            tests_failed += 1
    except Exception as e:
        print(f"   ❌ Error: {e}")
        tests_failed += 1
    
    # Test 2: List Documents
    print("\n2️⃣  Testing lightrag_documents...")
    try:
        result = await lightrag_documents(offset=0, limit=5)
        data = json.loads(result)
        print(f"   ✅ Found documents: {data.get('items', [])[:2] if isinstance(data, dict) else 'N/A'}")
        tests_passed += 1
    except Exception as e:
        print(f"   ❌ Error: {e}")
        tests_failed += 1
    
    # Test 3: Query Knowledge Base
    print("\n3️⃣  Testing lightrag_query...")
    try:
        result = await lightrag_query("What are the main topics?", mode="local")
        data = json.loads(result)
        if isinstance(data, dict):
            print(f"   ✅ Query returned: {str(data)[:100]}...")
            tests_passed += 1
        else:
            print(f"   ❌ Unexpected response type")
            tests_failed += 1
    except Exception as e:
        print(f"   ❌ Error: {e}")
        tests_failed += 1
    
    # Test 4: Graph Data
    print("\n4️⃣  Testing lightrag_graph...")
    try:
        result = await lightrag_graph(max_nodes=100)
        data = json.loads(result)
        if "nodes_count" in data:
            print(f"   ✅ Graph: {data.get('nodes_count', 0)} nodes, {data.get('edges_count', 0)} edges")
            tests_passed += 1
        else:
            print(f"   ❌ Missing graph data")
            tests_failed += 1
    except Exception as e:
        print(f"   ❌ Error: {e}")
        tests_failed += 1
    
    # Summary
    print("\n" + "=" * 60)
    print(f"📊 Test Results: {tests_passed} passed, {tests_failed} failed")
    print("=" * 60)
    
    return tests_failed == 0


if __name__ == "__main__":
    success = asyncio.run(test_mcp())
    sys.exit(0 if success else 1)
