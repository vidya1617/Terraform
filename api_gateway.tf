# Create API Gateway
resource "aws_api_gateway_rest_api" "terraform_api" {
  name        = "terraform-api"
  description = "Simple API Gateway created using Terraform"
}

# Create a Resource (Path: /hello)
resource "aws_api_gateway_resource" "hello_resource" {
  rest_api_id = aws_api_gateway_rest_api.terraform_api.id
  parent_id   = aws_api_gateway_rest_api.terraform_api.root_resource_id
  path_part   = "hello"
}

# Create a GET Method for /hello
resource "aws_api_gateway_method" "hello_get" {
  rest_api_id   = aws_api_gateway_rest_api.terraform_api.id
  resource_id   = aws_api_gateway_resource.hello_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Create a Mock Integration for GET /hello
resource "aws_api_gateway_integration" "hello_mock" {
  rest_api_id          = aws_api_gateway_rest_api.terraform_api.id
  resource_id          = aws_api_gateway_resource.hello_resource.id
  http_method          = aws_api_gateway_method.hello_get.http_method
  type                 = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

# Create a Response for the Mock Integration
resource "aws_api_gateway_method_response" "hello_response" {
  rest_api_id = aws_api_gateway_rest_api.terraform_api.id
  resource_id = aws_api_gateway_resource.hello_resource.id
  http_method = aws_api_gateway_method.hello_get.http_method
  status_code = "200"
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "terraform_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.terraform_api.id
  stage_name  = "dev"
   depends_on = [
    aws_api_gateway_method.hello_get,
    aws_api_gateway_integration.hello_mock,
    aws_api_gateway_method_response.hello_response
  ]
}

# Output API Gateway URL
output "api_gateway_url" {
  value = aws_api_gateway_deployment.terraform_api_deployment.invoke_url
}
