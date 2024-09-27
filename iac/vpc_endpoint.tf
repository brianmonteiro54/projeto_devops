#Endpoint ecr.api
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"

  # Adicione seus grupos de segurança aqui
  security_group_ids = [
    aws_security_group.api-ecs.id
  ]

  # Adicione suas sub-redes aqui
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente,
    "Name"        = "ecr.api"
  }

}

#Endpoint ecr.dkr
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"


  # Adicione seus grupos de segurança aqui
  security_group_ids = [
    aws_security_group.api-ecs.id
  ]

  # Adicione suas sub-redes aqui
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente,
    "Name"        = "ecr.dkr"
  }

}

#Endpoint ecs
resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = aws_vpc.terraform_vpc.id
  service_name      = "com.amazonaws.us-east-1.ecs"
  vpc_endpoint_type = "Interface"

  # Adicione seus grupos de segurança aqui
  security_group_ids = [
    aws_security_group.api-ecs.id
  ]

  # Adicione suas sub-redes aqui
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente,
    "Name"        = "ecs"
  }

}