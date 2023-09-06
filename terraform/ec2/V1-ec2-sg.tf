provider "aws"{
    region = "ap-south-1"
}

resource "aws_instance" "demo-server"{

    
    ami =  "ami-06f621d90fa29f6d0"
    instance_type = "t2.micro"
    key_name = "Devops_project_kp"
    security_groups = ["demo-sg"]
    tags = {
        dev = "testing"
    }
    }
resource "aws_security_group" "demo-sg" {
     name = "demo-sg"
     description = "ssh accesses"
     

     ingress {
        description = "TLS from vpc"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
     }
     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

     }
     tags = {
       Name = "allow_tls"
     }

  
}