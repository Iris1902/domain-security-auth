provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

# Módulos para cada microservicio que desees desplegar
module "encrypt" {
  source       = "./modules/microservice"
  name         = "encrypt"
  image        = "ievinan/microservice-encrypt"
  port         = 8080
  branch       = "dev"
  jwt_secret   = var.jwt_secret
}

module "jwt" {
  source       = "./modules/microservice"
  name         = "jwt"
  image        = "ievinan/microservice-jwt"
  port         = 8081
  branch       = "dev"
  jwt_secret   = var.jwt_secret
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
  dimensions = {
    AutoScalingGroupName = module.encrypt.asg_name
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
            [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", module.encrypt.asg_name ]
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