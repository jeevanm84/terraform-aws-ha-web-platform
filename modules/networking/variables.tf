variable "name_prefix" {
  type        = string
  description = "Prefix applied to network resource names."
}

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR for the VPC."
}

variable "availability_zones" {
  type        = list(string)
  description = "Exactly two Availability Zones used by this learning platform."

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "availability_zones must contain exactly two zones."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "One public subnet CIDR per Availability Zone."

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "public_subnet_cidrs must contain exactly two CIDRs."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "One private compute subnet CIDR per Availability Zone."

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "private_subnet_cidrs must contain exactly two CIDRs."
  }
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "One isolated database subnet CIDR per Availability Zone."

  validation {
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "database_subnet_cidrs must contain exactly two CIDRs."
  }
}

variable "nat_gateway_mode" {
  type        = string
  description = "single is cost-conscious; per_az provides resilient private egress."
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or per_az."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to all network resources."
  default     = {}
}
