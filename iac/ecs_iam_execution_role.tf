resource "aws_iam_role" "ecsTaskExecutionRole_TF" {
  name = "ecsTaskExecutionRole_TF"

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

resource "aws_iam_policy" "cloudwatchLogsPolicy" {
  name        = "cloudwatchLogsPolicy"
  description = "Policy to allow ECS tasks to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatchLogsPolicyAttachment" {
  policy_arn = aws_iam_policy.cloudwatchLogsPolicy.arn
  role       = aws_iam_role.ecsTaskExecutionRole_TF.name
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecsTaskExecutionRole_TF.name
}
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRolePolicyGetSecretValue" {
  policy_arn = aws_iam_policy.ecsSecretsAccessPolicy.arn
  role       = aws_iam_role.ecsTaskExecutionRole_TF.name
}