
# Create an ECS Cluster
resource "aws_ecs_cluster" "terraform_ecs_cluster" {
  name = "terraform-ecs-cluster"
}

# Create IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "terraform-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AmazonECSTaskExecutionRolePolicy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create an ECS Task Definition
resource "aws_ecs_task_definition" "terraform_task" {
  family                   = "terraform-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "terraform-container"
      image     = "nginx:latest"  # Replace with your Docker image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
    }
  ])
}

# Create an ECS Service
resource "aws_ecs_service" "terraform_service" {
  name            = "terraform-ecs-service"
  cluster         = aws_ecs_cluster.terraform_ecs_cluster.id
  task_definition = aws_ecs_task_definition.terraform_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-0381a7120f4bc0be1"]  # Replace with your subnet IDs
    security_groups  = ["sg-08135e390a56168dc"]  # Replace with your security group
    assign_public_ip = true
  }
}
	
