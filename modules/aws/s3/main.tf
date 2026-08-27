resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = merge(var.tags, { ManagedBy = "terraform-module-registry" })
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.access_log_bucket != null ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_log_bucket
  target_prefix = "${var.bucket_name}/"
}

variable "bucket_name" { type = string }
variable "access_log_bucket" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}

output "bucket_id" { value = aws_s3_bucket.this.id }
output "bucket_arn" { value = aws_s3_bucket.this.arn }
