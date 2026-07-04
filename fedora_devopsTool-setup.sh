## Update the system
sudo dnf upgrade --refresh
sudo reboot

## Install Essential Package
sudo dnf install -y \
git \
curl \
wget \
vim \
nano \
make \
gcc \
gcc-c++ \
openssl \
zip \
unzip \
jq \
tar \
python3 \
python3-pip

## Install docker
## Fedora prefers podman but you could also install docker
sudo dnf remove podman-docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

sudo usermod -aG docker $USER
newgrp docker

docker run hello-world

## or install podman
sudo dnf install podman podman-compose buildah skopeo;
sleep 2;
podman run hello-world

## Install Orchestration tool (kubernetes)
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

##  Install MiniKube (kubernetes)
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --driver=docker	

minikube start --driver=podman
## Install helm (kubernetes)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

##  Install terraform
sudo dnf install -y dnf-plugins-core

sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

sudo dnf install terraform

terraform version

## Install Ansible
sudo dnf install ansible

ansible version

## Install aws cli
sudo dnf install awscli2
aws configure

## Install github cli
sudo dnf install gh

gh auth login


##
sudo dnf install openssh-clients

## Optional Package (VSCODE)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'cat > /etc/yum.repos.d/vscode.repo <<EOF
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF'

sudo dnf install code
