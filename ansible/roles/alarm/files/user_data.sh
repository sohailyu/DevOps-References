#!/bin/sh
sudo yum install git -y
sudo amazon-linux-extras install ansible -y
sudo git clone https://github.com/sohailyu/DevOps-References.git /tmp/abcd 
cd /tmp/abcd && ansible-playbook ansible/playbooks/02_InstallingSoftware.yml
