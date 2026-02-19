# RDS Stock Database

Módulo Terraform para provisionar PostgreSQL RDS para o Stock Service em 3 ambientes: dev, homologation e production.

## 📁 Estrutura

```
rds-stock/
├── envs/
│   ├── dev/              # Desenvolvimento
│   ├── homologation/     # Homologação
│   └── production/       # Produção
└── modules/
    └── rds-postgresql/   # Módulo PostgreSQL reutilizável
```

## 📊 Ambientes

| Aspecto | Dev | Homolog | Production |
|---------|-----|---------|------------|
| DB Name | `stock_db` | `stock_db` | `stock_db` |
| Instance | `db.t3.micro` | `db.t3.micro` | `db.t3.micro` |
| Storage | 20 GB | 20 GB | 20 GB |
| Backup | 0 dias | 0 dias | 0 dias |
| Monitoramento | Desabilitado | Ativo | Desabilitado |

## 🚀 Deploy

### Pré-requisitos

- Terraform v1.0+
- AWS CLI configurado
- VPC e EKS já provisionados

### Passos

```bash
# 1. Entrar no diretório do ambiente
cd envs/dev

# 2. Copiar template de credenciais
cp secrets.tfvars.template secrets.tfvars
# Editar: db_password = "sua-senha"

# 3. Inicializar
terraform init

# 4. Aplicar
terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

## 📋 Variáveis

Apenas **2 variáveis obrigatórias** em `terraform.tfvars`:

```hcl
environment = "dev"           # ou: homologation, production
db_password = "minha-senha"   # Sua senha PostgreSQL
```

Todas as outras têm **defaults apropriados** por ambiente:
- `project`: `challengeone`
- `service`: `stock`
- `db_username`: `postgres`
- `db_instance_class`: `db.t3.micro`
- `db_allocated_storage`: `20` GB
- `db_engine_version`: `17`
- Backup e monitoramento: diferenciados por env

## 📤 Outputs

Principais outputs após deploy:

```bash
terraform output
```

| Output | Descrição |
|--------|-----------|
| `rds_endpoint` | Endpoint com porta |
| `rds_endpoint_without_port` | Apenas hostname |
| `rds_port` | Porta (5432) |
| `rds_id` | Identificador do RDS |
| `db_name` | Nome do banco |
| `security_group_id` | Security Group ID |
| `jdbc_url` | URL JDBC para aplicação |

## 🔄 Alternar Ambientes

```bash
# Dev para Homolog
cd envs/homologation
terraform init
terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"

# Dev para Production
cd envs/production
terraform init
terraform apply -var-file="terraform.tfvars" -var-file="secrets.tfvars"
```

## 🔧 Customizar (Opcional)

Sobrescrever defaults via CLI:

```bash
terraform apply \
  -var-file="terraform.tfvars" \
  -var-file="secrets.tfvars" \
  -var="db_allocated_storage=50" \
  -var="backup_retention_period=15"
```

--- 
**Última atualização**: 2026-02-19