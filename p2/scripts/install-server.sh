#!/bin/sh

mkdir -p /etc/rancher/k3s
cp /vagrant/confs/config.server.yml /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | sh -s - server

kubectl apply -f /vagrant/confs/app-one.yaml
kubectl apply -f /vagrant/confs/app-two.yaml
kubectl apply -f /vagrant/confs/app-three.yaml
kubectl apply -f /vagrant/confs/ingress.yaml
