#!/bin/sh

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install k3s
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sh

# install kubectl
sudo apt-get install -y apt-transport-https
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# create cluster
sudo k3d cluster create mycluster -p "80:80@loadbalancer" -p "443:443@loadbalancer" -p "8080:8080@loadbalancer"

# configure kubernetes
sudo kubectl apply -f iot-apavel/dev-namespace.yaml
sudo kubectl apply -f iot-apavel/argo-namespace.yaml
sudo kubectl apply -f iot-apavel/deployment.yaml
sudo kubectl apply -f iot-apavel/service.yaml
sudo kubectl apply -f iot-apavel/ingress.yaml
