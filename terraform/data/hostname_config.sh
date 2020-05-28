#!/bin/bash
hostname ${hostname}
hostname > /etc/hostname
cat /home/ubuntu/.bashrc > ~/.bashrc && echo 'source <(kubectl completion bash)' >> ~/.bashrc
kubectl completion bash > /etc/bash_completion.d/kubectl