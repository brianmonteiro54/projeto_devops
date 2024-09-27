# Criar VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = "172.80.0.0/16"
  tags = {
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente,
    "Name"        = var.vpc_name
  }
}

# Criar Internet Gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
    "Name"        = "igw-production"
  }
}

# Subnets Públicas
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.80.1.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name          = "public-subnet-1-terraform"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.80.2.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name          = "public-subnet-2-terraform"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

# Subnets Privadas
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.80.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name          = "private-subnet-1-terraform"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.80.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name          = "private-subnet-2-terraform"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

# Tabela de rotas para Subnets Públicas
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name          = "public-route-table"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

# Associações das Subnets Públicas à tabela de rotas pública
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Criar NAT Gateways
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
}


resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name          = "nat-gateway-1"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name          = "nat-gateway-2"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

# Tabelas de rotas para Subnets Privadas
resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }

  tags = {
    Name = "private-route-table-1"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }

  tags = {
    Name          = "private-route-table-2"
    "environment" = var.tag_prod,
    "ambiente"    = var.tag_ambiente
  }
}

# Associações das Subnets Privadas às suas tabelas de rotas
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}

