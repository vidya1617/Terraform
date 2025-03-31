# Create a secret
resource "aws_secretsmanager_secret" "example_secret" {
  name                    = "my-example-secret"
  description             = "My secret for storing sensitive data"
  recovery_window_in_days = 0  # Delete immediately when destroyed
}

# Store a secret value
resource "aws_secretsmanager_secret_version" "example_secret_value" {
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    username = "myuser"
    password = "admin123"
  })
}

output "secret_arn" {
  value = aws_secretsmanager_secret.example_secret.arn
}