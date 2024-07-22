#!/bin/bash

set -e

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add current user to the docker group
    sudo usermod -aG docker $USER && newgrp docker
}

# Function to install k3d
install_k3d() {
    echo "Installing k3d..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}

install_kind_cluster() {
    echo "Installing kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
}

install_minikube() {
    echo "Installing minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
}

# Function to install kubectl
install_kubectl() {
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
}

# Function to install Helm
install_helm() {
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

# Function to create k3d cluster
create_k3d_cluster() {
    
    echo "Creating k3d cluster 'clappitucp'..."
    k3d cluster create clappitucp
    

    # Verify kubectl context
    echo "Verifying kubectl context..."
    if kubectl cluster-info; then
        echo "kubectl is configured correctly with the k3d cluster 'clappitucp'."
    else
        echo "kubectl is not configured correctly with the k3d cluster 'clappitucp'."
        exit 1
    fi
}

start_minikube() {
    echo "Starting minikube..."
    minikube start

}

check_kind_cluster() {
    cluster_name="$1"
    clusters=$(kind get clusters)
    if echo "$clusters" | grep -q "$cluster_name"; then
        echo "Cluster '$cluster_name' exists."
    else
        kind create cluster --name $cluster_name --wait 5m
    fi
}


# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update and install prerequisites
echo "Updating package list and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2

# Check and install Docker
if command_exists docker; then
    echo "Docker is already installed."
else
    install_docker
fi

# Check and install k3d
if command_exists kind; then
    echo "kind is already installed."
else
    install_kind_cluster
fi

# Check and install kubectl
if command_exists kubectl; then
    echo "kubectl is already installed."
else
    install_kubectl
fi

# Check and install Helm
if command_exists helm; then
    echo "Helm is already installed."
else
    install_helm
fi

# Verify installations
echo "Verifying installations..."
docker --version
kind version
kubectl version --client
helm version

# Create k3d cluster and verify kubectl
#create_k3d_cluster

# Start minikube
#start_minikube
cluster_name_to_check="clappitucp"
check_kind_cluster "$cluster_name_to_check"

# Add Crossplane Helm repository and install Crossplane
echo "Installing Crossplane..."
if ! helm repo list | grep -q "crossplane-stable"; then
    helm repo add crossplane-stable https://charts.crossplane.io/stable
    helm repo update
else
    echo "Crossplane Helm repository is already added."
fi

#kubectl create namespace crossplane-system
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane --set 'args={--debug}' --create-namespace

echo "Waiting for 1 minute..."
sleep 60

# Wait for Crossplane to be ready
kubectl wait --for=condition=ready pods --all --namespace crossplane-system --timeout=300s

# Continue with further operations
# Continue with further operations
#echo "Proceeding with further operations..."

helm install xproviders oci://index.docker.io/clappit/xproviders --version 0.1.0 -n crossplane-system --create-namespace

# Wait for providers to be ready
#kubectl wait --for=condition=healthy providers --all --timeout=300s


echo "CLAPPIT PRE-REQUISITES INSTALLED SUCCESSFULLY"