module "networking" {
  source = "../../modules/networking"

  name_prefix           = local.name_prefix
  vpc_cidr              = var.vpc_cidr
  availability_zones    = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  nat_gateway_mode      = var.nat_gateway_mode
  tags                  = local.common_tags
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  name_prefix        = local.name_prefix
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  allowed_ipv4_cidrs = var.allowed_ipv4_cidrs
  certificate_arn    = var.certificate_arn
  tags               = local.common_tags
}

module "compute" {
  source = "../../modules/compute"

  name_prefix                     = local.name_prefix
  vpc_id                          = module.networking.vpc_id
  private_subnet_ids              = module.networking.private_subnet_ids
  load_balancer_security_group_id = module.load_balancer.security_group_id
  target_group_arn                = module.load_balancer.target_group_arn
  ami_id                          = data.aws_ami.amazon_linux.id
  instance_type                   = var.instance_type
  min_size                        = var.min_size
  desired_capacity                = var.desired_capacity
  max_size                        = var.max_size
  tags                            = local.common_tags
}

module "database" {
  count  = var.enable_database ? 1 : 0
  source = "../../modules/database"

  name_prefix                   = local.name_prefix
  vpc_id                        = module.networking.vpc_id
  database_subnet_ids           = module.networking.database_subnet_ids
  application_security_group_id = module.compute.security_group_id
  instance_class                = var.database_instance_class
  multi_az                      = var.database_multi_az
  deletion_protection           = var.database_deletion_protection
  skip_final_snapshot           = var.skip_database_final_snapshot
  tags                          = local.common_tags
}

module "observability" {
  count  = var.enable_observability ? 1 : 0
  source = "../../modules/observability"

  name_prefix              = local.name_prefix
  load_balancer_arn_suffix = module.load_balancer.load_balancer_arn_suffix
  target_group_arn_suffix  = module.load_balancer.target_group_arn_suffix
  autoscaling_group_name   = module.compute.autoscaling_group_name
  alarm_email              = var.alarm_email
  tags                     = local.common_tags
}

check "at_least_two_available_zones" {
  assert {
    condition     = length(data.aws_availability_zones.available.names) >= 2
    error_message = "The selected Region must expose at least two available Availability Zones."
  }
}
