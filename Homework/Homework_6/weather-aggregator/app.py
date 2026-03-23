# Import Flask class to create the web application
from flask import Flask, jsonify, render_template

# Import requests library to make HTTP requests to external APIs
import requests

# Import os module to read environment variables
import os

# Import dotenv to load variables from .env file
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Create Flask application instance
app = Flask(__name__)

# Read APP_ENV variable from environment
APP_ENV = os.getenv("APP_ENV")

# ---------------------------------------------------------
# ROUTE 1 : HEALTH CHECK
# ---------------------------------------------------------

# This route is used by load balancers and Kubernetes
# to verify that the application is alive and working
@app.route("/health")

def health():

    # Create a dictionary with the application status
    response = {
        "status": "healthy",
        "version": "1.0.0"
    }

    # Convert dictionary into JSON response
    return jsonify(response)


# ---------------------------------------------------------
# ROUTE 2 : HOME PAGE
# ---------------------------------------------------------

# This route serves the frontend HTML page
@app.route("/")
def home():

    # render_template loads HTML from templates folder
    return render_template("index.html")


# ---------------------------------------------------------
# ROUTE 3 : WEATHER API
# ---------------------------------------------------------

# This endpoint fetches weather data from Open-Meteo API
@app.route("/weather")

def get_weather():

    # Latitude and longitude for Yerevan Armenia
    latitude = 40.18
    longitude = 44.51

    # External API URL
    url = f"https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current_weather=true"

    # Send GET request to the external weather API
    response = requests.get(url)

    # Check if the API request was successful
    if response.status_code == 200:

        # Convert response JSON to Python dictionary
        data = response.json()

        # Extract specific data from JSON
        temperature = data["current_weather"]["temperature"]
        windspeed = data["current_weather"]["windspeed"]
        weathercode = data["current_weather"]["weathercode"]

        # Custom logic: determine if weather is warm
        if temperature > 20:
            weather_type = "Warm"
        else:
            weather_type = "Cold"

        # Create a custom JSON response
        result = {
            "city": "Yerevan",
            "temperature": temperature,
            "windspeed": windspeed,
            "weather_code": weathercode,
            "condition": weather_type,
            "environment": APP_ENV
        }

        # Return custom JSON
        return jsonify(result)

    else:

        # If API fails return friendly error message
        return jsonify({
            "error": "Weather service unavailable",
            "status_code": response.status_code
        })


# ---------------------------------------------------------
# START APPLICATION
# ---------------------------------------------------------

# This block ensures the app runs only when executed directly
if __name__ == "__main__":

    # Run Flask application in debug mode
    app.run(debug=True)
