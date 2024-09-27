resource "aws_guardduty_detector" "main" {
  enable = true
}

# Criar um filtro para anomalias de IAM no GuardDuty
resource "aws_guardduty_filter" "iam_anomalies" {
  detector_id = aws_guardduty_detector.main.id
  name        = "IAM_Anomalies_Filter"  
  description = "Detect anomalies in IAM activity"
  action      = "NOOP"  # Permitir que o achado apareça no painel

  finding_criteria {
    criterion {
      field = "service.serviceName"
      equals = ["iam.amazonaws.com"] 
    }
  }

  rank = 1
}
