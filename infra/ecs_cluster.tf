resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name

  tags = {
    Environment = var.tag_environment
    Ambiente    = var.tag_ambiente
  }
}
