
## Here is a complete, step-by-step Blueprint containing the exact commands and file structure.
------------------------------

## 🚀 The AWS-Docker-Terraform DevOps Blueprint## 📁 Part 1: Project Structure
Your project folder should look exactly like this:

aws-docker-calculator/
├── calculator-app/        # Folder containing your web files
│   ├── index.html
│   ├── script.js
│   └── style.css
├── Dockerfile             # Builds the container image
└── main.tf                # Defines your AWS Cloud Infrastructure

------------------------------
## 🐳 Part 2: The Container Files## The Dockerfile

# Use the ultra-lightweight Nginx alpine image as the baseFROM nginx:alpine
# Copy all static assets from local folder into Nginx web rootCOPY ./calculator-app /usr/share/nginx/html
# Expose port 80 so the container can accept web trafficEXPOSE 80

------------------------------
## 🧱 Part 3: The Infrastructure File## main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create a Security Group to open web traffic ports
resource "aws_security_group" "calculator_sg" {
  name        = "calculator-web-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Spin up the Ubuntu EC2 Instance
resource "aws_instance" "calculator_server" {
  ami                    = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS AMI in us-east-1
  instance_type          = "t3.micro"             # Free-tier eligible size
  vpc_security_group_ids = [aws_security_group.calculator_sg.id]

  # Bootstrap Script: Executes automatically upon instance bootup
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker pull YourDockerHubAcct/calculator-web:v1
              docker run -d -p 80:80 --name my-calculator YourDockerHubAcct/calculator-web:v1
              EOF

  tags = {
    Name = "Docker-Calculator-Server"
  }
}

# Output the Public IP address to your terminal when finished
output "public_ip" {
  value       = aws_instance.calculator_server.public_ip
  description = "The public IP address of your AWS server"
}

------------------------------
## 🛠️ Part 4: Terminal Command Workflow (The Cheatsheet)## 1. Build and Push Your Image

# Log into your Docker Hub account
docker login -u YourDockerHubAcct
# Build the container image (Don't forget the dot at the end)
docker build -t YourDockerHubAcct/calculator-web:v1 .
# Push the container image up to Docker Hub
docker push YourDockerHubAcct/calculator-web:v1

## 2. Connect Your Terminal to AWS

# Step A: Fire up the interactive browser login (Run once every couple of weeks)
aws login
# Step B: CRUCIAL STEP - Export short-lived browser tokens to your current shell so Terraform can see them
export $(aws configure export-credentials --format env | xargs)

💡 Tip: If you close your terminal window or reboot your PC, you only need to rerun Step B to reactivate your credentials in the new window session!

## 3. Deploy Infrastructure with Terraform

# Initialize your workspace (Downloads the AWS provider plugins)
terraform init
# Review a preview blueprint check of what will be built
terraform plan
# Deploy live onto the AWS Cloud
terraform apply

## 4. Tear it Down (Avoid Unexpected Charges!)

# Erase all AWS instances and Security Groups automatically when you are finished
terraform destroy

------------------------------

