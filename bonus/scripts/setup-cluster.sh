#!/bin/bash

# Create k3d cluster
k3d cluster create mycluster -p "80:80@loadbalancer" -p "443:443@loadbalancer" -p "8888:8888@loadbalancer"

# Create namespaces
kubectl create namespace dev
kubectl create namespace argocd
kubectl create namespace gitlab


# Install GitLab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
	--timeout 600s \
	--values ../confs/gitlab-values.yaml \
	--namespace gitlab
#  --set global.hosts.domain=localhost \
#  --set global.hosts.externalIP=127.0.0.1 \
#  --set certmanager-issuer.email=me@example.com \
#  --set postgresql.image.tag=13.6.0


# Create argocd resources
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Turn argocd-server service into a LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Wait for argocd-server service
echo -e '\033[1;34mWaiting for argocd-server service to become available...\033[0m'
kubectl wait deployment/argocd-server -n argocd --for=condition=Available=true --timeout=300s

# Change argocd admin user's password
kubectl -n argocd patch secret argocd-secret \
	-p '{"stringData": {
		"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6",
		"admin.passwordMtime": "'$(date +%FT%T%Z)'"
	}}' #mysupersecretpassword

# Create app
kubectl apply -f ../confs/application.yaml
