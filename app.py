# --------------------------------
# IMPORTS
# --------------------------------

from flask import Flask, jsonify, render_template, Response, request
import requests
import os
import re
import time
from dotenv import load_dotenv
from flask_sqlalchemy import SQLAlchemy
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timedelta
from flask_cors import CORS
from prometheus_client import (
    CollectorRegistry,
    CONTENT_TYPE_LATEST,
    Counter,
    Histogram,
    generate_latest,
    start_http_server,
)

# --------------------------------
# LOAD ENV VARIABLES
# --------------------------------

load_dotenv()

app = Flask(__name__)

CORS(app)

REGISTRY = CollectorRegistry(auto_describe=True)
REQUESTS = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "path", "code"],
    registry=REGISTRY,
)
LATENCY = Histogram(
    "http_request_duration_seconds",
    "Request latency",
    ["path"],
    registry=REGISTRY,
)


def get_path_template():
    if request.url_rule and request.url_rule.rule:
        return re.sub(r"<[^>]+>", "{param}", str(request.url_rule.rule))
    return request.path or "/"


@app.before_request
def start_timer():
    request._start_time = time.perf_counter()


@app.after_request
def record_metrics(response):
    duration = time.perf_counter() - getattr(request, "_start_time", time.perf_counter())
    path_template = get_path_template()
    REQUESTS.labels(
        method=request.method,
        path=path_template,
        code=str(response.status_code),
    ).inc()
    LATENCY.labels(path=path_template).observe(duration)
    return response


@app.route("/metrics")
def metrics():
    return Response(generate_latest(REGISTRY), mimetype=CONTENT_TYPE_LATEST)


PROMETHEUS_METRICS_PORT = int(os.getenv("PROMETHEUS_METRICS_PORT", "8000"))
if os.getenv("PROMETHEUS_METRICS_ENABLED", "true").lower() == "true":
    try:
        start_http_server(PROMETHEUS_METRICS_PORT, registry=REGISTRY)
    except OSError:
        pass

# --------------------------------
# ENV CONFIG
# --------------------------------

APP_ENV = os.getenv("APP_ENV")
APP_VERSION = os.getenv("APP_VERSION")

DB_USER = os.getenv("POSTGRES_USER")
DB_PASS = os.getenv("POSTGRES_PASSWORD")
DB_NAME = os.getenv("POSTGRES_DB", "weather_db")
DB_HOST = os.getenv("POSTGRES_HOST", "postgres")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")

# Use Postgres when credentials are provided; otherwise fall back to SQLite for local/test runs.
if DB_USER and DB_PASS and DB_HOST:
    app.config["SQLALCHEMY_DATABASE_URI"] = (
        f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
else:
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///weather.db"
    app.config["SQLALCHEMY_ENGINE_OPTIONS"] = {"connect_args": {"check_same_thread": False}}

app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

# --------------------------------
# DATABASE MODEL
# --------------------------------

class Weather(db.Model):
    __tablename__ = "weather"   # ✅ table name (NOT database)

    id = db.Column(db.Integer, primary_key=True)
    city = db.Column(db.String(50))
    temperature = db.Column(db.Float)
    wind_speed = db.Column(db.Float)
    condition = db.Column(db.String(100))
    humidity = db.Column(db.Float, nullable=True)
    pressure = db.Column(db.Float, nullable=True)
    visibility = db.Column(db.Float, nullable=True)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

# Create tables automatically
with app.app_context():
    db.create_all()

# --------------------------------
# ARMENIAN CITY COORDINATES
# --------------------------------

CITIES = {
    "abovyan": {"name": "Abovyan", "lat": 40.2737, "lon": 44.6333},
    "agarak": {"name": "Agarak", "lat": 38.9029, "lon": 46.2200},
    "akhtala": {"name": "Akhtala", "lat": 41.1514, "lon": 44.7646},
    "akhuryan": {"name": "Akhuryan", "lat": 40.7800, "lon": 43.9000},
    "alaverdi": {"name": "Alaverdi", "lat": 41.0977, "lon": 44.6732},
    "aparan": {"name": "Aparan", "lat": 40.5932, "lon": 44.3589},
    "ararat": {"name": "Ararat", "lat": 39.8321, "lon": 44.7057},
    "armavir": {"name": "Armavir", "lat": 40.1545, "lon": 44.0381},
    "artashat": {"name": "Artashat", "lat": 39.9614, "lon": 44.5445},
    "artik": {"name": "Artik", "lat": 40.5473, "lon": 43.9853},
    "ashtarak": {"name": "Ashtarak", "lat": 40.3014, "lon": 44.3620},
    "ayrum": {"name": "Ayrum", "lat": 41.0865, "lon": 44.6682},
    "berd": {"name": "Berd", "lat": 40.8814, "lon": 45.3892},
    "byureghavan": {"name": "Byureghavan", "lat": 40.3147, "lon": 44.5933},
    "chambarak": {"name": "Chambarak", "lat": 40.5966, "lon": 45.3540},
    "charentsavan": {"name": "Charentsavan", "lat": 40.4071, "lon": 44.6436},
    "dilijan": {"name": "Dilijan", "lat": 40.7417, "lon": 44.8630},
    "gavar": {"name": "Gavar", "lat": 40.3539, "lon": 45.1239},
    "goris": {"name": "Goris", "lat": 39.5111, "lon": 46.3389},
    "gyumri": {"name": "Gyumri", "lat": 40.7894, "lon": 43.8475},
    "hrazdan": {"name": "Hrazdan", "lat": 40.4975, "lon": 44.7662},
    "ijevan": {"name": "Ijevan", "lat": 40.8788, "lon": 45.1485},
    "jermuk": {"name": "Jermuk", "lat": 39.8417, "lon": 45.6722},
    "kajaran": {"name": "Kajaran", "lat": 39.1622, "lon": 46.1489},
    "kapan": {"name": "Kapan", "lat": 39.2075, "lon": 46.4058},
    "maralik": {"name": "Maralik", "lat": 40.5752, "lon": 43.8723},
    "martuni": {"name": "Martuni", "lat": 40.1377, "lon": 45.3049},
    "masis": {"name": "Masis", "lat": 39.9808, "lon": 44.5497},
    "meghri": {"name": "Meghri", "lat": 38.9021, "lon": 46.2455},
    "metsamor": {"name": "Metsamor", "lat": 40.1443, "lon": 44.1165},
    "nor_hachn": {"name": "Nor Hachn", "lat": 40.2668, "lon": 44.6895},
    "noyemberyan": {"name": "Noyemberyan", "lat": 41.1724, "lon": 44.9997},
    "sevan": {"name": "Sevan", "lat": 40.5473, "lon": 44.9417},
    "sisian": {"name": "Sisian", "lat": 39.5210, "lon": 46.0310},
    "spitak": {"name": "Spitak", "lat": 40.8321, "lon": 44.2695},
    "stepanavan": {"name": "Stepanavan", "lat": 41.0099, "lon": 44.3853},
    "talin": {"name": "Talin", "lat": 40.3917, "lon": 43.8779},
    "tashir": {"name": "Tashir", "lat": 41.1207, "lon": 44.2846},
    "tsaghkadzor": {"name": "Tsaghkadzor", "lat": 40.5310, "lon": 44.7203},
    "tumanyan": {"name": "Tumanyan", "lat": 41.0007, "lon": 44.6652},
    "vagharshapat": {"name": "Vagharshapat", "lat": 40.1656, "lon": 44.2946},
    "vanadzor": {"name": "Vanadzor", "lat": 40.8128, "lon": 44.4883},
    "vardenis": {"name": "Vardenis", "lat": 40.1827, "lon": 45.7311},
    "vayk": {"name": "Vayk", "lat": 39.6889, "lon": 45.4661},
    "vedi": {"name": "Vedi", "lat": 39.9144, "lon": 44.7268},
    "yeghegnadzor": {"name": "Yeghegnadzor", "lat": 39.7639, "lon": 45.3324},
    "yerevan": {"name": "Yerevan", "lat": 40.1792, "lon": 44.4991}
}

CITY_ALIASES = {
    "echmiadzin": "vagharshapat",
    "ejmiatsin": "vagharshapat",
    "megri": "meghri"
}

CURRENT_FIELDS = [
    "temperature_2m",
    "relative_humidity_2m",
    "pressure_msl",
    "visibility",
    "wind_speed_10m",
    "weather_code"
]

WEATHER_CODES = {
    0: "Clear sky",
    1: "Mainly clear",
    2: "Partly cloudy",
    3: "Overcast",
    45: "Fog",
    48: "Rime fog",
    51: "Light drizzle",
    53: "Drizzle",
    55: "Dense drizzle",
    56: "Freezing drizzle",
    57: "Heavy freezing drizzle",
    61: "Light rain",
    63: "Rain",
    65: "Heavy rain",
    66: "Freezing rain",
    67: "Heavy freezing rain",
    71: "Light snow",
    73: "Snow",
    75: "Heavy snow",
    77: "Snow grains",
    80: "Rain showers",
    81: "Heavy rain showers",
    82: "Violent rain showers",
    85: "Snow showers",
    86: "Heavy snow showers",
    95: "Thunderstorm",
    96: "Thunderstorm with hail",
    99: "Severe thunderstorm"
}


def normalize_city_key(city_name):
    normalized_name = city_name.lower()
    return CITY_ALIASES.get(normalized_name, normalized_name)


def build_forecast_url(lat, lon):
    current_fields = ",".join(CURRENT_FIELDS)
    return (
        "https://api.open-meteo.com/v1/forecast"
        f"?latitude={lat}&longitude={lon}"
        f"&current={current_fields}"
        "&wind_speed_unit=kmh&timezone=auto"
    )


def get_weather_condition(weather_code):
    return WEATHER_CODES.get(weather_code, "Unknown")

def get_cached_weather(city_name):
    return Weather.query.filter_by(city=city_name).order_by(
        Weather.timestamp.desc()
    ).first()


def fetch_weather_for_city(city_data):
    lat = city_data["lat"]
    lon = city_data["lon"]
    url = build_forecast_url(lat, lon)

    response = requests.get(url, timeout=8)
    response.raise_for_status()

    data = response.json()
    current = data.get("current")
    if not current:
        raise ValueError("Missing current weather data")

    visibility_meters = current.get("visibility")

    temp = round(current["temperature_2m"], 1)
    wind = round(current["wind_speed_10m"], 1)
    humidity = current.get("relative_humidity_2m")
    pressure = current.get("pressure_msl")
    visibility = None
    if visibility_meters is not None:
        visibility = round(visibility_meters / 1000, 1)

    if humidity is not None:
        humidity = round(humidity, 1)

    if pressure is not None:
        pressure = round(pressure, 1)

    condition = get_weather_condition(current.get("weather_code"))

    return {
        "city": city_data["name"],
        "temperature": temp,
        "wind_speed": wind,
        "condition": condition,
        "humidity": humidity,
        "pressure": pressure,
        "visibility": visibility,
        "cached": False
    }


# --------------------------------
# FRONTEND ROUTE
# --------------------------------

@app.route("/")
def home():
    return render_template("index.html")

# --------------------------------
# HEALTH CHECK
# --------------------------------

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "version": APP_VERSION
    })

# --------------------------------
# CLEAN OLD DATA (30 DAYS)
# --------------------------------

def delete_old_data():
    cutoff = datetime.utcnow() - timedelta(days=30)

    deleted = Weather.query.filter(
        Weather.timestamp < cutoff
    ).delete(synchronize_session=False)

    db.session.commit()


# ✅ cleanup on startup

with app.app_context():
    db.create_all()
    delete_old_data()   

# --------------------------------
# WEATHER AGGREGATION ROUTE
# --------------------------------

@app.route("/api/v1/all-weather")
def all_weather():
    weather_results = []
    pending = {}

    with ThreadPoolExecutor(max_workers=8) as executor:
        for city_data in CITIES.values():
            pending[executor.submit(fetch_weather_for_city, city_data)] = city_data

        for future in as_completed(pending):
            city_data = pending[future]
            try:
                result = future.result()
                weather_results.append(result)
                db.session.add(Weather(
                    city=result["city"],
                    temperature=result["temperature"],
                    wind_speed=result["wind_speed"],
                    condition=result["condition"],
                    humidity=result["humidity"],
                    pressure=result["pressure"],
                    visibility=result["visibility"],
                    timestamp=datetime.utcnow()
                ))
            except Exception as err:
                cached = get_cached_weather(city_data["name"])
                if cached:
                    weather_results.append({
                        "city": cached.city,
                        "temperature": cached.temperature,
                        "wind_speed": cached.wind_speed,
                        "condition": cached.condition,
                        "humidity": cached.humidity,
                        "pressure": cached.pressure,
                        "visibility": cached.visibility,
                        "error": "Using cached data due to API failure"
                    })
                else:
                    weather_results.append({
                        "city": city_data["name"],
                        "error": str(err)
                    })

    weather_results.sort(key=lambda item: item["city"])
    db.session.commit()
    delete_old_data()

    return jsonify(weather_results)

# --------------------------------
# WEATHER ENDPOINT (ALIAS FOR API)
# --------------------------------

@app.route("/weather")
def weather():
    # Simple alias to all_weather for convenience
    return all_weather()

# --------------------------------
# SINGLE CITY ROUTE
# --------------------------------

@app.route("/api/v1/weather/<city>")
def get_city_weather(city):

    city = normalize_city_key(city)

    if city not in CITIES:
        return jsonify({"error": "City not found"}), 404

    city_data = CITIES[city]

    try:
        result = fetch_weather_for_city(city_data)
        db.session.add(Weather(
            city=result["city"],
            temperature=result["temperature"],
            wind_speed=result["wind_speed"],
            condition=result["condition"],
            humidity=result["humidity"],
            pressure=result["pressure"],
            visibility=result["visibility"],
            timestamp=datetime.utcnow()
        ))
        db.session.commit()
        delete_old_data()
        return jsonify(result)

    except Exception as e:
        cached = get_cached_weather(city_data["name"])
        if cached:
            return jsonify({
                "city": cached.city,
                "temperature": cached.temperature,
                "wind_speed": cached.wind_speed,
                "condition": cached.condition,
                "humidity": cached.humidity,
                "pressure": cached.pressure,
                "visibility": cached.visibility,
                "error": "Using cached data due to API failure"
            })

        return jsonify({"error": str(e)}), 500

# --------------------------------
# RUN APP
# --------------------------------

if __name__ == "__main__":

    debug_mode = True if APP_ENV != "production" else False

    app.run(host="0.0.0.0", debug=debug_mode)