variable "name_prefix" {
  type        = string
  description = "Prefix applied to observability resources."
}

variable "load_balancer_arn_suffix" {
  type        = string
  description = "Application Load Balancer ARN suffix for CloudWatch dimensions."
}

variable "target_group_arn_suffix" {
  type        = string
  description = "Target group ARN suffix for CloudWatch dimensions."
}

variable "autoscaling_group_name" {
  type        = string
  description = "Auto Scaling group name for CloudWatch dimensions."
}

variable "alarm_email" {
  type        = string
  description = "Optional email address subscribed to platform alarms."
  default     = null
  nullable    = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to observability resources."
  default     = {}
}
