# Create SQS Queue
resource "aws_sqs_queue" "terraform_sqs_queue" {
  name                      = "terraform-sqs-queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0

  # Enable server-side encryption (optional)
  sqs_managed_sse_enabled = true
}