#!/bin/bash

# Create namespaces
kubectl apply -f iot-apavel/app/dev-namespace.yaml
kubectl apply -f argo-namespace.yaml

# Create app resources
kubectl apply -f iot-apavel/app/deployment.yaml
kubectl apply -f iot-apavel/app/service.yaml

# Create argocd resources
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Turn argocd-server service into a LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Instalar CLI argocd
# brew install argocd #MACOS
# TODO: Instalar CLI argocd en maquina virtual de 42

# Change admin user's password
# TODO: meter la contraseña con un secret o un kustomization o algo
kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}' #mysupersecretpassword
