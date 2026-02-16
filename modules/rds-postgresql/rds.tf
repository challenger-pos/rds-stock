# ===============================================
# RDS INSTANCE
# ===============================================

resource "aws_db_instance" "this" {
  identifier = "${var.project}-${var.service}-db-${var.environment}"

  # Engine
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  storage_type         = "gp3"
  storage_encrypted    = true
  max_allocated_storage = var.db_allocated_storage * 2  # Autoscaling até 2x

  # Database
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  # Network
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Backup
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project}-${var.service}-final-snapshot-${var.environment}"

  # High Availability
  multi_az            = var.multi_az
  deletion_protection = var.deletion_protection

  # Monitoring
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null

  # Performance Insights
  performance_insights_enabled    = true
  performance_insights_retention_period = 7

  # Parameter Group
  parameter_group_name = aws_db_parameter_group.this.name

  # Tags
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.service}-db-${var.environment}"
    }
  )
}

# ===============================================
# SUBNET GROUP
# ===============================================

resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.service}-db-subnet-group-${var.environment}"
  subnet_ids = var.private_db_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.service}-db-subnet-group-${var.environment}"
    }
  )
}

# ===============================================
# PARAMETER GROUP
# ===============================================

resource "aws_db_parameter_group" "this" {
  name   = "${var.project}-${var.service}-pg-${var.environment}"
  family = "postgres17"

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"  # Log queries > 1s
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.service}-pg-${var.environment}"
    }
  )
}

# ===============================================
# IAM ROLE FOR ENHANCED MONITORING
# ===============================================

resource "aws_iam_role" "rds_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0
  name  = "${var.project}-${var.service}-rds-monitoring-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count      = var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
