#!/bin/bash

# Exit immediately if any command fails
set -e

# Safety Check: Ensure the script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo "❌ Error: Please run this script with sudo or as root."
  exit 1
fi

# Detect the exact non-root human user running the script via sudo
HUMAN_USER=${SUDO_USER:-$USER}
HUMAN_HOME=$(eval echo ~$HUMAN_USER)

echo "🚀 Starting DevOps Environment Setup for user: $HUMAN_USER"

# ---------------------------------------------------------
# Step 1: System Packages Installation (Arch Linux)
# ---------------------------------------------------------
echo "📦 Updating system repositories and installing tools..."
pacman -Syu --noconfirm --overwrite "*" \
    aws-cli \
    terraform \
    ansible \
    ansible-core \
    docker \
    docker-buildx \
    docker-compose

# ---------------------------------------------------------
# Step 2: Configure and Start Docker Service
# ---------------------------------------------------------
echo "🐳 Setting up background Docker daemon permissions..."
systemctl start docker
systemctl enable docker

# Add your friend's human user to the docker group so they don't need 'sudo' for docker commands
usermod -aG docker "$HUMAN_USER"

# ---------------------------------------------------------
# Step 3: Generate the Secure Cryptographic SSH Key Pair
# ---------------------------------------------------------
SSH_DIR="$HUMAN_HOME/.ssh"
KEY_PATH="$SSH_DIR/vprofile-key"

echo "🔑 Generating modern ED25519 SSH automation key pair..."
mkdir -p "$SSH_DIR"

if [ ! -f "$KEY_PATH" ]; then
    # Generate the key without a password prompt so Ansible can use it autonomously
    ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -q
    echo "✅ New SSH keys created at $KEY_PATH"
else
    echo "ℹ️ SSH keys already exist at $KEY_PATH, skipping creation."
fi

# Fix ownership and permissions on the SSH directory for the human user
chown -R "$HUMAN_USER:$HUMAN_USER" "$SSH_DIR"
chmod 700 "$SSH_DIR"
chmod 600 "$KEY_PATH"
chmod 644 "${KEY_PATH}.pub"

# ---------------------------------------------------------
# Step 4: Scaffold the Project Folder Infrastructure
# ---------------------------------------------------------
PROJECT_DIR="$HUMAN_HOME/projects/aws-multiregion-ansible"
echo "📂 Scaffolding workspace directory at $PROJECT_DIR..."
mkdir -p "$PROJECT_DIR"
chown -R "$HUMAN_USER:$HUMAN_USER" "$HUMAN_HOME/projects"

# ---------------------------------------------------------
# Final Summary Output
# ---------------------------------------------------------
echo "------------------------------------------------------------"
echo "🎉 DEVOPS ENVIRONMENT SETUP COMPLETED SUCCESSFULLY!"
echo "------------------------------------------------------------"
echo "🛠️ Installed Components:"
echo "   • $(aws --version | head -n 1)"
echo "   • $(terraform --version | head -n 1)"
echo "   • $(ansible --version | head -n 1)"
echo "   • $(docker --version)"
echo "------------------------------------------------------------"
echo "⚠️ INOTE:"
echo "  1. Log out of your Arch session and log back in to apply Docker group permissions."
echo "  2. Run 'aws configure --profile default' to link your AWS keys."
echo "  3. Change directory: 'cd ~/projects/aws-multiregion-ansible' to start coding!"
echo "------------------------------------------------------------"
