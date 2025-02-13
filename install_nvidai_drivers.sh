#!/bin/bash

# Install Nvidia Driver
sudo apt update
sudo apt install -y ubuntu-drivers-common
sudo apt install nvidia-driver-550
sudo reboot

