variable "aws_region" {
  type        = string
  description = "Region in which the Terraform state bucket is created."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Optional globally unique bucket name. A deterministic account-based name is used when null."
  default     = null
  nullable    = true
}

variable "force_destroy" {
  type        = bool
  description = "Permit deletion of a non-empty state bucket. Keep false except during an intentional final cleanup."
  default     = false
}
