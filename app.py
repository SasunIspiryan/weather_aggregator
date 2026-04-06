# --------------------------------
# IMPORTS
# --------------------------------

from flask import Flask, jsonify, render_template
import requests
import os
from dotenv import load_dotenv
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, timedelta
from flask_cors import CORS

# --------------------------------
# LOAD ENV VARIABLES
# --------------------------------

load_dotenv()

app = Flask(__name__)

CORS(app)

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

# PostgreSQL connection string
app.config["SQLALCHEMY_DATABASE_URI"] = (
    f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

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
    condition = db.Column(db.String(50))
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)

# Create tables automatically
with app.app_context():
    db.create_all()

# --------------------------------
# ARMENIAN CITY COORDINATES
# --------------------------------

CITIES = {
    "yerevan": {"name": "Yerevan", "lat": 40.1792, "lon": 44.4991},
    "gyumri": {"name": "Gyumri", "lat": 40.7894, "lon": 43.8475},
    "vanadzor": {"name": "Vanadzor", "lat": 40.8128, "lon": 44.4883},
    "dilijan": {"name": "Dilijan", "lat": 40.7417, "lon": 44.8630},
    "hrazdan": {"name": "Hrazdan", "lat": 40.4975, "lon": 44.7662},
    "abovyan": {"name": "Abovyan", "lat": 40.2737, "lon": 44.6333},
    "kapan": {"name": "Kapan", "lat": 39.2075, "lon": 46.4058},
    "goris": {"name": "Goris", "lat": 39.5111, "lon": 46.3389},
    "sevan": {"name": "Sevan", "lat": 40.5473, "lon": 44.9417},
    "ijevan": {"name": "Ijevan", "lat": 40.8788, "lon": 45.1485},
    "armavir": {"name": "Armavir", "lat": 40.1545, "lon": 44.0381},
    "artashat": {"name": "Artashat", "lat": 39.9614, "lon": 44.5445},
    "sisian": {"name": "Sisian", "lat": 39.5210, "lon": 46.0310},
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

    for city_key, city_data in CITIES.items():

        lat = city_data["lat"]
        lon = city_data["lon"]

        url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true"

        try:
            response = requests.get(url, timeout=5)

            if response.status_code == 200:

                data = response.json()

                temp = data["current_weather"]["temperature"]
                wind = data["current_weather"]["windspeed"]

                if temp > 20:
                    condition = "Warm ☀️"
                elif temp > 10:
                    condition = "Mild 🌤"
                else:
                    condition = "Cold ❄️"

                # SAVE TO DATABASE
                new_record = Weather(
                    city=city_data["name"],
                    temperature=temp,
                    wind_speed=wind,
                    condition=condition,
                    timestamp=datetime.utcnow()
                )

                db.session.add(new_record)

                weather_results.append({
                    "city": city_data["name"],
                    "temperature": temp,
                    "wind_speed": wind,
                    "condition": condition
                })

            else:
                weather_results.append({
                    "city": city_data["name"],
                    "error": "API failed"
                })

        except Exception as e:
            weather_results.append({
                "city": city_data["name"],
                "error": str(e)
            })

    # Commit all inserts
    db.session.commit()

    # Delete old data (30 days)
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

    city = city.lower()

    if city not in CITIES:
        return jsonify({"error": "City not found"}), 404

    city_data = CITIES[city]

    lat = city_data["lat"]
    lon = city_data["lon"]

    url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current_weather=true"

    try:
        response = requests.get(url, timeout=5)

        if response.status_code != 200:
            return jsonify({"error": "Weather API failed"}), 500

        data = response.json()

        temp = data["current_weather"]["temperature"]
        wind = data["current_weather"]["windspeed"]

        return jsonify({
            "city": city_data["name"],
            "temperature": temp,
            "wind_speed": wind
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# --------------------------------
# RUN APP
# --------------------------------

if __name__ == "__main__":

    debug_mode = True if APP_ENV != "production" else False

    app.run(host="0.0.0.0", debug=debug_mode)