variable "name_prefix" {
  type        = string
  description = "Prefix applied to database resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC in which the database is created."
}

variable "database_subnet_ids" {
  type        = list(string)
  description = "Isolated subnets used by the DB subnet group."
}

variable "application_security_group_id" {
  type        = string
  description = "Only this application security group may reach MySQL."
}

variable "instance_class" {
  type        = string
  description = "RDS instance class."
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Initial database storage in GiB."
  default     = 20
}

variable "multi_az" {
  type        = bool
  description = "Whether to provision a synchronous standby in another Availability Zone."
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "Protect the database from accidental Terraform deletion."
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip a final snapshot during destroy. Suitable only for disposable labs."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to database resources."
  default     = {}
}
