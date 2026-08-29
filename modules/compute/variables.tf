variable "name_prefix" {
  type        = string
  description = "Prefix applied to compute resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC in which compute resources are created."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets used by the Auto Scaling group."
}

variable "load_balancer_security_group_id" {
  type        = string
  description = "Only this security group may access the application port."
}

variable "target_group_arn" {
  type        = string
  description = "Load balancer target group attached to the Auto Scaling group."
}

variable "ami_id" {
  type        = string
  description = "AMI used by the launch template."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "application_port" {
  type        = number
  description = "Port served by the web application."
  default     = 80
}

variable "min_size" {
  type        = number
  description = "Minimum Auto Scaling group capacity."
  default     = 2
}

variable "desired_capacity" {
  type        = number
  description = "Desired Auto Scaling group capacity."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Maximum Auto Scaling group capacity."
  default     = 4
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to compute resources."
  default     = {}
}
