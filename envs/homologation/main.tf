# ===============================================
# REMOTE STATES
# ===============================================

# Networking (VPC, Subnets)
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "tf-state-challenge-bucket"
    key    = "v4/networking/${var.environment}/terraform.tfstate"
    region = "us-east-2"
  }
}

# EKS Cluster (Security Groups)
data "terraform_remote_state" "kubernetes" {
  backend = "s3"
  config = {
    bucket = "tf-state-challenge-bucket"
    key    = "v4/kubernetes/${var.environment}/terraform.tfstate"
    region = "us-east-2"
  }
}

# ===============================================
# RDS MODULE
# ===============================================

module "rds_postgresql" {
  source = "../../modules/rds-postgresql"

  # Identificação
  project     = var.project
  service     = var.service
  environment = var.environment

  # Database
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Instância
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_engine_version    = var.db_engine_version

  # Rede (do remote state networking)
  vpc_id                = data.terraform_remote_state.networking.outputs.vpc_id
  private_db_subnet_ids = data.terraform_remote_state.networking.outputs.private_db_subnet_ids

  # Security (EKS cluster security group)
  allowed_security_group_ids = [
    data.terraform_remote_state.kubernetes.outputs.cluster_security_group_id
  ]

  # Backup e manutenção
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  # Alta disponibilidade
  multi_az            = var.multi_az
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  # Monitoramento
  monitoring_interval = var.monitoring_interval

  # Tags
  tags = var.tags
}
