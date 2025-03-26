resource "aws_vpc" "my_vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my_terraform_vpc"
    }
}
#create subnet
resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name ="my_terraform_subnet"
  }
}
