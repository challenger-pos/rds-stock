# RDS Stock Database

Módulo Terraform para provisionar um banco de dados PostgreSQL RDS para o Stock Service com alta disponibilidade e backup automático.

## 📋 Overview

Este repositório contém:
- **modules/rds-postgresql/**: Módulo reutilizável para RDS PostgreSQL
- **envs/dev/**: Configuração para ambiente de desenvolvimento
- **envs/homologation/**: Configuração para ambiente de homologação
- **envs/production/**: Configuração para ambiente de produção

## 🔧 Arquitetura

```
VPC + Subnets Privadas
    ↓
RDS PostgreSQL Instance
    ↓
    ├─ DB Subnet Group (Multi-AZ)
    ├─ Security Group (de EKS)
    ├─ Parameter Group (customizado)
    └─ Backup Automático
```

## 📊 Configuração por Ambiente

| Aspecto | Dev | Homolog | Prod |
|---------|-----|---------|------|
| Instance Class | `db.t3.micro` | `db.t3.micro` | `db.t3.small` |
| Storage | 20 GB | 20 GB | 100 GB |
| Backup Retention | 0 dias | 7 dias | 30 dias |
| Multi-AZ | ❌ | ❌ | ✅ |
| Deletion Protection | ❌ | ❌ | ✅ |
| Monitoring | Desabilitado | Ativo | Ativo |

## 🚀 Deployment

### Pré-requisitos

1. ✅ Terraform v1.0+
2. ✅ AWS CLI configurado
3. ✅ Conta AWS com permissões IAM

### Passo 1: Preparar Credenciais

```bash
# Copiar template
cp envs/dev/secrets.tfvars.template envs/dev/secrets.tfvars

# Editar com sua senha PostgreSQL
nano envs/dev/secrets.tfvars
# db_password = "sua-senha-forte"
```

### Passo 2: Inicializar

```bash
cd envs/dev
terraform init
```

### Passo 3: Planejar

```bash
terraform plan \
  -var-file="terraform.tfvars" \
  -var-file="secrets.tfvars"
```

### Passo 4: Aplicar

```bash
terraform apply \
  -var-file="terraform.tfvars" \
  -var-file="secrets.tfvars"
```

## 📋 Variáveis

### Obrigatórias (sem default)

```hcl
environment = "dev"      # Valores: dev, homologation, production
db_password = "..."      # Senha do banco PostgreSQL
```

### Com Defaults

| Variável | Default | Descrição |
|----------|---------|-----------|
| `project` | `challengeone` | Nome do projeto |
| `service` | `stock` | Nome do serviço |
| `db_name` | `challengeone` | Nome do banco (dev); `stock_db` (homolog) |
| `db_username` | `postgres` | Usuário do banco |
| `db_instance_class` | `db.t3.micro` | Classe da instância |
| `db_allocated_storage` | `20` | GB de storage |
| `db_engine_version` | `17` | Versão do PostgreSQL |
| `backup_retention_period` | `0` (dev); `7` (homolog) | Dias de backup |
| `backup_window` | `03:00-04:00` | Horário de backup |
| `maintenance_window` | `sun:04:00-sun:05:00` | Janela de manutenção |
| `multi_az` | `false` | MultiAZ (quer dizer, High Availability) |
| `deletion_protection` | `false` | Proteção contra deleção |
| `skip_final_snapshot` | `true` (dev); `false` (prod) | Snapshot ao deletar |
| `monitoring_interval` | `0` (dev); `60` (homolog) | Segundos entre monitoramento |

### Arquivos de Configuração

**terraform.tfvars**
```hcl
environment = "dev"
db_password = "postgres"
```

**secrets.tfvars** (NÃO commitar!)
```
# Opcional se db_username != postgres
db_username = "custom_user"
```

## 🔄 Alterando Ambiente

### Dev → Homolog

```bash
# Cria nova infraestrutura
cd envs/homologation
cp ~/dev/secrets.tfvars .  # Copie sua senha
terraform init
terraform apply \
  -var-file="terraform.tfvars" \
  -var-file="secrets.tfvars"
```

### Customizar Valores

```bash
# Sobrescrever defaults via CLI
terraform apply \
  -var-file="terraform.tfvars" \
  -var-file="secrets.tfvars" \
  -var="db_allocated_storage=50" \
  -var="backup_retention_period=30"
```

## 📤 Outputs

```bash
terraform output
```

| Output | Descrição |
|--------|-----------|
| `rds_endpoint` | Endpoint com porta (ex: host:5432) |
| `rds_endpoint_without_port` | Apenas hostname |
| `rds_port` | Porta (padrão: 5432) |
| `rds_arn` | ARN do RDS |
| `rds_id` | Identifier do RDS |
| `db_name` | Nome do banco |
| `db_username` | Username (sensível) |
| `security_group_id` | SG ID do RDS |
| `jdbc_url` | JDBC connection string |

## 🔐 Security

### Credenciais

- **Segredo**: `db_password` - Nunca commitar!
- **Usuário**: `db_username` - Padrão: `postgres`
- **Localização**: `secrets.tfvars` - Adicionar ao `.gitignore`

### Network

- **Localização**: Subnets privadas (sem acesso público)
- **Acesso**: Apenas via Security Group do EKS
- **Criptografia**: Habilitada (storage encrypted)
- **Backup**: Automatizado

### .gitignore

```
secrets.tfvars
*.tfvars
!terraform.tfvars
!terraform.tfvars.*.example
.terraform/
```

## 🔍 Validação

### Conectar ao Banco

```bash
# Get endpoint from terraform output
ENDPOINT=$(terraform output -raw rds_endpoint_without_port)
PORT=$(terraform output -raw rds_port)

# Conectar localmente (se tem bastion host)
psql -h $ENDPOINT -p $PORT -U postgres -d challengeone
```

### Via AWS CLI

```bash
aws rds describe-db-instances \
  --db-instance-identifier challengeone-stock-db-dev \
  --region us-east-2 \
  --query 'DBInstances[0].{Endpoint:Endpoint,Status:DBInstanceStatus}'
```

### CloudWatch Logs

```bash
# Ver logs do PostgreSQL
aws logs tail /aws/rds/db/challengeone-stock-db-dev --follow
```

## 🆘 Troubleshooting

### Pod não consegue conectar ao RDS

1. **Verificar Security Group**
   ```bash
   aws ec2 describe-security-groups \
     --query 'SecurityGroups[?GroupName==`challengeone-stock-rds-sg-dev`]'
   ```

2. **Verificar Endpoint**
   ```bash
   terraform output -raw rds_endpoint
   ```

3. **Testar conexão**
   ```bash
   kubectl run -it --rm debug --image=postgres:17 --restart=Never -- \
     psql -h <endpoint> -U postgres -d challengeone
   ```

### Backup falhando

```bash
# Verificar status
aws rds describe-db-instances \
  --db-instance-identifier challengeone-stock-db-dev \
  --region us-east-2 \
  --query 'DBInstances[0].BackupRetentionPeriod'
```

### RDS muito lento

```bash
# Verificar CPU/Memory
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBInstanceIdentifier,Value=challengeone-stock-db-dev \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average
```

## 💰 Custos

| Ambiente | Instance | Storage | Backup | Total/mês |
|----------|----------|---------|--------|-----------|
| Dev | $8.79 | ~$2 | $0 | ~$10 |
| Homolog | $8.79 | ~$2 | ~$1-2 | ~$10-12 |
| Prod | $17.58 | ~$10 | ~$5-10 | ~$35-40 |

## 📚 Referências

- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## ✅ Checklist de Deploy

- [ ] Arquivo `secrets.tfvars` criado e preenchido
- [ ] `terraform.tfvars` com ambiente correto
- [ ] `terraform plan` sem erros
- [ ] Backup retention apropriado per ambiente
- [ ] Security Group ID correto (do EKS)
- [ ] Endpoint RDS nos outputs
- [ ] Aplicação consegue conectar ao banco
- [ ] Logs sem erro de conexão

## 🔄 CI/CD Integration

### GitHub Actions

```yaml
deploy-rds:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v3
    - uses: hashicorp/setup-terraform@v2
    
    - name: Terraform Init
      working-directory: rds-stock/envs/dev
      run: terraform init
    
    - name: Terraform Apply
      working-directory: rds-stock/envs/dev
      env:
        TF_VAR_db_password: ${{ secrets.RDS_DB_PASSWORD }}
      run: terraform apply -auto-approve -var-file="terraform.tfvars"
```

---

**Mantido por:** Platform Engineering  
**Última atualização:** 2026-02-19