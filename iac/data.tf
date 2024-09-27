data "aws_caller_identity" "current" {} ## utiliza o id da conta atual
data "aws_region" "current" {}          # 
# Os data de cima foi utilizado exclusivamente para o CloudTrail

# Recurso para o zone_id do Route 53
data "aws_route53_zone" "domain_zone" {
  name         = var.domain_name
  private_zone = false
}