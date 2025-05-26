resource "aws_wafv2_web_acl" "web_acl" {
  count       = var.tag_environment == "production" ? 1 : 0
  name        = var.waf_acl_name
  description = var.waf_description
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.waf_metric_name
    sampled_requests_enabled   = true
  }
  # Regra 1: Proteção para áreas administrativas

  rule {
    name     = "AWS-AWSManagedRulesAdminProtectionRuleSet"
    priority = 0
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAdminProtectionRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Regra 2: Proteção contra IPs maliciosos conhecidos
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  # Regra 3: Proteção contra IPs anônimos (proxies, VPNs, etc.)
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAnonymousIpList"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  # Regra 4: Conjunto de regras comuns para proteção geral
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 3
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Regra 5: Bloqueia entradas de dados conhecidamente maliciosos
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 4
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # Regra 6: Proteção contra injeção SQL
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 5
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesSQLiRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }
  # Regra 7: Proteção contra ataques baseados em Unix (sistemas e aplicativos Unix)
  rule {
    name     = "AWS-AWSManagedRulesUnixRuleSet"
    priority = 6
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesUnixRuleSet"
      }
    }
    override_action {
      none {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesUnixRuleSet"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

#Associar WAF ao ALB
resource "aws_wafv2_web_acl_association" "alb" {
  count        = length(aws_wafv2_web_acl.web_acl) > 0 ? 1 : 0
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = local.web_acl_arn
}