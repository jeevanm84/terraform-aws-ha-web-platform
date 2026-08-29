resource "aws_db_subnet_group" "this" {
  name_prefix = "${var.name_prefix}-"
  subnet_ids  = var.database_subnet_ids
  description = "Isolated database subnets for ${var.name_prefix}"
  tags        = var.tags
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name_prefix}-db-"
  description = "Allows MySQL only from the application tier"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.application_security_group_id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  description                  = "MySQL from application tier"
}

resource "aws_db_instance" "this" {
  identifier_prefix               = "${var.name_prefix}-"
  engine                          = "mysql"
  engine_version                  = "8.0"
  instance_class                  = var.instance_class
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = max(var.allocated_storage, 100)
  storage_type                    = "gp3"
  storage_encrypted               = true
  db_name                         = "appdb"
  username                        = "platform_admin"
  manage_master_user_password     = true
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  publicly_accessible             = false
  multi_az                        = var.multi_az
  backup_retention_period         = 7
  maintenance_window              = "sun:05:00-sun:06:00"
  backup_window                   = "03:00-04:00"
  auto_minor_version_upgrade      = true
  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.name_prefix}-final"
  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]

  tags = var.tags
}
