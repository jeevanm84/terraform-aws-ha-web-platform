variable "aws_region" {
  type        = string
  description = "AWS Region used by the learning environment."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Short project name used in tags and resource names."
  default     = "tf-ha-web"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,15}$", var.project_name))
    error_message = "project_name must be 3-16 lowercase letters, digits, or hyphens and start with a letter."
  }
}

variable "environment" {
  type        = string
  description = "Environment identifier."
  default     = "learning"

  validation {
    condition     = contains(["learning", "dev", "staging", "prod"], var.environment)
    error_message = "environment must be learning, dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR for the VPC."
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Two public subnet CIDRs."
  default     = ["10.42.0.0/24", "10.42.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Two private compute subnet CIDRs."
  default     = ["10.42.10.0/24", "10.42.11.0/24"]
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "Two isolated database subnet CIDRs."
  default     = ["10.42.20.0/24", "10.42.21.0/24"]
}

variable "nat_gateway_mode" {
  type        = string
  description = "single minimizes lab cost; per_az avoids a single egress dependency."
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or per_az."
  }
}

variable "allowed_ipv4_cidrs" {
  type        = set(string)
  description = "IPv4 CIDRs allowed to access the public load balancer."
  default     = ["0.0.0.0/0"]
}

variable "certificate_arn" {
  type        = string
  description = "Optional ACM certificate ARN for HTTPS."
  default     = null
  nullable    = true
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for web servers."
  default     = "t3.micro"
}

variable "min_size" {
  type        = number
  description = "Minimum number of web instances."
  default     = 2
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of web instances."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum number of web instances."
  default     = 4
}

variable "enable_database" {
  type        = bool
  description = "Create RDS. Disabled by default to prevent surprise lab costs."
  default     = false
}

variable "database_instance_class" {
  type        = string
  description = "RDS instance class when enable_database is true."
  default     = "db.t3.micro"
}

variable "database_multi_az" {
  type        = bool
  description = "Enable an RDS standby in another Availability Zone."
  default     = false
}

variable "database_deletion_protection" {
  type        = bool
  description = "Protect RDS from Terraform deletion. Disable before a planned lab teardown."
  default     = false
}

variable "skip_database_final_snapshot" {
  type        = bool
  description = "Skip the final RDS snapshot. Keep true only for disposable learning environments."
  default     = true
}

variable "enable_observability" {
  type        = bool
  description = "Create CloudWatch alarms, dashboard, and SNS topic."
  default     = true
}

variable "alarm_email" {
  type        = string
  description = "Optional email endpoint for alarm notifications."
  default     = null
  nullable    = true
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags merged into every supported resource."
  default     = {}
}
