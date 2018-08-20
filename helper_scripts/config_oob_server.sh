#!/bin/bash

#This file is transferred to a Debian/Ubuntu Host and executed to re-map interfaces
#Extra config COULD be added here but I would recommend against that to keep this file standard.
echo "#################################"
echo "  Running OOB server config"
echo "#################################"
sudo su

#Replace existing network interfaces file
echo "  Adding lo config"
echo -e "auto lo" > /etc/network/interfaces
echo -e "iface lo inet loopback\n\n" >> /etc/network/interfaces
echo -e  "source /etc/network/interfaces.d/*.cfg\n" >> /etc/network/interfaces

#Add vagrant interface
echo "  Adding eth0 config"
echo -e "\n\nauto eth0" >> /etc/network/interfaces
echo -e "iface eth0 inet dhcp\n\n" >> /etc/network/interfaces

####### Custom Stuff
echo "  Adding eth1 config"
echo "auto eth1" >> /etc/network/interfaces
echo "iface eth1 inet static" >> /etc/network/interfaces
echo "    address 192.168.200.254" >> /etc/network/interfaces
echo "    netmask 255.255.255.0" >> /etc/network/interfaces

echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus
sed "s/PasswordAuthentication no/PasswordAuthentication yes/" -i /etc/ssh/sshd_config


echo "  ifuping eth1 and restarting SSH"
ifup eth1
service ssh restart

echo " ### Overwriting DNS Server to 8.8.8.8 ###"
#Required because the installation of DNSmasq throws off DNS momentarily
echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head

echo " ### Updating APT Repository... ###"
apt-get update -y

echo " ### Installing Packages... ###"
apt-get install -y htop isc-dhcp-server tree apache2 vlan git python-pip dnsmasq ifenslave apt-cacher-ng sshpass lldpd
echo " ### Installing ansible... ###"
apt-get install -y build-essential libssl-dev libffi-dev python-dev
pip install pip --upgrade
pip install setuptools --upgrade
pip install ansible --upgrade

echo " ### Moving Ansible Hostfile into place ###"
mkdir -p /etc/ansible
mv /home/vagrant/ansible_hostfile /etc/ansible/hosts

echo " ### Creating cumulus user ###"
useradd -m cumulus

echo "  Adding cumulus plaintext password"
sed -i '/cumulus/c\cumulus:$6$sL6mBTLX$DSiRA6w87n74HPpiyR/7igb7fvwTzo23oMdvNHoTSia4glKpurK5nM7by8zFTwUtjhkJNVS6F8cAN420cEeMa/:17172::::::' /etc/shadow

echo " ### Setting Up DHCP ###"
mv /home/vagrant/dhcpd.conf /etc/dhcp/dhcpd.conf
mv /home/vagrant/dhcpd.hosts /etc/dhcp/dhcpd.hosts
chmod 755 -R /etc/dhcp/*
systemctl restart isc-dhcp-server

echo " ### Setting Up Hostfile ###"
mv /home/vagrant/hosts /etc/hosts

echo " ##Overwriting private key for cumulus user "

mkdir /home/cumulus/.ssh
cat <<EOT > /home/cumulus/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAsx/kflIY1YnFLSNHWjVHHnWIX74E9XW2V4GN9yG5uDDqPl/O
CMLs4q5t0BZ2H9jt7smYzcqwOn4/ahROxJLpeGw+jwrLULqVz8HzzI57NjO7ZB7C
py2IzcVjapf6wlMaB9gepz8s7XEQmrLN5SHNnJX15AmPSbX+5IAtnv3ZnIcsD1eT
6xarZR4GVJ8qD8lgR+zozy1cWMLQiZ/erBZK42hvUAznqHojb3BpZOAyaf4PS+H9
gGhKuvcfPoAUxVKgBbA/HnDveNXDPLGtdeu67ET8e0it9u9CYuRFBd5WbIKWoiID
IbSAf+0DU5DfWY0AWs8cZTVTelrYRfKJG+zkrQIDAQABAoIBAAqDBp+7JaXybdXW
SiurEL9i2lv0BMp62/aKrdAg9Iswo66BZM/y0IAFCIC7sLbxvhTTU9pP2MO2APay
tmSm0ni0sX8nfQMB0CTfFvWcLvLhWk/n1jiFXY/l042/2YFp6w8mybW66WINzpGl
iJu3vh9AVavKO9Rxj8HNG+BGuWyMEQ7TB4JLIGOglfapHlSFzjBxlMTcVA4mWyDd
bztzh+Hn/J7Mmqw+FqmFXha+IWbojiMGTm1wS/78Iy7YgWpUYTP5CXGewC9fGnoK
H3WvZDD7puTWa8Qhd5p73NSEe/yUd5Z0qmloij7lUVX9kFNVZGS19BvbjAdj7ZL6
OCVLOkECgYEA3I7wDN0pmbuEojnvG3k09KGX4bkJRc/zblbWzC83rFzPWTn7uryL
n28JZMk1/DCEGWtroOQL68P2zSGdF6Yp3PAqsSKHks9fVJsJ0F3ZlXkZHtRFfNI7
i0dl5SsSWlnDPiSnC4bshM25vYb4qd3vij7vvHzb3rA3255u69aU0DkCgYEAz+iA
qoLEja9kTR+sqbP9zvHUWQ/xtKfNCQ5nnjXc7tZ7XUGEf0UTMrAgOKcZXKDq6g5+
hNTkEDPUpPwGhA4iAPbA96RNWh/bwClFQEkBHU3oHPzKcL2Utvo/c6pAb44f2bGD
9kS4B/sumQxvUYM41jfwXDFTNPXN/SBn2XnWUBUCgYBoRug1nMbTWTXvISbsPVUN
J+1QGhTJPfUgwMvTQ6u1wTeDPwfGFOiKW4v8a6krb6C1B/Wd3tPIByGDgJXuHXCD
dcUpdGLWxVaUAK0WJ5j8s4Ft8vxbdGYUhpAlVkTaFMBbfCbCK2tdqopbkhm07ioX
mYPtALdPRM9T9UcKF6zJ+QKBgQCd57lpR55e+foU9VyfG1xGg7dC2XA7RELegPlD
2SbuoynY/zzRqLXXBpvCS29gwbsJf26qFkMM50C2+c89FrrOvpp6u2ggbhfpz66Q
D6JwDk6fTYO3stUzT8dHYuRDlc8s+L0AGtsm/Kg8h4w4fZB6asv8SV4n2BTWDnmx
W+7grQKBgQCm52n2zAOh7b5So1upvuV7REHiAmcNNCHhuXFU75eZz7DQlqazjTzn
CNr0QLZlgxpAg0o6iqwUaduck4655bSrClg4PtnzuDe5e2RuPNSiyZRbUmmiYIYp
i06Z/SJZSH8a1AjEh2I8ayxIEIESpmyhn1Rv1aUT6IjmIQjgbxWxGg==
-----END RSA PRIVATE KEY-----
EOT

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UhjVicUtI0daNUcedYhfvgT1dbZXgY33Ibm4MOo+X84Iwuzirm3QFnYf2O3uyZjNyrA6fj9qFE7Ekul4bD6PCstQupXPwfPMjns2M7tkHsKnLYjNxWNql/rCUxoH2B6nPyztcRCass3lIc2clfXkCY9Jtf7kgC2e/dmchywPV5PrFqtlHgZUnyoPyWBH7OjPLVxYwtCJn96sFkrjaG9QDOeoeiNvcGlk4DJp/g9L4f2AaEq69x8+gBTFUqAFsD8ecO941cM8sa1167rsRPx7SK3270Ji5EUF3lZsgpaiIgMhtIB/7QNTkN9ZjQBazxxlNVN6WthF8okb7OSt" >> /home/cumulus/.ssh/id_rsa.pub
chmod 400 /home/cumulus/.ssh/id_rsa
chmod 700 /home/cumulus/.ssh/id_rsa.pub
chown cumulus:cumulus -R /home/cumulus/.ssh

cp /home/cumulus/.ssh/id_rsa /home/vagrant/.ssh/id_rsa
cp /home/cumulus/.ssh/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
chown vagrant:vagrant -R /home/vagrant/.ssh


echo "#################################"
echo "   Finished"
echo "#################################"
