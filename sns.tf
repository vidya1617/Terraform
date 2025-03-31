# Create SNS Topic
resource "aws_sns_topic" "terraform_sns_topic" {
  name = "terraform-sns-topic"
}

# Create an SNS Subscription (example: Email)
resource "aws_sns_topic_subscription" "sns_email_subscription" {
  topic_arn = aws_sns_topic.terraform_sns_topic.arn
  protocol  = "email"
  endpoint  = "chaudharividya15@gmail.com" 
}