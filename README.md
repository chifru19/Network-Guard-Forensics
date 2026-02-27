# 🛡️ Cloud Security & DevSecOps Suite

An automated security auditing and remediation system for **AWS S3** (simulated via LocalStack). This project demonstrates a full DevSecOps loop: **Detect → Log → Visualize → Remediate**.

## 🚀 Features
* **Automated Auditing**: Python-based scanner checks for public S3 buckets.
* **Real-time Dashboard**: Streamlit UI for monitoring security drift and compliance.
* **One-Click Remediation**: Instant "Secure All" button to fix exposed infrastructure.
* **Infrastructure as Code**: Managed via Terraform and Docker Compose.

## ��️ Quick Start
1.  **Start the Environment**:
    ```bash
    docker-compose up -d
    ```
2.  **Trigger a Manual Scan**:
    ```bash
    docker-compose run security-auditor python analyze.py
    ```
3.  **View the Dashboard**:
    Navigate to [http://localhost:8501](http://localhost:8501)

## 🏗️ Tech Stack
* **Cloud**: LocalStack (AWS Simulation)
* **Database**: PostgreSQL
* **App**: Streamlit (Python)
* **Security**: Boto3, TruffleHog (Secret Scanning)
