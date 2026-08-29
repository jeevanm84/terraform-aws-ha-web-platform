output "security_group_id" {
  description = "Security group attached to application instances."
  value       = aws_security_group.this.id
}

output "autoscaling_group_name" {
  description = "Name of the application Auto Scaling group."
  value       = aws_autoscaling_group.this.name
}

output "desired_capacity" {
  description = "Configured desired instance capacity."
  value       = aws_autoscaling_group.this.desired_capacity
}
