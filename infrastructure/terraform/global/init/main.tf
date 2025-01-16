variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "aws_region" {
  default = "us-east-2"
}

resource "aws_s3_bucket" "logging" {
  bucket = "dflow-prod-s3-logs"
  acl    = "private"


  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "state" {
  bucket = "dflow-terraform-state-use2"
  acl    = "private"

  logging {
    target_bucket = aws_s3_bucket.logging.id
    target_prefix = "terraform/"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging-encryption" {
  bucket = aws_s3_bucket.logging.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state-encryption" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
