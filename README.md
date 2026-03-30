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


## Docker 

1. Docker Optimization

### Docker Layer History

Output of `docker history dockerfile

IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
8d798cc42c8a   3 minutes ago   CMD ["python" "-m" "flask" "run" "--host" "0…   0B        buildkit.dockerfile.v0
<missing>      3 minutes ago   EXPOSE &{[{{16 0} {16 0}}] 0xc000071700}        0B        buildkit.dockerfile.v0
<missing>      3 minutes ago   COPY . . # buildkit                             10.7kB    buildkit.dockerfile.v0
<missing>      3 minutes ago   RUN /bin/sh -c pip install --no-cache-dir -r…   55.9MB    buildkit.dockerfile.v0
<missing>      4 minutes ago   COPY requirements.txt . # buildkit              251B      buildkit.dockerfile.v0
<missing>      4 minutes ago   WORKDIR /app                                    0B        buildkit.dockerfile.v0
<missing>      9 days ago      CMD ["python3"]                                 0B        buildkit.dockerfile.v0
<missing>      9 days ago      RUN /bin/sh -c set -eux;  for src in idle3 p…   36B       buildkit.dockerfile.v0
<missing>      9 days ago      RUN /bin/sh -c set -eux;   savedAptMark="$(a…   42MB      buildkit.dockerfile.v0
<missing>      9 days ago      ENV PYTHON_SHA256=272179ddd9a2e41a0fc8e42e33…   0B        buildkit.dockerfile.v0
<missing>      9 days ago      ENV PYTHON_VERSION=3.11.15                      0B        buildkit.dockerfile.v0
<missing>      9 days ago      ENV GPG_KEY=A035C8C19219BA821ECEA86B64E628F8…   0B        buildkit.dockerfile.v0
<missing>      9 days ago      RUN /bin/sh -c set -eux;  apt-get update;  a…   3.81MB    buildkit.dockerfile.v0
<missing>      9 days ago      ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      9 days ago      ENV PATH=/usr/local/bin:/usr/local/sbin:/usr…   0B        buildkit.dockerfile.v0
<missing>      10 days ago     # debian.sh --arch 'amd64' out/ 'trixie' '@1…   78.6MB    debuerreotype 0.17


IMAGE CREATED CREATED BY SIZE
CMD ["flask" "run" "--host=0.0.0.0"] 0B
COPY . . 10.7kB
RUN pip install --no-cache-dir -r requirements.txt 55.9MB
COPY requirements.txt . 251B


### Why Copying requirements.txt First Improves Build Speed

Docker uses a layer caching mechanism during builds. By copying the `requirements.txt` file before the rest of the application code, Docker can cache the dependency installation layer. This means that dependencies will only be reinstalled if `requirements.txt` changes. If only application code changes, Docker will reuse the cached dependency layer, significantly speeding up the build process.


## Image Optimization

The Dockerfile uses a multi-stage build to optimize image size:

- **Original single-stage image size**: Approximately 250MB (including build dependencies and cache)
- **New multi-stage image size**: 186MB

This reduction matters because:
- Smaller images result in faster container startup times
- Reduced bandwidth usage when pulling images from registries
- Lower storage requirements on disk and in registries
- Improved security by excluding unnecessary build tools and dependencies from the final image
- Faster deployments in CI/CD pipelines

## Architecture Summary

The application runs in a three-container Docker Compose stack:

1. **postgres**: PostgreSQL database container storing weather data
2. **weather_app**: Flask API container handling business logic and API endpoints
3. **nginx**: Nginx reverse proxy container routing external traffic

**Traffic Flow**:
- User requests → Nginx (listening on host port 8080) → Weather App (internal port 5000) → PostgreSQL (internal port 5432) for data storage/retrieval
- Nginx acts as a reverse proxy, forwarding all incoming HTTP requests to the Flask application
- The Flask app processes requests, interacts with the database as needed, and returns responses through Nginx

## Run Instructions

To run this project locally:

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd weather-aggregator_Docker
   ```

2. **Bring up the entire stack**:
   ```bash
   docker-compose up --build
   ```

3. **Access the application**:
   - API: http://localhost:8080/weather
   - Health check: http://localhost:8080/health
   - Frontend: http://localhost:8080/

4. **Tear down the stack**:
   ```bash
   docker-compose down
   ```

## Submission

All updated code, Dockerfile, docker-compose.yml, nginx.conf, and README.md have been committed and pushed to the repository.
