#!/bin/sh

#TODO: install docker
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sh
k3d cluster create mycluster
kubectl apply -f dev-namespace.yaml
kubectl apply -f argo-namespace.yaml
