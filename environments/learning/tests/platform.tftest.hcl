mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = {
      names    = ["us-east-1a", "us-east-1b", "us-east-1c"]
      zone_ids = ["use1-az1", "use1-az2", "use1-az3"]
    }
  }

  mock_data "aws_ami" {
    defaults = {
      id = "ami-0123456789abcdef0"
    }
  }

  mock_data "aws_region" {
    defaults = {
      region = "us-east-1"
    }
  }
}

run "cost_aware_learning_profile" {
  command = plan

  variables {
    nat_gateway_mode     = "single"
    enable_database      = false
    enable_observability = true
    min_size             = 2
    desired_capacity     = 2
    max_size             = 4
  }

  assert {
    condition     = output.nat_gateway_count == 1
    error_message = "The learning profile must create one NAT gateway."
  }

  assert {
    condition     = output.database_endpoint == null
    error_message = "RDS must remain disabled in the default learning profile."
  }
}

run "resilience_profile" {
  command = plan

  variables {
    nat_gateway_mode             = "per_az"
    enable_database              = true
    database_multi_az            = true
    database_deletion_protection = true
    skip_database_final_snapshot = false
    enable_observability         = true
    min_size                     = 2
    desired_capacity             = 2
    max_size                     = 6
  }

  assert {
    condition     = output.nat_gateway_count == 2
    error_message = "The resilience profile must create one NAT gateway per Availability Zone."
  }

  assert {
    condition     = output.database_multi_az
    error_message = "The resilience profile must enable Multi-AZ RDS."
  }
}
