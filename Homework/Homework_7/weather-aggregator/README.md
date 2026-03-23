# Weather Aggregator Startup

## Project Overview

This project is a **Weather Aggregator API and Frontend** built using **Flask**, designed to fetch weather data from a public API and present it in a clean, customized format.  
The project demonstrates a **full-stack workflow**: environment setup, backend API creation, external API integration, frontend rendering, and secure configuration.

---

## Project Purpose

- Build a **startup-ready backend API** using Flask.
- Integrate a **public weather API** to fetch real-time data.
- Transform and customize API data for **user-friendly JSON output**.
- Provide a **frontend interface** to interact with the API.
- Ensure **robustness** with error handling and health checks.
- Maintain **secure configuration** using environment variables.

---

## Sequence of Work

### 1. Project Setup
- Create project directory: `weather-aggregator`.
- Initialize **Python virtual environment** (`venv`) for dependency management.
- Install required Python packages: `flask`, `requests`, `python-dotenv`.
- Create `.env` file to store secret configuration variables such as `APP_ENV`.

### 2. Backend Foundation
- Initialize Flask application in `app.py`.
- Create **first route `/health`**:
  - Purpose: Let external systems (like load balancers or Kubernetes) verify the app is running.
  - Returns JSON: `{"status": "healthy", "version": "1.0.0"}`.
- Ensure **comments** above each line to explain functionality.

### 3. Secret Configuration
- Load `.env` file using `dotenv`.
- Use `os.getenv()` to securely access environment variables like `APP_ENV`.
- Avoid hardcoding secrets directly in Python files.

### 4. Data Engine: Fetching Weather Data
- Create second route `/weather`:
  - Calls **Open-Meteo API** for real-time weather data using `requests.get()`.
  - Parses returned JSON to extract specific information:
    - `temperature`
    - `windspeed`
    - `weather_code`
  - Implements custom logic to classify weather (`Warm` or `Cold`).
- Add **error handling**:
  - If external API fails (`status_code != 200`), return friendly JSON error message.

### 5. Frontend Interface
- Create **HTML page** (`index.html`) to interact with backend API.
- Add **CSS** for simple styling (`style.css`).
- Add **JavaScript** (`script.js`) to fetch `/weather` and dynamically display results.
- Provide a **button** for users to trigger weather data retrieval.

### 6. Testing & Execution
- Run Flask server locally with `flask run`.
- Test endpoints in browser or Postman:
  - `/health` → confirms backend is alive.
  - `/weather` → returns custom JSON with weather data.
- Verify frontend displays live data correctly.

### 7. Documentation
- Create **README.md** describing project, setup instructions, endpoints, and workflow.
- Include details on:
  - Installing dependencies
  - Setting up `.env`
  - Running Flask server
  - Endpoint usage
  - Purpose of each component in the stack

---

## Key Takeaways
- Learned **Flask API creation** and routing.
- Practiced **secure configuration** with environment variables.
- Gained experience in **fetching, parsing, and customizing external API data**.
- Built **full-stack workflow** integrating backend and frontend.
- Developed **robust error handling** for external API failures.
- Maintained **readable, commented, and well-documented code**.

---

## Endpoints Summary

| Endpoint       | Method | Purpose                                             |
|----------------|--------|---------------------------------------------------|
| `/health`      | GET    | Checks if the app is running, returns status JSON |
| `/weather`     | GET    | Fetches weather data, parses, adds custom logic, returns JSON |
| `/`            | GET    | Serves the frontend HTML page                     |

---

## Technology Stack
- Python 3
- Flask
- Requests (for external API calls)
- Python-dotenv (for environment variable management)
- HTML / CSS / JavaScript (frontend)


# Weather Aggregator Startup

## Project Overview

This project is a **Weather Aggregator API and Frontend** built using **Flask**, designed to fetch weather data from a public API and present it in a clean, customized format.  
The project demonstrates a **full-stack workflow**: environment setup, backend API creation, external API integration, frontend rendering, and secure configuration.

---

## Project Purpose

- Build a **startup-ready backend API** using Flask.
- Integrate a **public weather API** to fetch real-time data.
- Transform and customize API data for **user-friendly JSON output**.
- Provide a **frontend interface** to interact with the API.
- Ensure **robustness** with error handling and health checks.
- Maintain **secure configuration** using environment variables.

---

## Sequence of Work

### 1. Project Setup
- Create project directory: `weather-aggregator`.
- Initialize **Python virtual environment** (`venv`) for dependency management.
- Install required Python packages: `flask`, `requests`, `python-dotenv`.
- Create `.env` file to store secret configuration variables such as `APP_ENV`.

### 2. Backend Foundation
- Initialize Flask application in `app.py`.
- Create **first route `/health`**:
  - Purpose: Let external systems (like load balancers or Kubernetes) verify the app is running.
  - Returns JSON: `{"status": "healthy", "version": "1.0.0"}`.
- Ensure **comments** above each line to explain functionality.

### 3. Secret Configuration
- Load `.env` file using `dotenv`.
- Use `os.getenv()` to securely access environment variables like `APP_ENV`.
- Avoid hardcoding secrets directly in Python files.

### 4. Data Engine: Fetching Weather Data
- Create second route `/weather`:
  - Calls **Open-Meteo API** for real-time weather data using `requests.get()`.
  - Parses returned JSON to extract specific information:
    - `temperature`
    - `windspeed`
    - `weather_code`
  - Implements custom logic to classify weather (`Warm` or `Cold`).
- Add **error handling**:
  - If external API fails (`status_code != 200`), return friendly JSON error message.

### 5. Frontend Interface
- Create **HTML page** (`index.html`) to interact with backend API.
- Add **CSS** for simple styling (`style.css`).
- Add **JavaScript** (`script.js`) to fetch `/weather` and dynamically display results.
- Provide a **button** for users to trigger weather data retrieval.

### 6. Testing & Execution
- Run Flask server locally with `flask run`.
- Test endpoints in browser or Postman:
  - `/health` → confirms backend is alive.
  - `/weather` → returns custom JSON with weather data.
- Verify frontend displays live data correctly.

### 7. Documentation
- Create **README.md** describing project, setup instructions, endpoints, and workflow.
- Include details on:
  - Installing dependencies
  - Setting up `.env`
  - Running Flask server
  - Endpoint usage
  - Purpose of each component in the stack

---

## Key Takeaways
- Learned **Flask API creation** and routing.
- Practiced **secure configuration** with environment variables.
- Gained experience in **fetching, parsing, and customizing external API data**.
- Built **full-stack workflow** integrating backend and frontend.
- Developed **robust error handling** for external API failures.
- Maintained **readable, commented, and well-documented code**.

---

## Endpoints Summary

| Endpoint       | Method | Purpose                                             |
|----------------|--------|---------------------------------------------------|
| `/health`      | GET    | Checks if the app is running, returns status JSON |
| `/weather`     | GET    | Fetches weather data, parses, adds custom logic, returns JSON |
| `/`            | GET    | Serves the frontend HTML page                     |

---

## Technology Stack
- Python 3
- Flask
- Requests (for external API calls)
- Python-dotenv (for environment variable management)
- HTML / CSS / JavaScript (frontend)

---

## Setup Instructions

1. **Clone Repository**
   ```bash
   git clone <your-repo-url>
   cd weather-aggregator


---

## Setup Instructions

1. **Clone Repository**
   ```bash
   git clone <your-repo-url>
   cd weather-aggregator

2. Create Virtual Environment

python3 -m venv venv
source venv/bin/activate

3. Install Dependencies

pip install -r requirements.txt

3. Create .env File

APP_ENV=development

4. Run Application

flask run

5. Access

Frontend: http://127.0.0.1:5000/

Health Check: http://127.0.0.1:5000/health

Weather API: http://127.0.0.1:5000/weather


Weather Aggregator API
Project Overview
The Weather Aggregator API is a Flask-based backend service that collects current weather data for multiple cities in Armenia using the Open-Meteo API. The application stores the retrieved data in a PostgreSQL database and automatically removes records older than 30 days.
This project demonstrates how to build a production‑style backend service using Flask, PostgreSQL, SQLAlchemy, and REST APIs.
Technology Stack
·	Python
·	Flask
·	PostgreSQL
·	SQLAlchemy
·	Open‑Meteo API
·	python-dotenv
Project Features
·	REST API built with Flask
·	Weather aggregation for multiple Armenian cities
·	PostgreSQL database integration
·	SQLAlchemy ORM
·	Automatic database table creation
·	Automatic deletion of records older than 30 days
·	Health check endpoint
·	Environment variable configuration


Project Structure
weather-aggregator/

Environment Variables
Create a .env file in the root directory.
Example:
APP_ENV=development
APP_VERSION=1.0

POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_DB=weather_database
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

Database Setup
Create the PostgreSQL database.
CREATE DATABASE weather_database;

The application automatically creates the required table on startup.

Database Table
weather

id           SERIAL PRIMARY KEY
city         VARCHAR(50)
temperature  FLOAT
wind_speed   FLOAT
condition    VARCHAR(50)
timestamp    TIMESTAMP

requirements.txt
Example dependencies:
Flask
Flask-SQLAlchemy
psycopg2-binary
requests
python-dotenv

Running the Application
Start the Flask server:
flask run
Application will run at:
http://127.0.0.1:5000
API Endpoints
Home
/
Returns the frontend page.
Health Check
/health

Example response:
{
  "status": "healthy",
  "version": "1.0"
}

Get Weather For All Cities
/api/v1/all-weather

Fetches weather for all configured cities and stores the results in the database.
curl example
curl http://127.0.0.1:5000/api/v1/all-weather

Get Weather For One City
/api/v1/weather/<city>

Example:
/api/v1/weather/yerevan

curl example
curl http://127.0.0.1:5000/api/v1/weather/yerevan

Example API Response
[
  {
    "city": "Yerevan",
    "temperature": 18.4,
    "wind_speed": 12.1,
    "condition": "Mild"
  }
]

Automatic Data Cleanup
Weather records older than 30 days are automatically deleted.
Cleanup runs:
·	On application startup
·	After new weather data is fetched
Supported Cities
The system aggregates weather data for several Armenian cities including:
·	Yerevan
·	Gyumri
·	Vanadzor
·	Dilijan
·	Hrazdan
·	Abovyan
·	Kapan
·	Goris
·	Sevan
·	Ijevan
·	Armavir
·	Artashat
·	Sisian
Database Schema Diagram
        +-------------------+
        |      weather      |
        +-------------------+
        | id (PK)           |
        | city              |
        | temperature       |
        | wind_speed        |
        | condition         |
        | timestamp         |
        +-------------------+


Screenshots
You can add screenshots of:
·	PostgreSQL table data

·	Frontend page
Future Improvements
Possible enhancements:
·	Weather history endpoint
·	Scheduled background weather updates
·	Frontend dashboard with charts
·	API rate limiting
·	Authentication
·	Production deployment with Gunicorn


