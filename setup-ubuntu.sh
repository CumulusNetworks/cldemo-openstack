#!/usr/bin/env bash

#Fix the ssim hosts
echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Install git and other utils
echo "[Install system tools] Install git, sshpass, python tools"
apt update
apt install -y python3 sshpass git python-setuptools python-cryptography \
libvirt-bin libvirt0 libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev \
build-dep ruby-libvirt qemu libvirt-bin ebtables dnsmasq lxc bridge-utils \
debootstrap

#Install pip
echo "[Install pip] Install pip"
easy_install pip

# Install Ansible and all dependencies
echo '[Install Ansible] Install all required Python Packages'
pip install -r requirements.txt

echo '[Install Vagrant] Install vagrant and required plugins'
wget -4 https://releases.hashicorp.com/vagrant/2.1.2/vagrant_2.1.2_x86_64.deb
dpkg -i vagrant_2.1.2_x86_64.deb

vagrant plugin install vagrant-libvirt

echo '[Install Complete]


