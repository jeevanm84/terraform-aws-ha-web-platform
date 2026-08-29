output "security_group_id" {
  description = "Security group attached to the load balancer."
  value       = aws_security_group.this.id
}

output "target_group_arn" {
  description = "ARN of the application target group."
  value       = aws_lb_target_group.this.arn
}

output "target_group_arn_suffix" {
  description = "Target group ARN suffix used by CloudWatch metrics."
  value       = aws_lb_target_group.this.arn_suffix
}

output "load_balancer_arn_suffix" {
  description = "Load balancer ARN suffix used by CloudWatch metrics."
  value       = aws_lb.this.arn_suffix
}

output "dns_name" {
  description = "Public DNS name of the load balancer."
  value       = aws_lb.this.dns_name
}

output "application_url" {
  description = "Application URL using the configured listener protocol."
  value       = "${var.certificate_arn == null ? "http" : "https"}://${aws_lb.this.dns_name}"
}
