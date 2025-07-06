provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

# Módulo único para todos los microservicios de autenticación
module "auth_microservices" {
  source              = "./modules/microservice"
  name                = "auth-microservices"
  image_encrypt       = "ievinan/microservice-encrypt"
  port_encrypt        = 8080
  image_jwt           = "ievinan/microservice-jwt"
  port_jwt            = 8081
  image_jwt_validate  = "ievinan/microservice-jwt-validate"
  port_jwt_validate   = 8082
  tag_encrypt         = "dev"
  tag_jwt             = "dev"
  tag_jwt_validate    = "dev"
  branch              = "dev"
  jwt_secret          = var.jwt_secret
  vpc_id              = var.vpc_id
  subnet1             = var.subnet1
  subnet2             = var.subnet2
}

# --- SNS Topic y Subscription para notificaciones ---
resource "aws_sns_topic" "asg_alerts" {
  name = "asg-alerts-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.asg_alerts.arn
  protocol  = "email"
  endpoint  = "ievinan@uce.edu.ec"
}

# --- CloudWatch Alarm para el Auto Scaling Group ---
resource "aws_cloudwatch_metric_alarm" "asg_high_cpu" {
  alarm_name          = "asg-high-cpu-utilization"
  alarm_description   = "High CPU utilization alarm for ASG"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 120
  dimensions = {
    AutoScalingGroupName = module.auth_microservices.asg_name
  }
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  alarm_actions       = [aws_sns_topic.asg_alerts.arn]
}

# --- CloudWatch Dashboard para monitoreo ---
resource "aws_cloudwatch_dashboard" "asg_dashboard" {
  dashboard_name = "asg-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        "type" = "metric",
        "x" = 0,
        "y" = 0,
        "width" = 24,
        "height" = 6,
        "properties" = {
          "metrics" = [
            [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", module.auth_microservices.asg_name ]
          ],
          "period" = 300,
          "stat" = "Average",
          "region" = var.AWS_REGION,
          "title" = "ASG CPU Utilization"
        }
      }
    ]
  })
}