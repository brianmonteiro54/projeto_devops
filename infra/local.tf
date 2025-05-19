locals {
  # Se for prod, usa domínio raiz. Se dev, usa subdomínio dev.
  full_domain_name = var.tag_environment == "production" ? var.domain_name : "dev.${var.domain_name}"
}