#!/bin/bash

CURRENTDIR=$(pwd)
mkdir -p /tmp/installers

echo 'Downloading VS Code Installer'
cd /tmp/installers/
wget https://go.microsoft.com/fwlink/?LinkID=760868
mv index.html?LinkID=760868 vscode.deb

echo 'setting file permissions'
sudo chmod +x vscode.deb

echo 'installing vs code'
sudo dpkg -i vscode.deb

echo 'removing installer'
rm -rf vscode.deb

echo 'VS Code Install Complete'
cd $CURRENTDIR