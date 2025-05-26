locals {
  full_domain_name = var.tag_environment == "production" ? var.domain_name : "dev.${var.domain_name}"

  prod_detector_id = var.tag_environment == "production" && length(aws_guardduty_detector.main) > 0 ? aws_guardduty_detector.main[0].id : null
  dev_detector_id  = var.tag_environment != "production" && length(data.aws_guardduty_detector.existing) > 0 ? data.aws_guardduty_detector.existing[0].id : null

  detector_id = coalesce(local.prod_detector_id, local.dev_detector_id, null)

  web_acl_arn = length(aws_wafv2_web_acl.web_acl) > 0 ? aws_wafv2_web_acl.web_acl[0].arn : null

  enable_production_autoscaling = var.tag_environment == "production" ? 1 : 0
}
