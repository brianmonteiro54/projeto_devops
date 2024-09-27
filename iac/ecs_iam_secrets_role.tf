resource "aws_iam_role" "ecsSecretManagerAndParameterStore" {
  name = "ecsSecretManagerAndParameterStore"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}


resource "aws_iam_policy" "ecsSecretsAccessPolicy" {
  name        = "ecsSecretsAccessPolicy"
  description = "Policy to allow ECS task to access specific Secrets Manager secrets and SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = tolist(aws_db_instance.rds_api.master_user_secret)[0].secret_arn
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters"
        ]
        Resource = [
          aws_ssm_parameter.db_database.arn,
          aws_ssm_parameter.db_endpoint.arn,
          aws_ssm_parameter.db_port.arn
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecsSecretsAccessPolicyAttachment" {
  policy_arn = aws_iam_policy.ecsSecretsAccessPolicy.arn
  role       = aws_iam_role.ecsSecretManagerAndParameterStore.name
}
