## EC2.tf - Creates the Server in Aws
resource "aws_instance" "aws-instance" {
  ami           = var.provider_ami
  instance_type = var.provider_instance_type
  key_name      = aws_key_pair.aws-key.key_name

  vpc_security_group_ids = [
    aws_security_group.aws-sg.id
  ]

  tags = {
    Name        = var.provider_instance_name
    description = "EC2 Server"
  }
}
