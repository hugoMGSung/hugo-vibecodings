from pathlib import Path

from fastapi import FastAPI, WebSocket
from fastapi.responses import HTMLResponse, Response
from fastapi.templating import Jinja2Templates
from fastapi import Request
import asyncio
import random

app = FastAPI()
BASE_DIR = Path(__file__).resolve().parent
templates = Jinja2Templates(directory=str(BASE_DIR / "templates"))

ships = [
    {"id": "BUSAN-001", "name": "Hugo Carrier", "lat": 35.095, "lng": 129.040, "speed": 12.4, "course": 80},
    {"id": "BUSAN-002", "name": "Izy Tanker", "lat": 35.060, "lng": 129.080, "speed": 8.7, "course": 130},
    {"id": "BUSAN-003", "name": "Yomi Ferry", "lat": 35.120, "lng": 129.010, "speed": 15.2, "course": 210},
]

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse(request, "index.html", {})

@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return Response(status_code=204)

@app.websocket("/ws/ships")
async def ship_ws(websocket: WebSocket):
    await websocket.accept()

    try:
        while True:
            for ship in ships:
                ship["lat"] += random.uniform(-0.001, 0.001)
                ship["lng"] += random.uniform(-0.001, 0.001)
                ship["speed"] = round(max(0, ship["speed"] + random.uniform(-0.3, 0.3)), 1)
                ship["course"] = int((ship["course"] + random.uniform(-5, 5)) % 360)

            await websocket.send_json(ships)
            await asyncio.sleep(1)

    except Exception:
        pass
