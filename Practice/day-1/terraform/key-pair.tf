## Key pair - use ssh to connect to the Server
resource "aws_key_pair" "aws-key" {
  key_name   = "aws_key"
  public_key = "/home/gabby1000/.ssh/id_ed25519.pub"
}
