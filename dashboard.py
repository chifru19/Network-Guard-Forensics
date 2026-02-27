import streamlit as st
import pandas as pd
import psycopg2
import boto3

# Configuration for Database and LocalStack
DB_CONFIG = "dbname=postgres user=postgres password=securepassword123 host=my-new-postgres port=5432"
S3_ENDPOINT = "http://localstack:4566"

st.set_page_config(page_title="Security Audit Command Center", layout="wide")
st.title("🛡️ Cloud Security Audit Dashboard")
st.markdown("Real-time security monitoring for **LocalStack S3** buckets.")

def get_data():
    conn = psycopg2.connect(DB_CONFIG)
    df = pd.read_sql_query("SELECT * FROM s3_audit_logs ORDER BY created_at DESC", conn)
    conn.close()
    return df

def remediate_buckets():
    # Connects to LocalStack to fix security drift
    s3 = boto3.client("s3", endpoint_url=S3_ENDPOINT, aws_access_key_id="test", aws_secret_access_key="test", region_name="us-east-1")
    buckets = s3.list_buckets()["Buckets"]
    for bucket in buckets:
        s3.put_public_access_block(
            Bucket=bucket["Name"],
            PublicAccessBlockConfiguration={
                'BlockPublicAcls': True, 'IgnorePublicAcls': True,
                'BlockPublicPolicy': True, 'RestrictPublicBuckets': True
            }
        )
    st.success("✅ Remediation Complete: All buckets are now SECURE.")

try:
    data = get_data()

    # Metrics Row
    col1, col2, col3 = st.columns(3)
    col1.metric("Total Audits", len(data))
    col2.metric("Critical Failures", len(data[data['status'] == 'FAIL']))
    col3.metric("Secure Buckets", len(data[data['status'] == 'PASS']))

    # Visualizations
    st.subheader("Security Status Distribution")
    st.bar_chart(data['status'].value_counts())

    # Reporting Section
    st.subheader("📋 Compliance Reporting")
    csv = data.to_csv(index=False).encode('utf-8')
    st.download_button("📥 Download Audit Report (CSV)", data=csv, file_name='security_report.csv', mime='text/csv')

    # Audit Logs Table
    st.subheader("Recent Audit Logs")
    st.dataframe(data, use_container_width=True)

    # Remediation Button
    st.divider()
    if st.button('🔒 Secure All Buckets Now', use_container_width=True):
        remediate_buckets()
        st.rerun()

except Exception as e:
        st.error(f"Waiting for database connection...")