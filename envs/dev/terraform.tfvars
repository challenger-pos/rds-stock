# ===============================================
# IDENTIFICAÇÃO
# ===============================================

project     = "challengeone"
service     = "stock"
environment = "dev"

# ===============================================
# DATABASE
# ===============================================

db_name              = "stock_db"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_engine_version    = "17"

# ===============================================
# BACKUP E MANUTENÇÃO
# ===============================================

backup_retention_period = 0  # Desabilitado para free tier dev
backup_window          = "03:00-04:00"
maintenance_window     = "sun:04:00-sun:05:00"

# ===============================================
# ALTA DISPONIBILIDADE
# ===============================================

multi_az              = false  # Dev não precisa de Multi-AZ
deletion_protection   = false
skip_final_snapshot   = true

# ===============================================
# MONITORAMENTO
# ===============================================

monitoring_interval = 0  # Desabilitado em dev para reduzir custos

# ===============================================
# TAGS
# ===============================================

tags = {
  Project     = "ChallengeOne"
  Service     = "Stock"
  Environment = "Dev"
  ManagedBy   = "Terraform"
  Team        = "Platform"
}
