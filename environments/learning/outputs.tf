output "application_url" {
  description = "URL of the deployed sample application."
  value       = module.load_balancer.application_url
}

output "vpc_id" {
  description = "ID of the platform VPC."
  value       = module.networking.vpc_id
}

output "availability_zones" {
  description = "Availability Zones used by the platform."
  value       = slice(data.aws_availability_zones.available.names, 0, 2)
}

output "nat_gateway_count" {
  description = "Number of NAT gateways created by the selected profile."
  value       = module.networking.nat_gateway_count
}

output "autoscaling_group_name" {
  description = "Name of the web Auto Scaling group."
  value       = module.compute.autoscaling_group_name
}

output "database_endpoint" {
  description = "Database endpoint, or null when RDS is disabled."
  value       = try(module.database[0].endpoint, null)
}

output "database_multi_az" {
  description = "Whether the optional database is Multi-AZ, or null when disabled."
  value       = try(module.database[0].multi_az, null)
}

output "database_master_secret_arn" {
  description = "Managed credential secret ARN, or null when RDS is disabled."
  value       = try(module.database[0].master_secret_arn, null)
  sensitive   = true
}

output "cloudwatch_dashboard_name" {
  description = "Dashboard name, or null when observability is disabled."
  value       = try(module.observability[0].dashboard_name, null)
}
