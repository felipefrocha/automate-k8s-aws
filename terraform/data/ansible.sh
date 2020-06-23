#!/bin/bash
sleep 20
export ANSIBLE_HOST_KEY_CHECKING=false
ssh-agent bash && ssh-add ../aws_educate.pem
ansible-playbook -i ../ansible/hosts ../ansible/cluster_init.yaml
