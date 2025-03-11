#!/bin/bash

echo '    Node and NPM easy install for Debian'
sleep 1

echo 'Pulling updates'
sudo apt-get update

echo 'Installing CURL'
sudo apt-get install curl

echo 'Downloading packages'
curl -sL https://deb.nodesource.com/setup_22.x | sudo -E bash -

echo 'Installing Node and NPM'
sudo apt-get install -y nodejs

echo 'Installing common npm packages'
sudo npm install -g nodemon live-server -y

echo 'Node installation complete'