output "state_bucket_name" {
  description = "Bucket name to place in environments/learning/backend.hcl."
  value       = aws_s3_bucket.state.id
}

output "backend_configuration" {
  description = "Values needed by the partial S3 backend configuration."
  value = {
    bucket = aws_s3_bucket.state.id
    region = var.aws_region
  }
}
