provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {

  ami           = "ami-06f621d90fa29f6d0"
  instance_type = "t2.small"
  key_name      = "Devops_project_kp"
  tags = {
    Name = "Testing"
  }
}
