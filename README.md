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

## Recent Changes

### Fixed: Root Route 404 Error (April 6, 2026)
**Issue:** Accessing `http://127.0.0.1:5000/` returned a 404 "Not Found" error.

**Root Cause:** The root route (`@app.route("/")`) was commented out in `app.py`, leaving no handler for requests to the root path.

**Solution:** Uncommented the home route to serve `index.html` at the root path.

**Changed Files:**
- **[app.py](app.py)** (Lines 90-96)
  - Uncommented `@app.route("/")` decorator
  - Uncommented `home()` function that returns `render_template("index.html")`

**Code Change:**
```python
# Before:
# @app.route("/")
# def home():
#     return render_template("index.html")

# After:
@app.route("/")
def home():
    return render_template("index.html")
```

**Result:** Frontend is now accessible at `http://127.0.0.1:5000/` without 404 errors.

### Fixed: Git Push Error (April 6, 2026)
**Issue:** `git push -u origin weather_aggregator` failed with "src refspec weather_aggregator does not match any".

**Root Cause:** The local `weather_aggregator` branch existed but had no commits, and the remote branch had different commits.

**Solution:** 
1. Added all project files: `git add .`
2. Created initial commit: `git commit -m "Initial commit: Weather Aggregator with Flask, PostgreSQL, Docker, and Ansible integration"`
3. Force pushed to overwrite remote: `git push -u origin weather_aggregator --force`

**Result:** All project files (including Ansible integration) successfully pushed to GitHub.

### Added: Ansible Docker Container Management (April 6, 2026)
**New Features:**
- **[ansible.cfg](ansible.cfg)** - Docker-optimized Ansible configuration
- **[inventory.yml](inventory.yml)** - Container inventory with Docker connection method
- **[ansible-ping.sh](ansible-ping.sh)** - Automated infrastructure testing script

**Capabilities:**
- Native Docker connection (no SSH required)
- Automatic container startup if stopped
- 10 comprehensive infrastructure tests
- All containers responding to Ansible commands

## Submission

All updated code, Dockerfile, docker-compose.yml, nginx.conf, and README.md have been committed and pushed to the repository.

---

## Ansible Docker Container Management

### Overview
Ansible is configured to manage and test your running Docker containers using the native **Docker connection plugin**. This eliminates the need for SSH daemons inside containers, providing direct communication with the Docker API.

### Files
- **[inventory.yml](inventory.yml)** - Ansible inventory defining all container hosts and connection methods
- **[ansible.cfg](ansible.cfg)** - Ansible configuration with Docker-optimized settings
- **[ansible-ping.sh](ansible-ping.sh)** - Executable script containing ad-hoc Ansible commands for infrastructure testing

### Quick Start

#### 1. Automatic Container Management
The `ansible-ping.sh` script automatically checks if containers are running and starts them if needed:
```bash
chmod +x ansible-ping.sh
./ansible-ping.sh  # Containers will start automatically if stopped
```

#### Manual Container Management (Optional)
If you prefer to manage containers separately:
```bash
# Start containers
docker-compose up -d

# Verify containers are running
docker ps

# Stop containers
docker-compose down
```

### Container Mapping
| Ansible Host | Docker Container | Purpose |
|--------------|------------------|---------|
| `weather_app` | `python_app` | Flask Weather API Backend |
| `postgres_db` | `postgres_db` | PostgreSQL Database |
| `nginx` | `nginx_proxy` | Nginx Reverse Proxy |
| `web_frontend` | `frontend_app` | Frontend Web Application |

### Ansible Inventory Structure
The `inventory.yml` file organizes containers into logical groups:
- **backend** - Flask application container (supports Python modules)
- **database** - PostgreSQL container (uses raw/shell modules)
- **proxy** - Nginx container (uses raw/shell modules)
- **frontend** - Frontend container (uses raw/shell modules)

### Configuration: ansible.cfg

The `ansible.cfg` file contains critical Docker-optimized settings:

```ini
# Remote temporary directory (avoids permission issues in containers)
remote_tmp = /tmp/.ansible
local_tmp = /tmp/.ansible

# Connection method
connection = docker
timeout = 30

# Disable host key checking (containers use temporary keys)
host_key_checking = False
```

**Why these settings matter:**
- **remote_tmp = /tmp/.ansible** - Uses system temp instead of home directory (containers often lack write permissions in home)
- **connection = docker** - Uses Docker API directly (no SSH needed)
- **host_key_checking = False** - Containers don't have persistent SSH keys

### Connection Method
All containers use `ansible_connection: docker` for native Docker API communication:
- **No SSH required** - Direct container execution via Docker CLI
- **No port forwarding** - Uses Docker socket directly
- **No additional services** - Works with standard container images

### Testing Infrastructure

The `ansible-ping.sh` script performs 10 automated tests:

1. **Backend Ping** - Test Docker connection to Flask container
2. **Python Version** - Check Python version in backend
3. **PostgreSQL Verification** - Confirm database is running
4. **Database Connection** - Test PostgreSQL connectivity status
5. **System Info** - Gather OS information from backend
6. **Nginx Configuration** - Validate Nginx config syntax
7. **Running Services** - Check Python processes on backend
8. **Filesystem Usage** - Check disk space on database
9. **Frontend Status** - Check frontend web files
10. **Service Port** - Check Flask service availability

### Example Ad-Hoc Commands

Ping all backend services:
```bash
ansible backend -i inventory.yml -m raw -a "echo 'test'"
```

Execute raw command on database:
```bash
ansible database -i inventory.yml -m raw -a "psql --version"
```

Run command on all containers:
```bash
ansible all -i inventory.yml -m raw -a "echo 'Connected via Docker!'"
```

### Module Selection
- **Backend (weather_app)** - Can use raw, command, or shell modules
- **Other containers** - Use `raw` module (no Python required)

### Troubleshooting

If you see "Failed to create temporary directory" error:
1. Ensure `ansible.cfg` exists in the project root
2. Verify `remote_tmp = /tmp/.ansible` setting
3. Use `raw` module instead of `shell` or `command` modules
4. Run `docker-compose down && docker-compose up -d` to restart containers
