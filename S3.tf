
resource "aws_s3_bucket" "my_bucket"{
    bucket = "terraform-bucket-vc"
    acl = "private"
}