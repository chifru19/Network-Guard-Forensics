# Use a slim, secure base image
FROM python:3.9-slim

# Set a working directory
WORKDIR /app

# Copy the audit script into the container
COPY security_audit.py .

# Create a non-root user for security (Least Privilege)
RUN useradd -m auditor && chown -R auditor /app
USER auditor

# Command to run the tool
CMD ["python", "security_audit.py"]
