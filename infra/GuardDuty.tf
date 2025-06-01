resource "aws_guardduty_detector" "main" {
  count  = var.tag_environment == "production" ? 1 : 0
  enable = true
}

# Criar um filtro para anomalias de IAM no GuardDuty
resource "aws_guardduty_filter" "iam_anomalies" {
  count = var.tag_environment == "production" && local.detector_id != null ? 1 : 0

  detector_id = local.detector_id
  name        = "IAM_Anomalies_Filter"
  description = "Detect anomalies in IAM activity"
  action      = "NOOP"

  finding_criteria {
    criterion {
      field  = "service.serviceName"
      equals = ["iam.amazonaws.com"]
    }
  }

  rank = 1
}