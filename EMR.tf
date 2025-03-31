
# Create an IAM Role for EMR
resource "aws_iam_role" "emr_role" {
  name = "EMR_DefaultRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "elasticmapreduce.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy to the role
resource "aws_iam_role_policy_attachment" "emr_role_policy" {
  role       = aws_iam_role.emr_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}
# Create an Instance Profile for EMR EC2 Instances
resource "aws_iam_instance_profile" "emr_instance_profile" {
  name = "EMR_EC2_InstanceProfile"
  role = aws_iam_role.emr_role.name
}
resource "aws_emr_cluster" "my_emr" {
  name          = "my-emr-cluster"
  release_label = "emr-6.4.0"
  applications  = ["Hadoop", "Spark"]
  log_uri       = "s3://my-emr-logs/"
  service_role  = aws_iam_role.emr_role.arn

  ec2_attributes {
    instance_profile = aws_iam_instance_profile.emr_instance_profile.arn
  }

  master_instance_group {
    instance_type = "m5.xlarge"
    instance_count = 1
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 2
    ebs_config {
      size = 32
      type = "gp2"
      volumes_per_instance = 1
    }
  }

  termination_protection = false
  step_concurrency_level = 1

  tags = {
    Name = "My Terraform EMR Cluster"
  }
}
