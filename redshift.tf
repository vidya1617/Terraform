# Create a Security Group for Redshift
resource "aws_security_group" "redshift_sg" {
  name        = "redshift-security-group"
  description = "Security group for Redshift cluster"

  ingress {
    from_port   = 5439  # Redshift default port
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow public access (change for better security)
  }
}

# Create a Redshift Cluster
resource "aws_redshift_cluster" "terraform_redshift" {
  cluster_identifier = "terraform-redshift"
  database_name      = "mydatabase"
  master_username    = "adminuser"
  master_password    = "Terraform123!"  
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.redshift_sg.id]

  tags = {
    Name = "Terraform-Redshift"
  }
}

# Output Redshift Endpoint
output "redshift_endpoint" {
  value = aws_redshift_cluster.terraform_redshift.endpoint
}