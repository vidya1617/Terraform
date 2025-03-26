resource "aws_instance" "my_ec2" {
    ami = "ami-0093ceb06eded359f"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.my_subnet.id
    tags = {
      Name = "my-ec2-terraform"
    }
}
