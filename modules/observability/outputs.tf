output "dashboard_name" {
  description = "Name of the CloudWatch operations dashboard."
  value       = aws_cloudwatch_dashboard.this.dashboard_name
}

output "alarm_topic_arn" {
  description = "SNS topic ARN used by CloudWatch alarms."
  value       = aws_sns_topic.alarms.arn
}
