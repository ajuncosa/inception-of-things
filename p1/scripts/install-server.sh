#!/bin/sh

mkdir -p /etc/rancher/k3s
cp /vagrant/confs/config.server.yml /etc/rancher/k3s/config.yaml
curl -sfL https://get.k3s.io | sh -s - server