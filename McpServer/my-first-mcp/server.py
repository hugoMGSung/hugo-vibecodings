from pathlib import Path
from mcp.server.fastmcp import FastMCP

# MCP 서버 인스턴스 생성
mcp = FastMCP("my-first-server")


@mcp.tool()
def add(a: int, b: int) -> int:
    """두 숫자를 더합니다."""
    return a + b


@mcp.tool()
def multiply(a: int, b: int) -> int:
    """두 숫자를 곱합니다."""
    return a * b


@mcp.tool()
def greet(name: str) -> str:
    """사용자 이름을 받아 인사말을 반환합니다."""
    return f"안녕하세요, {name}님. MCP 서버가 정상 동작 중입니다."

@mcp.tool()
def read_text_file(path: str) -> str:
    """
    텍스트 파일 내용을 읽어옵니다.
    예: C:\\mcp\\my-first-mcp\\sample.txt
    """
    file_path = Path(path)

    if not file_path.exists():
        return f"파일이 존재하지 않습니다: {path}"

    if not file_path.is_file():
        return f"파일이 아닙니다: {path}"

    try:
        return file_path.read_text(encoding="utf-8")
    except Exception as e:
        return f"파일 읽기 실패: {e}"


if __name__ == "__main__":
    # 기본적으로 로컬 테스트용 stdio 실행
    mcp.run()