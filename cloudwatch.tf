resource "aws_cloudwatch_log_group" "terraform_log_group" {
  name              = "terraform-log-group"
  retention_in_days = 7

  tags = {
    Name = "Terraform Log Group"
  }
}
/*
# Create CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "terraform_cpu_alarm" {
  alarm_name          = "terraform-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  alarm_description = "This metric monitors EC2 CPU utilization"
  actions_enabled   = false

  dimensions = {
    InstanceId = "i-1234567890abcdef0" # Replace with your EC2 instance ID
  }

  tags = {
    Name = "Terraform CPU Alarm"
  }
}*/