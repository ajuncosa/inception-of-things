#!/bin/bash

kubectl apply -f iot-apavel/dev-namespace.yaml
kubectl apply -f iot-apavel/argo-namespace.yaml

kubectl apply -f iot-apavel/deployment.yaml
kubectl apply -f iot-apavel/service.yaml

kubectl apply -f iot-apavel/ingress.yaml
