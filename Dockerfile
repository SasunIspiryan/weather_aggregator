# ============================================
# Stage 1: Builder Stage
# ============================================
# Use Python 3.11-slim as the base image for building dependencies
FROM python:3.11-slim AS builder

# Set the working directory for the build stage
WORKDIR /build

# Copy requirements.txt for dependency installation
# Placed early to leverage Docker layer caching
COPY requirements.txt .

# Install Python dependencies in the builder stage
# --no-cache-dir reduces image size by not storing pip cache
RUN pip install --no-cache-dir -r requirements.txt


# ============================================
# Stage 2: Runtime Stage (Final Image)
# ============================================
# Use a fresh Python 3.11-slim image for the final runtime
# This keeps the final image small by excluding build artifacts
FROM python:3.11-slim AS runtime

# Set working directory in the runtime container
WORKDIR /app

# Copy installed dependencies from the builder stage
# This avoids reinstalling packages in the final image
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy application source code
COPY . .

# Expose the Flask application and metrics ports
EXPOSE 5000 8000

# Health check (optional but recommended)
# Verifies that the Flask application is responding to requests
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:5000/')" || exit 1

# Set default startup command for Flask application
# Runs Flask development server accessible from outside the container
CMD ["python", "app.py"]


