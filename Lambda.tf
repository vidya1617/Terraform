# Upload Lambda code to S3
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "vidya-lambda-code-bucket"
  force_destroy = true
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policy to allow logging
resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.lambda_code.key
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      ENV = "production"
    }
  }
}
