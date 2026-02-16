# ===============================================
# IDENTIFICAÇÃO
# ===============================================

variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "service" {
  description = "Nome do serviço"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, homolog, production)"
  type        = string
}

# ===============================================
# DATABASE
# ===============================================

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

# ===============================================
# INSTÂNCIA
# ===============================================

variable "db_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Storage alocado em GB"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "Versão do PostgreSQL"
  type        = string
  default     = "17"
}

# ===============================================
# BACKUP E MANUTENÇÃO
# ===============================================

variable "backup_retention_period" {
  description = "Período de retenção de backup em dias"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Janela de backup (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Janela de manutenção (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# ===============================================
# ALTA DISPONIBILIDADE
# ===============================================

variable "multi_az" {
  description = "Habilitar Multi-AZ"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Proteção contra deleção acidental"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final ao deletar"
  type        = bool
  default     = true
}

# ===============================================
# MONITORAMENTO
# ===============================================

variable "monitoring_interval" {
  description = "Intervalo de monitoramento em segundos (0, 1, 5, 10, 15, 30, 60)"
  type        = number
  default     = 60
}

# ===============================================
# TAGS
# ===============================================

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default     = {}
}
