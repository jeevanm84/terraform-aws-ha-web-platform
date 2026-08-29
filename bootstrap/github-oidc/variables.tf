variable "aws_region" {
  type        = string
  description = "AWS Region used for provider operations. IAM resources remain global."
  default     = "us-east-1"
}

variable "github_owner" {
  type        = string
  description = "GitHub account name."
  default     = "jeevanm84"
}

variable "github_owner_id" {
  type        = string
  description = "Immutable numeric GitHub account ID."
  default     = "97403155"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository name."
  default     = "terraform-aws-ha-web-platform"
}

variable "github_repository_id" {
  type        = string
  description = "Immutable numeric GitHub repository ID, shown after the repository is created."
  default     = "1350361024"
}

variable "state_bucket_name" {
  type        = string
  description = "S3 bucket created by bootstrap/state."
}

variable "state_key_prefix" {
  type        = string
  description = "Key prefix GitHub Actions may access in the state bucket."
  default     = "terraform-aws-ha-web-platform/"
}

variable "create_oidc_provider" {
  type        = bool
  description = "Create the account-wide GitHub OIDC provider. Set false if it already exists."
  default     = true
}
