# 1. Tell terraform To use the AWS provider
terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

# 2. Choose you AWS region
provider "aws" {
    region = "us-east-1"
}

# 3. Create Security Group
resource "aws_security_group" "cv_sg" {
    name        = "cv-sg"
    description = "Allow HTTP and SSH traffic"

    # 3.I Configure Inbound Rules for public access
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # 3.II Configure Inbound Rules for SSH access
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}

    # 3.III Configure Outbound Rules to allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
}
}

# 4. Create an EC2 instance
resource "aws_instance" "cv_server" {
    ami           = "ami-04b70fa74e45c3917" # Amazon Linux 2 AMI (HVM), SSD Volume Type
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.cv_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Update the system packages
              apt-get update -y

              # Install Docker backend
                apt-get install -y docker.io
                systemctl start docker
                systemctl enable docker

              # Pull and run the Docker image
              docker pull gabby1000/cv-web:v1
              docker run -d -p 80:80 --name my-cv gabby1000/cv-web:v1
            EOF

    tags = {
        Name = "Docker-Cv-Server"
        description = "EC2 instance for running the CV web application"
    }
}

# 5. Output the public IP of the EC2 instance
output "cv_server_public_ip" {
    value = aws_instance.cv_server.public_ip
    description = "The public IP address of the CV server"
}