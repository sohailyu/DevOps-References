provider "aws" {
  region = "${var.region}"
}

data "aws_iam_instance_profile" "ec2_role" {
  name = "test_profile"
 } 

data "aws_vpc" "vpc1" {
  tags = {
      "Name" = "New-vpc"
  }
}

data "aws_subnet" "subnet1" {

    tags = {
      "Name" = "Public-c"
    }
  
}

data "aws_ami" "ami1" {
  tags = {
      "Name" = "Jenkins"
  }
  owners = [ var.owners ]
}

data "aws_iam_instance_profile" "ec2-profile" {
  name = "test_profile"
}

# data "aws_security_group" "jenkins-security" {
#     tags = {
#       "ENVIRONMENT" = "dev"
#     }
  
# }
resource "aws_security_group" "allow_jenk-port" {
  name        = "allow_jenk-port"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.vpc1.id

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]#[data.aws_vpc.vpc1.cidr_block]
  }

    ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]#[data.aws_vpc.vpc1.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_jenkins"
  }
}
resource "aws_key_pair" "jenkins-key" {
  key_name = "${var.dev_key_name}" # jenkins_key var.dev_key_name
  public_key = "${var.jenkins_key}" #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjJeO55Ftok6VjL0+zGoxDhIlS5w7i9UN139wx+YO9pOb6kOPT8ho8tlYOrzxoD79Fi3APCP/LjzJNYEvWmS/f6Ui1TYZRF3k1PFuWX/5IOUqqKHyGLPZTbal3XTLYIp9ue8d60tyKVtzNiY9o8LB/XemJmny4S/mLSpHwXmq/O1osgSYplAZfLHOI2W9DA9xlA59VbcCvXcuKysw9oy6kzGyDFO+j9qBAGzgkf+KY1nWEv1HmrFzsO2N0JfWpVrxSb2auDURfi3Ygl1d36mLBO/skxRJA6gj1QmXuXRllUou6sfe/LiViPrUy4L1fLVgV5f/EncZ0ECpXzDEU5drn tempuser@Temps-MBP.attlocal.net"#var.jenkins_key
}
resource "aws_instance" "jenkins" {
    ami = data.aws_ami.ami1.id
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [aws_security_group.allow_jenk-port.id]#[ data.aws_security_group.jenkins-security.id ]
    iam_instance_profile = data.aws_iam_instance_profile.ec2-profile.name
    subnet_id = data.aws_subnet.subnet1.id
    associate_public_ip_address = "${var.assign_public_ip}"
    key_name = aws_key_pair.jenkins-key.id

  
}
output "aws_instance_ip" {
  value = aws_instance.jenkins.public_ip
}
output "aws_instance_id" {
  value = aws_instance.jenkins.id
}
