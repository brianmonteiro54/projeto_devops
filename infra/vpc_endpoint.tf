#Endpoint ecr.api
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"

  # Adicione seus grupos de segurança aqui
  security_group_ids = [
    aws_security_group.ecs-sg.id
  ]

  # Adicione suas sub-redes aqui
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"      = "ecr.api"
  }

}

#Endpoint ecr.dkr
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"


  # Adicione seus grupos de segurança aqui
  security_group_ids = [
    aws_security_group.ecs-sg.id
  ]

  # Adicione suas sub-redes aqui
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"      = "ecr.dkr"
  }

}

#Endpoint ecs
resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ecs"
  vpc_endpoint_type = "Interface"

  # Adicione seus grupos de segurança aqui
  security_group_ids = [
    aws_security_group.ecs-sg.id
  ]

  # Adicione suas sub-redes aqui
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    "Name"      = "ecs"
  }

}

# Endpoint SSM
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.ecs-sg.id
  ]

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    Name        = "ssm"
  }
}

# Endpoint SSM Messages
resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.ecs-sg.id
  ]

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    Name        = "ssm-messages"
  }
}

# Endpoint Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.ecs-sg.id
  ]

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
    Name        = "secretsmanager"
  }
}