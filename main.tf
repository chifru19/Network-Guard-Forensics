provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "security_logs" {
  bucket = "cloud-security-logs-bucket"
}resource "aws_s3_bucket" "security_logs" {
  bucket = "cloud-security-logs-bucket"
}

# Fixes CKV_AWS_21 (Versioning)
resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.security_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Fixes CKV_AWS_145 (Encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_encryption" {
  bucket = aws_s3_bucket.security_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Fixes CKV2_AWS_6 (Public Access Block)
resource "aws_s3_bucket_public_access_block" "logs_access" {
  bucket = aws_s3_bucket.security_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}