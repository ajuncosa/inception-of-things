#!/bin/bash

#kubectl apply -f iot-apavel/app/dev-namespace.yaml
kubectl apply -f argo-namespace.yaml

#kubectl apply -f iot-apavel/deployment.yaml
#kubectl apply -f iot-apavel/service.yaml
#kubectl apply -f iot-apavel/ingress.yaml

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl apply -f argocd-ingress.yaml

# Instalar CLI argocd
# brew install argocd #MACOS
# TODO: Instalar CLI argocd en maquina virtual de 42

# Cambiar la contraseña del usuario admin
kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {"admin.password": "$2y$12$Kg4H0rLL/RVrWUVhj6ykeO3Ei/YqbGaqp.jAtzzUSJdYWT6LUh/n6", "admin.passwordMtime": "'$(date +%FT%T%Z)'"}}' #mysupersecretpassword