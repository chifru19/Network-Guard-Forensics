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

# Run the script when the container starts
CMD ["python", "analyze.py"]
