Openstack Demo
==============
This demo is an ansible playbook that installs Openstack Juno on the reference topology.

This demo is written for the [cldemo-vagrant](https://github.com/cumulusnetworks/cldemo-vagrant) reference topology and applies the reference BGP unnumbered configuration from [cldemo-config-routing](https://github.com/cumulusnetworks/cldemo-config-routing).


Quickstart: Run the demo
------------------------
(This assumes you are running Ansible 1.9.4 and Vagrant 1.8.4 on your host.)

    git clone https://github.com/cumulusnetworks/cldemo-vagrant
    cd cldemo-vagrant

Before you get started, you will need to increase the memory allocated to server01.
Find the file named `Vagrantfile` and find the stanza for `server01`. Replace
`v.memory = 512` with `v.memory = 3072`.

    vagrant up oob-mgmt-server oob-mgmt-switch leaf01 leaf02 spine01 spine02 server01 server02 leaf03 leaf04 server03 server04
    vagrant ssh oob-mgmt-server
    sudo su - cumulus
    sudo apt-get install software-properties-common -y
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt-get update
    sudo apt-get install ansible -qy
    git clone https://github.com/cumulusnetworks/cldemo-openstack
    cd cldemo-openstack
    ansible-playbook run-demo.yml
    ssh server01
    . demo-openrc

Launch a single VM instance on the shared provider network.

    openstack server create --flavor m1.nano --image cirros --nic net-id=provider --security-group default cirros01
    ping 192.168.0.101 #wait until it starts responding
    ssh cirros@192.168.0.101
    # password is "cubswin:)"
    hostname
    ping google.com
    exit

Create a private tenant network and launch a VM in it. Give it a floating IP address.

    neutron net-create demonet
    neutron subnet-create --name demonet --dns-nameserver 8.8.8.8 --gateway 200.0.0.1 demonet 200.0.0.0/24
    neutron router-create demorouter
    neutron router-interface-add demorouter demonet
    neutron router-gateway-set demorouter provider
    openstack server create --flavor m1.nano --image cirros --nic net-id=demonet --security-group default cirros02
    openstack ip floating create provider
    openstack ip floating add FLOATING_IP_FROM_LAST COMMAND cirros02
    ping FLOATING_IP_FROM_LAST COMMAND
    ssh cirros@FLOATING_IP_FROM_LAST COMMAND
    hostname
    ping google.com
    exit

Access the horizon dashboard. In a new terminal, run the following command:

    ssh -L 8080:server01:80 cumulus@127.0.0.1 -p 2222

The password is `CumulusLinux!`. Leave that terminal open - this will create a
tunnel so that you can access the horizon dashboard. Open
http://localhost:8080/horizon in your browser. Log in with the demo user
(password is `demo`) and the default domain. You should be able to see the two
instances created in the last two steps. Unfortunately, due to the way that the
Vagrant topology is set up, you will not be able to access the VNC console
normally.



Tips
----
Open the tunnel:

    ssh -L 6080:localhost:8888 cumulus@127.0.0.1 -p 2222 ssh -L 8888:controller:6080 server01
    ssh -L 8080:server01:80 cumulus@127.0.0.1 -p 2222
