# 1. Tell Terraform to use the AWS Cloud provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. Set your target AWS Region (Change to your preferred region if different)
provider "aws" {
  region = "us-east-1"
}

# 3. Create a Security Group to open web traffic ports
resource "aws_security_group" "calculator_sg" {
  name        = "calculator-web-sg"
  description = "Allow HTTP and SSH traffic"

  # Open Port 80 for the public to access your calculator website
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open Port 22 so you can still SSH into the instance if needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules: Allow the server to talk to the internet (needed to download Docker)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Spin up the Ubuntu EC2 Instance
resource "aws_instance" "calculator_server" {
  ami                    = "ami-04b70fa74e45c3917" # Official Ubuntu 24.04 LTS AMI in us-east-1
  instance_type          = "t3.micro"             # Free-tier eligible size
  vpc_security_group_ids = [aws_security_group.calculator_sg.id]

  # The Bootstrap Script: This executes automatically immediately upon instance bootup
  user_data = <<-EOF
              #!/bin/bash
              # Update system packages
              apt-get update -y
              
              # Install Docker backend cleanly
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              
              # Pull your freshly uploaded calculator image from Docker Hub
              docker pull gabby1000/calculator-web:v1
              
              # Spin up the container on Port 80
              docker run -d -p 80:80 --name my-calculator gabby1000/calculator-web:v1
              EOF

  tags = {
    Name = "Docker-Calculator-Server"
  }
} 

# 5. Output the Public IP address to your terminal when finished
output "public_ip" {
  value       = aws_instance.calculator_server.public_ip
  description = "The public IP address of your AWS server"
}
