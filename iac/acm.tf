# Recurso para o certificado ACM
resource "aws_acm_certificate" "domain_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"  # Adiciona o domínio wildcard
  ]

  tags = {
    "Name"        = var.domain_name
    "environment" = var.tag_prod
    "ambiente"    = var.tag_ambiente
  }

  lifecycle {
    create_before_destroy = true
  }
}



# Recurso para os registros DNS de validação
resource "aws_route53_record" "domain_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain_zone.zone_id
}

# Recurso para validar o certificado ACM
resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation_records : record.fqdn]
}
