resource "aws_appautoscaling_target" "ecs_service" {
  count = local.enable_production_autoscaling

  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ecs_name.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = local.enable_production_autoscaling

  alarm_name          = "${var.ecr_service_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "Alarme quando CPU ultrapassa 75%."
  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.ecs_name.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = local.enable_production_autoscaling

  alarm_name          = "${var.ecr_service_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 25
  alarm_description   = "Alarme quando CPU ficar abaixo de 25%."
  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.ecs_name.name
  }
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  count = local.enable_production_autoscaling

  name              = "scale-up-policy"
  service_namespace = "ecs"

  resource_id        = "service/${var.ecs_cluster_name}/${var.ecr_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_up_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 10
    }

    step_adjustment {
      scaling_adjustment          = 2
      metric_interval_lower_bound = 10

    }
  }
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  count = local.enable_production_autoscaling

  name              = "scale-down-policy"
  service_namespace = "ecs"

  resource_id        = "service/${var.ecs_cluster_name}/${var.ecr_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_down_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
      metric_interval_lower_bound = -10
    }

    step_adjustment {
      scaling_adjustment          = -2
      metric_interval_upper_bound = -10

    }
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  count = local.enable_production_autoscaling

  alarm_name          = "${var.ecr_service_name}-scale-up-alarm"
  alarm_description   = "Dispara escalonamento para cima."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75
  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.ecs_name.name
  }


  alarm_actions = [aws_appautoscaling_policy.scale_up_policy[0].arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  count = local.enable_production_autoscaling

  alarm_name          = "${var.ecr_service_name}-scale-down-alarm"
  alarm_description   = "Dispara escalonamento para baixo."
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 25
  dimensions = {
    ClusterName = aws_ecs_cluster.cluster.name
    ServiceName = aws_ecs_service.ecs_name.name
  }


  alarm_actions = [aws_appautoscaling_policy.scale_down_policy[0].arn]
}