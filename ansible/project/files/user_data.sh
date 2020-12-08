#!/bin/sh
sudo yum install git -y
sudo amazon-linux-extras install ansible -y
sudo git clone https://github.com/sohailyu/DevOps-References.git ./tmp/ 
cd /tmp sudo && ansible-playbook ansible/project/s3.yml
