
# Create IAM Role for Step Function
resource "aws_iam_role" "step_function_role" {
  name = "step-function-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach basic execution policy for Step Function
resource "aws_iam_role_policy_attachment" "step_function_policy" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

# Create the Step Function
resource "aws_sfn_state_machine" "example" {
  name     = "SimpleStepFunction"
  role_arn = aws_iam_role.step_function_role.arn
definition = jsonencode({
    "StartAt": "CheckValue",
    "States": {
      "CheckValue": {
        "Type": "Choice",
        "Choices": [
          {
            "Variable": "$.value",
            "NumericGreaterThanEquals": 10,
            "Next": "SuccessState"
          }
        ],
        "Default": "FailureState"
      },
      "SuccessState": {
        "Type": "Succeed"
      },
      "FailureState": {
        "Type": "Fail"
      }
    }
  })
  
}
