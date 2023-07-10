#!/bin/bash

# Create k3d cluster
k3d cluster create mycluster -p "80:80@loadbalancer" -p "443:443@loadbalancer" -p "8888:30036@loadbalancer"

# Create namespaces
kubectl apply -f ../confs/dev-namespace.yaml
kubectl apply -f ../confs/argo-namespace.yaml

# Create argocd resources
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Turn argocd-server service into a LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Wait for argocd-server service
echo -e '\033[1;34mWaiting for argocd-server service to become available...\033[0m'
kubectl wait deployment/argocd-server -n argocd --for=condition=Available=true --timeout=300s

# Change argocd admin user's password
# TODO: meter la contraseña con un secret o un kustomization o algo
kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}' #mysupersecretpassword

# Create app
kubectl apply -f ../confs/application.yaml
