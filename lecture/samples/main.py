from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List

# FastAPI 앱 생성
app = FastAPI()

# -----------------------------
# CORS 설정
# -----------------------------
# 다른 주소(예: index.html)에서 API를 호출할 수 있도록 허용
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # 실습용: 모든 출처 허용
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -----------------------------
# 데이터 모델
# -----------------------------

# 할 일 생성 요청용 모델
class TodoCreate(BaseModel):
    title: str

# 할 일 완료 상태 수정용 모델
class TodoUpdate(BaseModel):
    completed: bool

# 실제 저장/응답용 모델
class Todo(BaseModel):
    id: int
    title: str
    completed: bool

# -----------------------------
# 메모리 저장소
# -----------------------------
todos: List[Todo] = []
next_id = 1

# -----------------------------
# 기본 테스트용 API
# -----------------------------
@app.get("/")
def read_root():
    return {"message": "TODO API is running"}

# -----------------------------
# 할 일 목록 조회
# -----------------------------
@app.get("/todos", response_model=List[Todo])
def get_todos():
    return todos

# -----------------------------
# 할 일 추가
# -----------------------------
@app.post("/todos", response_model=Todo)
def create_todo(todo_data: TodoCreate):
    global next_id

    new_todo = Todo(
        id=next_id,
        title=todo_data.title,
        completed=False
    )

    todos.append(new_todo)
    next_id += 1

    return new_todo

# -----------------------------
# 할 일 완료 상태 변경
# -----------------------------
@app.put("/todos/{todo_id}", response_model=Todo)
def update_todo(todo_id: int, todo_data: TodoUpdate):
    for todo in todos:
        if todo.id == todo_id:
            todo.completed = todo_data.completed
            return todo

    raise HTTPException(status_code=404, detail="Todo not found")

# -----------------------------
# 할 일 삭제
# -----------------------------
@app.delete("/todos/{todo_id}")
def delete_todo(todo_id: int):
    for index, todo in enumerate(todos):
        if todo.id == todo_id:
            del todos[index]
            return {"message": "Todo deleted successfully"}

    raise HTTPException(status_code=404, detail="Todo not found")