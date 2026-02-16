# ===============================================
# INPUTS
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
  description = "Ambiente"
  type        = string
}

# Database
variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Username do banco"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Senha do banco"
  type        = string
  sensitive   = true
}

# Instância
variable "db_instance_class" {
  description = "Classe da instância"
  type        = string
}

variable "db_allocated_storage" {
  description = "Storage em GB"
  type        = number
}

variable "db_engine_version" {
  description = "Versão do PostgreSQL"
  type        = string
}

# Rede
variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "private_db_subnet_ids" {
  description = "IDs das subnets privadas para RDS"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security Groups permitidos a acessar o RDS"
  type        = list(string)
}

# Backup
variable "backup_retention_period" {
  description = "Período de retenção de backup"
  type        = number
}

variable "backup_window" {
  description = "Janela de backup"
  type        = string
}

variable "maintenance_window" {
  description = "Janela de manutenção"
  type        = string
}

# HA
variable "multi_az" {
  description = "Multi-AZ"
  type        = bool
}

variable "deletion_protection" {
  description = "Proteção contra deleção"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final"
  type        = bool
}

# Monitoramento
variable "monitoring_interval" {
  description = "Intervalo de monitoramento"
  type        = number
}

# Tags
variable "tags" {
  description = "Tags"
  type        = map(string)
}
