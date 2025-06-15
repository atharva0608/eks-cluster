#!/bin/bash

# Update system
apt-get update -y
apt-get upgrade -y

# Install essential tools
apt-get install -y \
    curl \
    wget \
    unzip \
    jq \
    htop \
    vim \
    git \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws/

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm -y

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install session manager plugin
wget https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb
dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb

# Create .bashrc additions for ubuntu user
cat >> /home/ubuntu/.bashrc << 'EOF'

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deployment'

# Kubectl completion
source <(kubectl completion bash)
complete -F __start_kubectl k

# AWS CLI completion
complete -C '/usr/local/bin/aws_completer' aws

# Set AWS region
export AWS_DEFAULT_REGION=${region}
EOF

# Set proper ownership
chown ubuntu:ubuntu /home/ubuntu/.bashrc

# Enable and start services
systemctl enable docker
systemctl start docker

# Create kubectl config directory
mkdir -p /home/ubuntu/.kube
chown ubuntu:ubuntu /home/ubuntu/.kube

# Log installation completion
echo "Bastion host setup completed at $(date)" > /var/log/bastion-setup.log