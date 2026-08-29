terraform {
  backend "s3" {
    key          = "terraform-aws-ha-web-platform/learning/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }
}
