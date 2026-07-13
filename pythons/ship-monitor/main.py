from pathlib import Path

from fastapi import FastAPI, WebSocket
from fastapi.responses import HTMLResponse, Response
from fastapi.templating import Jinja2Templates
from fastapi import Request
import asyncio
import math
import random

app = FastAPI()
BASE_DIR = Path(__file__).resolve().parent
templates = Jinja2Templates(directory=str(BASE_DIR / "templates"))

ships = [
    {"id": "BUSAN-001", "name": "Hugo Carrier", "lat": 35.062, "lng": 129.045, "speed": 12.4, "course": 120},
    {"id": "BUSAN-002", "name": "Izy Tanker", "lat": 35.072, "lng": 129.075, "speed": 8.7, "course": 150},
    {"id": "BUSAN-003", "name": "Yomi Ferry", "lat": 35.025, "lng": 129.105, "speed": 15.2, "course": 80},
]

# Demo-only navigable water areas around Busan port.
# Points are (lat, lng). Real AIS apps should use coastline/harbor GIS data instead.
NAVIGABLE_AREAS = [
    [
        (35.088, 129.000),
        (35.082, 129.022),
        (35.071, 129.040),
        (35.073, 129.081),
        (35.054, 129.091),
        (35.041, 129.068),
        (35.045, 129.032),
        (35.060, 129.006),
    ],
    [
        (35.060, 129.075),
        (35.050, 129.106),
        (35.019, 129.132),
        (34.995, 129.107),
        (35.010, 129.075),
        (35.038, 129.060),
    ],
    [
        (35.094, 128.955),
        (35.083, 128.996),
        (35.047, 129.009),
        (35.028, 128.975),
        (35.052, 128.930),
    ],
]


def point_in_polygon(lat, lng, polygon):
    inside = False
    j = len(polygon) - 1

    for i, (lat_i, lng_i) in enumerate(polygon):
        lat_j, lng_j = polygon[j]
        crosses = (lng_i > lng) != (lng_j > lng)
        if crosses:
            intersect_lat = (lat_j - lat_i) * (lng - lng_i) / (lng_j - lng_i) + lat_i
            if lat < intersect_lat:
                inside = not inside
        j = i

    return inside


def is_navigable(lat, lng):
    return any(point_in_polygon(lat, lng, area) for area in NAVIGABLE_AREAS)


def move_ship(ship):
    course = (ship["course"] + random.uniform(-4, 4)) % 360
    distance = random.uniform(0.00008, 0.00022)
    rad = math.radians(course)
    next_lat = ship["lat"] + math.cos(rad) * distance
    next_lng = ship["lng"] + math.sin(rad) * distance

    if is_navigable(next_lat, next_lng):
        ship["lat"] = next_lat
        ship["lng"] = next_lng
        ship["course"] = int(course)
    else:
        ship["course"] = int((course + 150 + random.uniform(-30, 30)) % 360)

    ship["speed"] = round(max(0, ship["speed"] + random.uniform(-0.3, 0.3)), 1)

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
                move_ship(ship)

            await websocket.send_json(ships)
            await asyncio.sleep(2)

    except Exception:
        pass
