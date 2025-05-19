# Criar Elastic IP
resource "aws_eip" "vpn_ec2_eip" {
  domain = "vpc"

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# Associar o Elastic IP à instância EC2
resource "aws_eip_association" "vpn_ec2_eip_association" {
  instance_id   = aws_instance.vpn_ec2.id
  allocation_id = aws_eip.vpn_ec2_eip.id

  # Garante que a associação só ocorra após a criação da instância EC2
  depends_on = [aws_instance.vpn_ec2]
}

# Criar instância EC2
resource "aws_instance" "vpn_ec2" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
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
    Environment = var.tag_environment
  }
}

# Associar o Elastic IP ao domínio Route 53
resource "aws_route53_record" "vpn_record" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = "vpn.${local.full_domain_name}"
  type    = "A"
  ttl     = 30

  records = [aws_eip.vpn_ec2_eip.public_ip]

  depends_on = [aws_eip_association.vpn_ec2_eip_association]
}
