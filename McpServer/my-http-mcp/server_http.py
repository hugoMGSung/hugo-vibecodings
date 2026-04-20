from mcp.server.fastmcp import FastMCP
from starlette.requests import Request
from starlette.responses import JSONResponse, PlainTextResponse

mcp = FastMCP("My HTTP MCP Server")


@mcp.tool()
def add(a: int, b: int) -> int:
    """두 수를 더합니다."""
    return a + b


@mcp.tool()
def greet(name: str) -> str:
    """간단한 인사말을 반환합니다."""
    return f"안녕하세요, {name}!"


@mcp.custom_route("/", methods=["GET"])
async def index(_: Request) -> PlainTextResponse:
    return PlainTextResponse(
        "MCP server is running.\n"
        "Use an MCP client for POST http://127.0.0.1:8000/mcp\n"
        "Use GET http://127.0.0.1:8000/health for a browser-friendly check.\n"
    )


@mcp.custom_route("/health", methods=["GET"])
async def health(_: Request) -> JSONResponse:
    return JSONResponse(
        {
            "status": "ok",
            "message": "Server is running",
            "mcp_endpoint": "http://127.0.0.1:8000/mcp",
        }
    )


if __name__ == "__main__":
    # HTTP 방식으로 실행
    mcp.run(transport="streamable-http")
