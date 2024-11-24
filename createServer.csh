#!/bin/bash

# This script updates the Ubuntu system to the latest available packages, installs and enables RDP, installs Git, mounts HDD, and configures UFW firewall settings

# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root"
  exit 1
fi

# Update the package list
sudo apt update

# Upgrade all installed packages to the latest version
sudo apt upgrade -y

# Optionally, remove unused packages and dependencies
sudo apt autoremove -y

# Optionally, clean up the local repository of retrieved package files
sudo apt clean

# Update complete
echo "System update complete!"

# Install and enable RDP (xrdp)
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp
echo "RDP installation and service enabled."

# Install Git
sudo apt install -y git
echo "Git installation complete."
sudo apt install net-tools

# Configure UFW firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow basic ports (SSH, HTTP, HTTPS), RDP port, and port number 28
sudo ufw allow 22/tcp  # SSH
sudo ufw allow 80/tcp  # HTTP
sudo ufw allow 443/tcp # HTTPS
sudo ufw allow 3389/tcp # RDP
sudo ufw allow 28/tcp  # Custom port 28

# Enable UFW
sudo ufw enable

echo "UFW firewall configured to block all ports except basic services, RDP, and port 28."


### install openroad
cd /media/skillsoc/skillsoc
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
cd OpenROAD-flow-scripts

sudo ./setup.sh
sudo ./build_openroad.sh --local
#sudo ./tools/OpenROAD/etc/DependencyInstaller.sh

