#!/bin/bash

while ! grep "Cloud-init .* finished" /var/log/cloud-init.log; do
    echo "$(date -Ins) Waiting for cloud-init to finish"
    sleep 2
done

sudo apt-get update
sudo apt-get install -y python python-pip