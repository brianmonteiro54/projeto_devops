# # Recurso Auto Scaling Target
# resource "aws_appautoscaling_target" "ecs_service_target" {
#   max_capacity       = 10
#   min_capacity       = 2
#   resource_id        = "service/${aws_ecs_cluster.production.name}/api-production"
#   role_arn           = aws_iam_role.ecsTaskExecutionRole_TF.arn
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"

#   depends_on = [aws_ecs_service.api_production]
# }

# # Policy de Scale-out
# resource "aws_appautoscaling_policy" "scale_out_policy" {
#   name               = "scale-out"
#   service_namespace  = "ecs"
#   resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
#   scalable_dimension = "ecs:service:DesiredCount"
#   policy_type        = "StepScaling"

#   step_scaling_policy_configuration {
#     adjustment_type = "ChangeInCapacity"

#     step_adjustment {
#       scaling_adjustment         = 2
#       metric_interval_lower_bound = 35
#       metric_interval_upper_bound = 45
#     }

#     step_adjustment {
#       scaling_adjustment         = 4
#       metric_interval_lower_bound = 45
#       metric_interval_upper_bound = 55
#     }

#     step_adjustment {
#       scaling_adjustment         = 6
#       metric_interval_lower_bound = 55
#       metric_interval_upper_bound = 65
#     }

#     step_adjustment {
#       scaling_adjustment         = 8
#       metric_interval_lower_bound = 65
#       # O último ajuste não tem limite superior
#     }

#     cooldown = 60
#   }
# }

# # Alarme para CPU utilization - Scale-out
# resource "aws_cloudwatch_metric_alarm" "scale_out_alarm" {
#   alarm_name          = "scale-out-alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 1
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = 300  # 5 minutos
#   statistic           = "Maximum"
#   threshold           = 30
#   alarm_actions       = [aws_appautoscaling_policy.scale_out_policy.arn]
#   dimensions = {
#     ClusterName = aws_ecs_cluster.production.name
#     ServiceName = "api-production"
#   }
# }

# >>>>>>>>>> ATEÇÃO SCALE-IN não esta funcionando <<<<<<<<<<<<<<<<<<<<<<

# # Policy de Scale-in
# resource "aws_appautoscaling_policy" "scale_in_policy" {
#   name                   = "scale-in"
#   service_namespace      = "ecs"
#   resource_id            = aws_appautoscaling_target.ecs_service_target.resource_id
#   scalable_dimension     = "ecs:service:DesiredCount"
#   policy_type            = "StepScaling"

#   step_scaling_policy_configuration {
#     adjustment_type = "ChangeInCapacity"
#     cooldown        = 60

#     step_adjustment {
#       scaling_adjustment          = -4
#       metric_interval_lower_bound = 0
#       metric_interval_upper_bound = 10
#     }

#     step_adjustment {
#       scaling_adjustment          = -2
#       metric_interval_lower_bound = 10
#       metric_interval_upper_bound = 20
#     }

#     step_adjustment {
#       scaling_adjustment          = -1
#       metric_interval_lower_bound = 20
#       metric_interval_upper_bound = 30
#     }

#     step_adjustment {
#       scaling_adjustment          = -1
#       metric_interval_lower_bound = 30
#       # O último ajuste não tem limite superior
#     }
#   }
# }


# # Alarme para CPU utilization - Scale-in
# resource "aws_cloudwatch_metric_alarm" "scale_in_alarm" {
#   alarm_name          = "scale-in-alarm"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 1
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/ECS"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 40
#   alarm_actions       = [aws_appautoscaling_policy.scale_in_policy.arn]
#   dimensions = {
#     ClusterName = aws_ecs_cluster.production.name
#     ServiceName = "api-production"
#   }
# }

