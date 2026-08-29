output "endpoint" {
  description = "Database endpoint without credentials."
  value       = aws_db_instance.this.address
}

output "master_secret_arn" {
  description = "Secrets Manager ARN containing the managed master credentials."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
  sensitive   = true
}

output "multi_az" {
  description = "Whether Multi-AZ is enabled."
  value       = aws_db_instance.this.multi_az
}
