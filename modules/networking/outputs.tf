output "vpc_id" {
  description = "ID of the platform VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs in availability_zones order."
  value       = [for zone in var.availability_zones : aws_subnet.public[zone].id]
}

output "private_subnet_ids" {
  description = "Private compute subnet IDs in availability_zones order."
  value       = [for zone in var.availability_zones : aws_subnet.private[zone].id]
}

output "database_subnet_ids" {
  description = "Isolated database subnet IDs in availability_zones order."
  value       = [for zone in var.availability_zones : aws_subnet.database[zone].id]
}

output "nat_gateway_count" {
  description = "Number of NAT gateways created by the selected mode."
  value       = length(aws_nat_gateway.this)
}
