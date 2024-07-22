#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install a package using Homebrew
install_package() {
    if ! command_exists "$1"; then
        echo "Installing $1..."
        brew install "$1"
    else
        echo "$1 is already installed."
    fi
}

# Function to check if Docker is installed and start it if necessary
check_and_start_docker() {
    SHELL_TYPE="$(basename "$SHELL")"

    if ! command_exists docker; then
        echo "Docker not found, installing Docker..."
        brew install docker docker-credential-helper colima
        cat <<EOF > ~/.docker/config.json
{
    "auths": {},
    "credsStore": "osxkeychain",
    "currentContext": "colima"
}
EOF
        if [ "$SHELL_TYPE" = "bash" ]; then
            echo "alias docker-start='colima start'" >> ~/.bash_profile
            echo "alias docker-stop='colima stop'" >> ~/.bash_profile
        elif [ "$SHELL_TYPE" = "zsh" ]; then
            echo "alias docker-start='colima start'" >> ~/.zshrc
            echo "alias docker-stop='colima stop'" >> ~/.zshrc
        else
            echo "Unsupported shell: $SHELL_TYPE"
        fi
        echo "Docker installed successfully."
        echo "Starting Docker..."
        colima start
        docker-start
        while (! command_exists docker); do
            sleep 1
        done
        echo "Docker started successfully."
    else
        echo "Docker is already running."
    fi
}

install_kind_cluster() {
    brew install kind
}

check_kind_cluster() {
    cluster_name="$1"
    clusters=$(kind get clusters)
    if echo "$clusters" | grep -q "$cluster_name"; then
        echo "Cluster '$cluster_name' exists."
    else
        cat <<EOF > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    image: kindest/node:v1.23.0
EOF
        kind create cluster --name $cluster_name --config kind-config.yaml --wait 5m
    fi
}

echo "Installing prerequisites for clappit on macOS..."

# Ensure Homebrew is installed for macOS
if ! command_exists brew; then
    echo "Homebrew not found, installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update Homebrew
brew update

# Install prerequisites using Homebrew
brew install curl jq

# Check if Docker is already installed and started
check_and_start_docker
#colima start

# Check if kind is already installed
if ! command_exists kind; then
    install_kind_cluster
fi

# Verify k3d installation
#minikube version
#minikube start
# Function to check if a k3d cluster exists
cluster_exists() {
    k3d cluster list | grep -q "$1"
}

# Function to create a k3d cluster
create_cluster() {
    echo "Creating k3d cluster..."
    k3d cluster create "$1"
}

# Check if the cluster already exists
#if ! cluster_exists clappitucp; then
    #create_cluster clappitucp
#else
    #echo "k3d cluster 'mycluster' already exists."
#fi

# Function to install kubectl
install_kubectl() {
    if ! command_exists kubectl; then
        echo "Installing kubectl..."
        KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
        curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/darwin/amd64/kubectl"
        chmod +x kubectl
        mv kubectl ~/bin/
    else
        echo "Kubernetes is already installed."
    fi
    
}

# Function to verify kubectl installation
verify_kubectl() {
    echo "Verifying kubectl installation..."
    kubectl version --client
}

# Install kubectl
install_kubectl

# Verify kubectl installation
verify_kubectl

# Function to install Helm
install_helm() {
    if ! command_exists helm; then
        echo "Installing Helm..."
        brew install helm
    else
        echo "Helm is already installed."
    fi
}

# Function to verify Helm installation
verify_helm() {
    echo "Verifying Helm installation..."
    helm version
}

# Install Helm
install_helm

# Verify Helm installation
verify_helm


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


echo "CLAPPIT PREQUSITES INSTALLED SUCCESSFULLY"
