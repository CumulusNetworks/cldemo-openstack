#!/usr/bin/env bash

# Usage Example:
# ./setup-ansible.sh [version]
# Look up https://github.com/ansible/ansible for version tags to use

#not used yet
versionTag=$1

# Install git and other utils
echo "[Install Ansible] Install git and sshpass"
apt update
apt install -y python3 sshpass git

#Install pip
echo "[Install Ansible] Install git and sshpass"
easy_install pip3

# Install Ansible
echo '[Install Ansible] Install Ansible'
pip3 install ansible

echo '[Install Ansible] Done!'

#Fix the ssim hosts
route del default
route add default gw 192.168.0.2 eth0
rm /etc/apt/sources.list.d/elasticsearch-2.x.list
