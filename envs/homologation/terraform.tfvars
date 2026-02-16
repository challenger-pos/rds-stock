# ===============================================
# IDENTIFICAÇÃO
# ===============================================

project     = "challengeone"
service     = "stock"
environment = "homolog"

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

backup_retention_period = 7
backup_window          = "03:00-04:00"
maintenance_window     = "sun:04:00-sun:05:00"

# ===============================================
# ALTA DISPONIBILIDADE
# ===============================================

multi_az              = false  # true em produção
deletion_protection   = false  # true em produção
skip_final_snapshot   = true   # false em produção

# ===============================================
# MONITORAMENTO
# ===============================================

monitoring_interval = 60

# ===============================================
# TAGS
# ===============================================

tags = {
  Project     = "ChallengeOne"
  Service     = "Stock"
  Environment = "Homolog"
  ManagedBy   = "Terraform"
  Team        = "Platform"
}
