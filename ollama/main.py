from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import sqlite3
import json
import os

app = FastAPI(title="TODO API", version="1.0.0")

DATABASE_FILE = "todos.db"

# TODO 모델 정의
class Todo(BaseModel):
    title: str
    description: Optional[str] = None
    completed: bool = False

class TodoResponse(Todo):
    id: int
    created_at: datetime
    completed_at: Optional[datetime] = None

# 데이터베이스 설정
def get_db_connection():
    conn = sqlite3.connect(DATABASE_FILE)
    return conn

def init_db():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            completed INTEGER DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            completed_at TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

# 초기화
init_db()

# 엔드포인트 구현
@app.get("/todos")
async def list_todos():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM todos ORDER BY created_at DESC')
    todos = cursor.fetchall()
    conn.close()

    return [
        {
            "id": todo[0],
            "title": todo[1],
            "description": todo[2],
            "completed": bool(todo[3]),
            "created_at": todo[4],
            "completed_at": todo[5]
        } for todo in todos
    ]

@app.post("/todos")
async def create_todo(todo: Todo):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO todos (title, description, completed)
        VALUES (?, ?, ?)
    ''', (todo.title, todo.description, todo.completed))
    todo_id = cursor.lastrowid
    created_at = datetime.now().isoformat()

    cursor.execute('''
        SELECT * FROM todos WHERE id = ?
    ''', (todo_id,))
    row = cursor.fetchone()
    conn.close()

    return {
        "id": row[0],
        "title": row[1],
        "description": row[2],
        "completed": bool(row[3]),
        "created_at": row[4],
        "completed_at": row[5]
    }

@app.put("/todos/{todo_id}")
async def update_todo(todo_id: int, todo: Todo):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        UPDATE todos
        SET title = ?, description = ?, completed = ?
        WHERE id = ?
    ''', (todo.title, todo.description, todo.completed, todo_id))

    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="TODO 를 찾을 수 없습니다")

    cursor.execute('''
        SELECT * FROM todos WHERE id = ?
    ''', (todo_id,))
    row = cursor.fetchone()
    conn.close()

    return {
        "id": row[0],
        "title": row[1],
        "description": row[2],
        "completed": bool(row[3]),
        "created_at": row[4],
        "completed_at": row[5]
    }

@app.delete("/todos/{todo_id}")
async def delete_todo(todo_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('DELETE FROM todos WHERE id = ?', (todo_id,))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="TODO 를 찾을 수 없습니다")

    conn.close()
    return {"message": "TODO 가 삭제되었습니다"}

@app.get("/todos/{todo_id}/toggle")
async def toggle_todo(todo_id: int):
    # TODO 항목의 완료 상태를 토글하는 엔드포인트
    conn = get_db_connection()
    cursor = conn.cursor()

    # 완료 상태를 반전하고, 완료된 경우 completed_at 을 현재 시간으로 설정
    cursor.execute('''
        UPDATE todos
        SET completed = NOT completed,
            completed_at = CASE completed THEN NULL ELSE CURRENT_TIMESTAMP END
        WHERE id = ?
    ''', (todo_id,))

    # TODO 를 찾지 못하면 404 에러를 발생시킴
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="TODO 를 찾을 수 없습니다")

    # 업데이트된 TODO 데이터를 조회
    cursor.execute('''
        SELECT * FROM todos WHERE id = ?
    ''', (todo_id,))
    row = cursor.fetchone()
    conn.close()

    # 조회된 데이터를 딕셔너리로 반환
    return {
        "id": row[0],
        "title": row[1],
        "description": row[2],
        "completed": bool(row[3]),
        "created_at": row[4],
        "completed_at": row[5]
    }