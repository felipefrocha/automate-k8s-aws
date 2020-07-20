#!/bin/bash
yum update -y
yum install httpd -y
chkconfig httpd on
service httpd start
cd /var/www/html
echo "<html><h1>Hello DTI!</h1><h2>This is the DTI Kubernets <strong>fake</stron> Web Server</h2></html>" > index.html