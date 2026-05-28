## Structure for the the directories with the initials of 'aws-docker' a directory names

[ App ] -> [ Dockerfile Image ] --> [ Push to Docker Hub ] --> [ Run Container on EC2 ] --> [ Deploy EC2 with Terraform ]

## Project Structure

```bash
.
├── app/
│   └── html
│   └── css
│   └── js
├── Dockerfile
├── main.tf
├── .dockerignore
└── README.md

# Dockerized AWS Deployment Project

# This project demonstrates how to:

  1. The Dockerfile: We will write a tiny, multi-stage Dockerfile for your calculator app so it builds into a super lightweight image ready for public download.
  
  2. The Docker Hub Push: We will authenticate our Docker Hub account from the terminal and push your clean image up to the cloud.
 
  3. The Terraform Configuration: Instead of clicking buttons in the AWS Console, we will write a main.tf file that spins up your EC2 instance, configures the Security Groups, and—best of all—uses a Terraform user_data script to automatically install Docker on boot so you do not even have to manually install it yourself!


