## Key pair - use ssh to connect to the Server
resource "aws_key_pair" "aws-key" {
  key_name   = "aws_key"
  public_key = file("~/.ssh/id_ed25519.pub")
}
