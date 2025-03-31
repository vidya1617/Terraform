resource "aws_db_instance" "my_rds" {
    db_name = "terraform_db"
    identifier = "terraformdb"
    allocated_storage = 20
    engine = "mysql"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "admin123"
    skip_final_snapshot = true
}