provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {

  count           = length(var.instance_type)
  ami             = "ami-0f5ee92e2d63afc18"
  instance_type   = var.instance_type[count.index]
  key_name        = "Devops_project_kp"
  security_groups = [aws_security_group.demo-sg.id]
  subnet_id       = aws_subnet.demo-public-subnet-01.id
  #for_each = toset(["jenkins-master","jenkins-slave","ansible"])
  tags = {
    Name = var.tag_name[count.index]
  }
  lifecycle {
    ignore_changes = [security_groups, instance_type]
  }
}
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "ssh accesses"
  vpc_id      = aws_vpc.demo_vpc.id


  ingress {
    description = "TLS from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from vpc"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow_tls"
  }


}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}
resource "aws_subnet" "demo-public-subnet-01" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "demo-ps-1"
  }
}

resource "aws_subnet" "demo-public-subnet-02" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "demo-ps-2"

  }
}

resource "aws_internet_gateway" "demo-ig" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "demo-igw"
  }
}
resource "aws_route_table" "demo_public-rt" {
  vpc_id = aws_vpc.demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-ig.id
  }
}
resource "aws_route_table_association" "demo-rta-public-subnet-01" {
  subnet_id      = aws_subnet.demo-public-subnet-01.id
  route_table_id = aws_route_table.demo_public-rt.id
}
resource "aws_route_table_association" "demo-rta-public-subnet-02" {
  subnet_id      = aws_subnet.demo-public-subnet-02.id
  route_table_id = aws_route_table.demo_public-rt.id
}
/*
module "sgs" {
   source = "../sg_eks"
   vpc_id     =     aws_vpc.demo_vpc.id
  }

  module "eks" {
      source = "../eks"
      vpc_id     =     aws_vpc.demo_vpc.id
      subnet_ids = [aws_subnet.demo-public-subnet-01.id,aws_subnet.demo-public-subnet-02.id]
      sg_ids = module.sgs.security_group_public
  }
*/

