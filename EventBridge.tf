# Create SNS Topic
resource "aws_sns_topic" "terraform_sns_topic1" {
  name = "terraform-eventbridge-topic"
}

# Create EventBridge Rule
resource "aws_cloudwatch_event_rule" "terraform_eventbridge_rule" {
  name        = "terraform-eventbridge-rule"
  description = "Trigger on every EC2 state change"
  
  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["running", "stopped"]
    }
  })
}

# Create EventBridge Target to SNS Topic
resource "aws_cloudwatch_event_target" "terraform_eventbridge_target" {
  rule      = aws_cloudwatch_event_rule.terraform_eventbridge_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.terraform_sns_topic.arn
}

# Allow EventBridge to publish to SNS
resource "aws_sns_topic_policy" "terraform_sns_policy" {
  arn = aws_sns_topic.terraform_sns_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "SNS:Publish",
      Resource = aws_sns_topic.terraform_sns_topic.arn
    }]
  })
}
