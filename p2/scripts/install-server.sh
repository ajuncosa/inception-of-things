#!/bin/sh

apt-get update
apt-get install curl -y

mkdir -p /etc/rancher/k3s
cp /vagrant/confs/config.server.yml /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | sh -s - server

kubectl apply -f /vagrant/confs/app-one/index-html-configmap.yaml
kubectl apply -f /vagrant/confs/app-two/index-html-configmap.yaml
kubectl apply -f /vagrant/confs/app-three/index-html-configmap.yaml

kubectl apply -f /vagrant/confs/app-one/app-one.yaml
kubectl apply -f /vagrant/confs/app-two/app-two.yaml
kubectl apply -f /vagrant/confs/app-three/app-three.yaml

kubectl apply -f /vagrant/confs/ingress.yaml
