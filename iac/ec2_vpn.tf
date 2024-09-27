# Criar Elastic IP
resource "aws_eip" "vpn_production_eip" {
  domain = "vpc"

  tags = {
    Name        = var.instance_name
    Environment = "production"
  }
}

# Associar o Elastic IP à instância EC2
resource "aws_eip_association" "vpn_production_eip_association" {
  instance_id   = aws_instance.vpn_production.id
  allocation_id = aws_eip.vpn_production_eip.id

  # Garante que a associação só ocorra após a criação da instância EC2
  depends_on = [aws_instance.vpn_production]
}

# Criar instância EC2
resource "aws_instance" "vpn_production" {
  ami                  = "ami-096ea6a12ea24a797"
  instance_type        = "t4g.micro"
  iam_instance_profile = aws_iam_instance_profile.instance_profile_acesso_ssm2.name
  user_data            = file("ec2_userdata.sh")

  # Associa à Subnet Pública que você criou
  subnet_id = aws_subnet.public_subnet_1.id

  # Habilitar a atribuição de IP público automaticamente
  associate_public_ip_address = true

  # Associa o Security Group que foi criado para a instância
  vpc_security_group_ids = [aws_security_group.Pritunl_VPN.id]

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name        = var.instance_name
    Environment = "production"
  }
}

# Associar o Elastic IP ao domínio Route 53
resource "aws_route53_record" "vpn_record" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id  # Correção aqui para usar o data source
  name    = "vpn.${var.domain_name}"
  type    = "A"
  ttl     = 30

  records = [aws_eip.vpn_production_eip.public_ip]

  depends_on = [aws_eip_association.vpn_production_eip_association]
}
