## Output the Public Ip for the Created Instance
output "public_ip" {
  value   = aws_instance.aws-instance.public_ip
  description = "Public Ip for EC2 Instance"
}
