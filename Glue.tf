
# Create an IAM Role for Glue
resource "aws_iam_role" "glue_role" {
  name = "terraform-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach Glue policies to the IAM role
resource "aws_iam_role_policy_attachment" "glue_policy" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Create a Glue Job
resource "aws_glue_job" "terraform_glue" {
  name     = "terraform-glue"   
  role_arn = aws_iam_role.glue_role.arn

command {
  name            = "glueetl"
  script_location = "s3://my-glue-scripts/script.py"
  python_version  = "3"
}

  default_arguments = {
    "--job-bookmark-option" = "job-bookmark-enable"
  }

  max_retries = 1
  timeout     = 10
}

output "glue_job_name" {
  value = aws_glue_job.terraform_glue.name
}
