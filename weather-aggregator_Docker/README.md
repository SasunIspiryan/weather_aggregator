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


project-weather/
│
├── app.py
├── templates/
│   └── index.html
├── static/
│
├── .env
├── Dockerfile
├── .dockerignore
├── README.md

Run the Container

docker run -p 5000:5000 project-genesis

http://localhost:5000

