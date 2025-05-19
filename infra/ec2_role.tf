# Definir o documento de política para trusted entities
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Criar a role com a política de trusted entities
resource "aws_iam_role" "role_acesso_ssm2" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}

# Criar um instance profile e associar a role
resource "aws_iam_instance_profile" "instance_profile_acesso_ssm2" {
  name = var.instance_profile_name
  role = aws_iam_role.role_acesso_ssm2.name
}

# Anexar as políticas gerenciadas à role
resource "aws_iam_role_policy_attachment" "ssm_managed_policy" {
  role       = aws_iam_role.role_acesso_ssm2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}