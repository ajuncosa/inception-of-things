#!/bin/sh

apt-get update
apt-get install curl -y

mkdir -p /etc/rancher/k3s
cp /vagrant/confs/config.agent.yml /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | sh -s - agent