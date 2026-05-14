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

# 1. The Main Bucket
resource "aws_s3_bucket" "security_logs" {
  bucket = "cloud-security-logs-bucket"
}

# 2. Fixes CKV_AWS_21: Versioning
resource "aws_s3_bucket_versioning" "logs_versioning" {
  bucket = aws_s3_bucket.security_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Fixes CKV_AWS_145: Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logs_encryption" {
  bucket = aws_s3_bucket.security_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Fixes CKV2_AWS_6: Public Access Block
resource "aws_s3_bucket_public_access_block" "logs_access" {
  bucket = aws_s3_bucket.security_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. Fixes CKV_AWS_18: Access Logging
resource "aws_s3_bucket_logging" "logs_logging" {
  bucket = aws_s3_bucket.security_logs.id

  target_bucket = aws_s3_bucket.security_logs.id
  target_prefix = "log/"
}

# 6. Fixes CKV2_AWS_61: Lifecycle Configuration
resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.security_logs.id

  rule {
    id     = "log-retention"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }
}

# 7. Fixes CKV2_AWS_62: Event Notifications (Placeholders)
# Note: In a real environment, you'd link this to an SQS/SNS ARN.
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.security_logs.id
}