# ===============================================
# SECURITY GROUP DO RDS
# ===============================================

resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.service}-rds-sg-${var.environment}"
  description = "Security group for ${var.service} RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.service}-rds-sg-${var.environment}"
    }
  )
}

# Regra de entrada: PostgreSQL (apenas do EKS)
resource "aws_vpc_security_group_ingress_rule" "postgres_from_eks" {
  for_each = toset(var.allowed_security_group_ids)

  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = each.value
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "PostgreSQL access from EKS cluster"
}

# Regra de saída: ALL (para updates, patches, etc.)
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}
