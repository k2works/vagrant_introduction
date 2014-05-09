#!/usr/bin/env bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant /var/www
