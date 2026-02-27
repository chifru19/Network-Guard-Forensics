# Cloud-Security-Suite: Forensics, DevSecOps & CDR

A professional-grade security repository demonstrating a complete pivot from **Network Forensics** to **Cloud Security Engineering**. This suite features real-time threat detection, automated self-healing cloud remediation, and hardened CI/CD pipelines.

---

## 🏗️ Project 1: Cloud-Native DevSecOps Pipeline
**Focus:** Infrastructure-as-Code (IaC) Hardening & Supply Chain Security

* **Security Guardrails:** Integrated **Checkov** into GitHub Actions to scan Terraform and Docker configurations for 19+ common vulnerabilities.
* **Container Hardening:** Engineered a Dockerfile using non-root user execution and minimal base images to reduce the attack surface.
* **Proof of Work:**
![Pipeline Success](./pipeline_success.jpg.png)

---

## ☁️ Project 2: Real-Time Cloud Audit & Compliance
**Focus:** Active Compliance & Policy Enforcement

* **Audit Engine:** Developed `security_audit.py` using **Boto3** to identify and automatically remediate non-compliant S3 buckets in real-time.
* **Zero-Cost Simulation:** Leveraged **LocalStack** to build and test cloud security tools in an isolated, mock AWS environment.
* **Live Status:** ✅ `Starting Real-Time Audit... No buckets found. Environment is clean.`

---

## 🚨 Project 3: Cloud Intrusion Detection (IDS)
**Focus:** Behavioral Analysis & Threat Identification

* **Custom IDS Engine:** Developed `cloud_detection.py` to monitor real-time API traffic and identify "Brute Force" patterns.
* **Behavioral Analysis:** Triggers a **CRITICAL** alert if more than 5 requests are detected in under 3 seconds.
* **Live Detection Output:**
🚨 `CRITICAL ALERT: Rapid API activity detected! Possible Brute Force Attack.`

---

## 🛡️ Project 4: Automated Cloud Detection & Response (CDR)
**Focus:** Active Defense & Automated Self-Healing

* **Nuke-on-Detection:** Enhanced the engine to execute an immediate `DeleteBucket` response upon verified intrusion, securing the environment in **1.61s**.
* **Infrastructure Resilience:** Resolved complex **Terraform State Locks** by manually clearing lock files and utilizing the `-lock=false` flag to ensure infrastructure availability during security events.
* **Race Condition Mitigation:** Synchronized infrastructure deployment with monitoring to ensure response scripts execute only on verified live resources.

### 🛠️ Response Timeline (Project 4)
| Phase | Action | Result |
| :--- | :--- | :--- |
| **Detection** | Script identifies 6 unauthorized requests | Triggered in **1.61s** |
| **Response** | `auto_remediate()` function executes | **Intrusion Response Initiated** |
| **Recovery** | S3 Bucket is deleted from LocalStack | **Environment Secured** |

---
