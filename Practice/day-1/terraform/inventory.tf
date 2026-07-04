## inventory.tf - Auto create ansible host.ini file
resource "local_file" "inventory" {
  content = <<EOF
[aws]
${aws_instance.aws-instance.public_ip}

[aws:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
EOF

  filename = "/home/gabby1000/DevOps/Practice/day-1/ansible/host.ini"
}
