import boto3
import psycopg2
from botocore.exceptions import ClientError

# Configuration
S3_ENDPOINT = "http://localstack:4566"
DB_CONFIG = "dbname=postgres user=postgres password=securepassword123 host=my-new-postgres port=5432"

def log_to_db(bucket, status, details):
    conn = psycopg2.connect(DB_CONFIG)
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO s3_audit_logs (bucket_name, status, details) VALUES (%s, %s, %s)",
        (bucket, status, details)
    )
    conn.commit()
    cur.close()
    conn.close()

def audit_s3_buckets():
    s3 = boto3.client("s3", endpoint_url=S3_ENDPOINT, aws_access_key_id="test", aws_secret_access_key="test", region_name="us-east-1")
    print("🔍 Starting Persistent Security Audit...")
    
    buckets = s3.list_buckets()["Buckets"]
    for bucket in buckets:
        name = bucket["Name"]
        try:
            public_access = s3.get_public_access_block(Bucket=name)
            config = public_access["PublicAccessBlockConfiguration"]
            
            if config["BlockPublicAcls"] and config["BlockPublicPolicy"]:
                log_to_db(name, "PASS", "Public Access is properly BLOCKED.")
                print(f"✅ {name}: Logged as SECURE.")
            else:
                log_to_db(name, "WARN", "Partial public access allowed.")
                print(f"⚠️  {name}: Logged as WARNING.")
                
        except ClientError as e:
            if e.response["Error"]["Code"] == "NoSuchPublicAccessBlockConfiguration":
                log_to_db(name, "FAIL", "No Public Access Block found!")
                print(f"🚨 {name}: Logged as CRITICAL EXPOSURE.")

if __name__ == "__main__":
    audit_s3_buckets()
