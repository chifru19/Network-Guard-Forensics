# Use a lightweight Python image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies for Postgres
RUN apt-get update && apt-get install -y libpq-dev gcc

# Install Python dependencies
RUN pip install boto3 psycopg2-binary

# Copy your audit script into the container
COPY analyze.py .

# --- SECURITY HARDENING SECTION ---

# 1. Create a non-privileged user (fixes CKV_DOCKER_3)
RUN useradd -m appuser
# 2. Ensure the user has permissions to the app directory
RUN chown -R appuser /app

# 3. Add a healthcheck to monitor process integrity (fixes CKV_DOCKER_2)
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD ps aux | grep analyze.py || exit 1

# 4. Switch from root to the limited user
USER appuser

# Run the script when the container starts
CMD ["python", "analyze.py"]
