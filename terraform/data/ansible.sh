#!/bin/bash
sleep 20
export ANSIBLE_HOST_KEY_CHECKING=false
eval `ssh-agent -s` && ssh-add ../aws_educate.pem
ansible-playbook -i ../ansible/hosts ../ansible/cluster_init.yaml
