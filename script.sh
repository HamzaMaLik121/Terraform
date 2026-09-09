#!/bin/bash
set -e

sudo apt-get update -y

sudo apt-get install -y nginx docker.io

sudo systemctl start nginx
sudo systemctl enable nginx

sudo systemctl start docker
sudo systemctl enable docker

echo "<h1>Hamza is among those who are billionaires</h1>" | sudo tee /var/www/html/index.html