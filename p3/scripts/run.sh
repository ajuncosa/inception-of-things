#!/bin/bash

echo -e '\033[1;34mInstalling software prerequisites...\033[0m'
bash install-sw.sh

echo -e '\033[1;34mSetting up k3d cluster and deploying app...\033[0m'
sudo bash setup-cluster.sh
