#!/usr/bin/env python3
"""
LightRAG MCP Server - Expose LightRAG as MCP tools for Claude
Uses FastMCP for simpler implementation
"""

import asyncio
import json
import httpx
from fastmcp import FastMCP

# Configuration
LIGHTRAG_API_URL = "http://localhost:9621"
LIGHTRAG_API_KEY = "lightrag-secure-key-2025"

# Create MCP server
mcp = FastMCP("lightrag")

# Helper to make API calls
async def call_lightrag_api(endpoint: str, method: str = "GET", data: dict = None) -> dict:
    """Call LightRAG API with authentication"""
    headers = {"X-API-Key": LIGHTRAG_API_KEY}
    
    async with httpx.AsyncClient(timeout=30.0) as client:
        url = f"{LIGHTRAG_API_URL}{endpoint}"
        
        try:
            if method == "GET":
                response = await client.get(url, headers=headers)
            elif method == "POST":
                headers["Content-Type"] = "application/json"
                response = await client.post(url, json=data, headers=headers)
            else:
                raise ValueError(f"Unsupported method: {method}")
            
            response.raise_for_status()
            return response.json()
        except httpx.HTTPError as e:
            return {"error": str(e), "status": "API call failed"}


@mcp.tool()
async def lightrag_query(query: str, mode: str = "local") -> str:
    """
    Query LightRAG knowledge base.
    Returns relevant entities, relations, and context.
    
    Args:
        query: The question or search query
        mode: Query mode - 'local' (fast), 'global' (comprehensive), 'hybrid' (balanced)
    """
    if not query:
        return "Error: query parameter is required"
    
    result = await call_lightrag_api(
        "/query",
        method="POST",
        data={
            "query": query,
            "param": {
                "mode": mode,
                "only_need_context": False
            }
        }
    )
    
    return json.dumps(result, indent=2, ensure_ascii=False)


@mcp.tool()
async def lightrag_documents(offset: int = 0, limit: int = 10) -> str:
    """
    List all documents in the knowledge base with their status.
    
    Args:
        offset: Pagination offset (default: 0)
        limit: Number of documents to return (default: 10)
    """
    result = await call_lightrag_api(
        f"/documents/paginated?offset={offset}&limit={limit}",
        method="GET"
    )
    
    return json.dumps(result, indent=2, ensure_ascii=False)


@mcp.tool()
async def lightrag_graph(label: str = "*", max_depth: int = 3, max_nodes: int = 1000) -> str:
    """
    Get knowledge graph data - entities and their relationships.
    
    Args:
        label: Filter by entity/relation label (default: '*' for all)
        max_depth: Maximum graph depth (default: 3)
        max_nodes: Maximum nodes to return (default: 1000)
    """
    result = await call_lightrag_api(
        f"/graphs?label={label}&max_depth={max_depth}&max_nodes={max_nodes}",
        method="GET"
    )
    
    # Format graph data
    nodes = result.get("nodes", [])
    edges = result.get("edges", [])
    
    formatted = {
        "summary": f"Graph with {len(nodes)} nodes and {len(edges)} edges",
        "nodes_count": len(nodes),
        "edges_count": len(edges),
        "nodes_sample": nodes[:10],  # First 10 nodes
        "edges_sample": edges[:10]   # First 10 edges
    }
    
    return json.dumps(formatted, indent=2, ensure_ascii=False)


@mcp.tool()
async def lightrag_health() -> str:
    """Check LightRAG server health and configuration."""
    result = await call_lightrag_api("/api/health", method="GET")
    return json.dumps(result, indent=2, ensure_ascii=False)


if __name__ == "__main__":
    # Run the server
    mcp.run()
