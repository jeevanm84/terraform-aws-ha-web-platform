variable "name_prefix" {
  type        = string
  description = "Prefix applied to load balancer resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC in which the load balancer is created."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets used by the internet-facing load balancer."
}

variable "application_port" {
  type        = number
  description = "Port exposed by the application instances."
  default     = 80
}

variable "allowed_ipv4_cidrs" {
  type        = set(string)
  description = "IPv4 CIDRs permitted to reach the public listener."
  default     = ["0.0.0.0/0"]
}

variable "certificate_arn" {
  type        = string
  description = "Optional ACM certificate ARN. When set, HTTP redirects to HTTPS."
  default     = null
  nullable    = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to load balancer resources."
  default     = {}
}
