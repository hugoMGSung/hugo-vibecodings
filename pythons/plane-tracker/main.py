from pathlib import Path

from fastapi import FastAPI, Request, WebSocket
from fastapi.responses import HTMLResponse, Response
from fastapi.templating import Jinja2Templates
import asyncio
import math
import random

app = FastAPI()
BASE_DIR = Path(__file__).resolve().parent
templates = Jinja2Templates(directory=str(BASE_DIR / "templates"))

planes = [
    {
        "id": "HL-7301",
        "flight": "KAL1201",
        "airline": "Korean Air",
        "model": "Boeing 737-900",
        "lat": 37.468,
        "lng": 126.450,
        "altitude": 8200,
        "speed": 268,
        "heading": 82,
        "origin": "ICN",
        "destination": "PUS",
        "status": "Climbing",
    },
    {
        "id": "HL-8254",
        "flight": "AAR8703",
        "airline": "Asiana Airlines",
        "model": "Airbus A321",
        "lat": 37.552,
        "lng": 126.792,
        "altitude": 12400,
        "speed": 312,
        "heading": 140,
        "origin": "GMP",
        "destination": "CJU",
        "status": "En Route",
    },
    {
        "id": "HL-8317",
        "flight": "JJA142",
        "airline": "Jeju Air",
        "model": "Boeing 737-800",
        "lat": 37.360,
        "lng": 126.635,
        "altitude": 6100,
        "speed": 244,
        "heading": 310,
        "origin": "CJU",
        "destination": "GMP",
        "status": "Approach",
    },
    {
        "id": "HL-7720",
        "flight": "TWB212",
        "airline": "T'way Air",
        "model": "Boeing 737-800",
        "lat": 37.220,
        "lng": 126.960,
        "altitude": 15800,
        "speed": 338,
        "heading": 35,
        "origin": "PUS",
        "destination": "ICN",
        "status": "En Route",
    },
]

AIRSPACE_BOUNDS = {
    "min_lat": 36.95,
    "max_lat": 37.75,
    "min_lng": 126.15,
    "max_lng": 127.35,
}


def inside_airspace(lat, lng):
    return (
        AIRSPACE_BOUNDS["min_lat"] <= lat <= AIRSPACE_BOUNDS["max_lat"]
        and AIRSPACE_BOUNDS["min_lng"] <= lng <= AIRSPACE_BOUNDS["max_lng"]
    )


def move_plane(plane):
    heading = (plane["heading"] + random.uniform(-5, 5)) % 360
    distance = random.uniform(0.0025, 0.0065)
    rad = math.radians(heading)
    next_lat = plane["lat"] + math.cos(rad) * distance
    next_lng = plane["lng"] + math.sin(rad) * distance

    if inside_airspace(next_lat, next_lng):
        plane["lat"] = next_lat
        plane["lng"] = next_lng
        plane["heading"] = int(heading)
    else:
        plane["heading"] = int((heading + 165 + random.uniform(-25, 25)) % 360)

    altitude_delta = random.randint(-180, 180)
    if plane["status"] == "Climbing":
        altitude_delta += 120
    elif plane["status"] == "Approach":
        altitude_delta -= 160

    plane["altitude"] = max(1200, min(36000, plane["altitude"] + altitude_delta))
    plane["speed"] = int(max(120, min(480, plane["speed"] + random.uniform(-8, 8))))


@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    return templates.TemplateResponse(request, "index.html", {})


@app.get("/favicon.ico", include_in_schema=False)
async def favicon():
    return Response(status_code=204)


@app.websocket("/ws/planes")
async def plane_ws(websocket: WebSocket):
    await websocket.accept()

    try:
        while True:
            for plane in planes:
                move_plane(plane)

            await websocket.send_json(planes)
            await asyncio.sleep(2)

    except Exception:
        pass
