resource "aws_ecr_repository" "terraform_ecr" {
  name                 = "terraform-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.terraform_ecr.repository_url
}