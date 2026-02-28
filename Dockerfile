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
# Create a non-privileged user for security hardening
RUN useradd -m appuser
# Ensure the user has permissions to the app directory
RUN chown -R appuser /app
# Switch from root to the limited user
USER appuser
# Run the script when the container starts
CMD ["python", "analyze.py"]
