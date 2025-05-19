#security group da EC2
resource "aws_security_group" "Pritunl_VPN" {
  name        = "Pritunl_VPN-tf"
  description = "Regra para a instancia do ec2 que utiliza Pritunl"
  vpc_id      = aws_vpc.terraform_vpc.id

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"        = "Pritunl_VPN"
  }
}

#Regra de entrada security group da EC2
resource "aws_vpc_security_group_ingress_rule" "ingress_80_ec2" {
  description                  = "Permitir HTTP Full"
  security_group_id            = aws_security_group.Pritunl_VPN.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

#Regra de entrada security group da EC2
resource "aws_vpc_security_group_ingress_rule" "ingress_443_ec2" {
  description                  = "Permitir HTTPs Full"
  security_group_id            = aws_security_group.Pritunl_VPN.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

#Regra de entrada security group da EC2
resource "aws_vpc_security_group_ingress_rule" "ingress_5050_ec2" {
  description                  = "Permitir HTTPs Full"
  security_group_id            = aws_security_group.Pritunl_VPN.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port                    = 5050
  ip_protocol                  = "udp"
  to_port                      = 5050
}

#Regra de aida ada security group da EC2
resource "aws_vpc_security_group_egress_rule" "egress_all_traffic_ec2" {
  security_group_id = aws_security_group.Pritunl_VPN.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


#--------------------------------------------------------------------

#security grupo da RDS
resource "aws_security_group" "rds_db" {
  name        = "rds_db-tf"
  description = "Regra para a instancia do RDS rds-db com tf"
  vpc_id      = aws_vpc.terraform_vpc.id

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"        = "rds_db"
  }
}

#regra de entrada do RDS
resource "aws_vpc_security_group_ingress_rule" "ingress_rds_5432_alb" {
  description                  = "Permitir alb"
  security_group_id            = aws_security_group.rds_db.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rds_5432_ecs" {
  description                  = "Permitir ecs"
  security_group_id            = aws_security_group.rds_db.id
  referenced_security_group_id = aws_security_group.ecs-sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

#regra de saida do RDS
resource "aws_vpc_security_group_egress_rule" "egress_all_traffic" {
  security_group_id = aws_security_group.rds_db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# ------------------------------------------------------------------------------------------------------------------

#security grupo da ALB
resource "aws_security_group" "alb" {
  name        = "alb_api-tf"
  description = "Regra para Load Balancer"
  vpc_id      = aws_vpc.terraform_vpc.id

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"        = "api_alb"
  }
}
#regra de entrada do ALB
resource "aws_vpc_security_group_ingress_rule" "ingress_alb_80" {
  description       = "Liberado para o mundo"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
#regra de entrada do ALB
resource "aws_vpc_security_group_ingress_rule" "ingress_alb_443" {
  description       = "Liberado para o mundo"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

#regra de saida do ALB
resource "aws_vpc_security_group_egress_rule" "egress_all_traffic_alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# ------------------------------------------------------------------------------------------------------------------

#security grupo do ECS
resource "aws_security_group" "ecs-sg" {
  name        = "ecs-sg-tf"
  description = "Regra para o fargate do ecs"
  vpc_id      = aws_vpc.terraform_vpc.id

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"        = "api_ecs"

  }
}
#regra de entrada do ECS
resource "aws_vpc_security_group_ingress_rule" "ingress_ecs" {
  description                  = "Liberado para o alb"
  security_group_id            = aws_security_group.ecs-sg.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ecs_endpoint" {
  description       = "Liberado ssl para os endpoint"
  security_group_id = aws_security_group.ecs-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}


#regra de saida do ECS
resource "aws_vpc_security_group_egress_rule" "egress_all_traffic_ecs" {
  security_group_id = aws_security_group.ecs-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# ------------------------------------------------------------------------------------------------------------------
