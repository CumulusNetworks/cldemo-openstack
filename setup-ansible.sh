#!/usr/bin/env bash

#Fix the ssim hosts
route del default
route add default gw 192.168.0.2 eth0
rm /etc/apt/sources.list.d/elasticsearch-2.x.list
echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Usage Example:
# ./setup-ansible.sh [version]
# Look up https://github.com/ansible/ansible for version tags to use

#not used yet
versionTag=$1

# Install git and other utils
echo "[Install Ansible] Install git and sshpass"
apt update
apt install -y python3 sshpass git python-setuptools

#Install pip
echo "[Install Ansible] Install git and sshpass"
easy_install pip

# Install Ansible
echo '[Install Ansible] Install Ansible'
pip install ansible

echo '[Install Ansible] Done!'


