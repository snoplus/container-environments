#!/bin/bash

set -ex

#--- Dependencies and other tools ---#
sudo apt-get update && sudo apt-get dist-upgrade -y
sudo apt-get install -y apt-transport-https ca-certificates curl \
    software-properties-common wget git python cgroup-tools golang \
    build-essential uuid-dev libgpgme-dev squashfs-tools libseccomp-dev \
    pkg-config cryptsetup-bin make emacs voms-clients-java myproxy

#--- Create snoprod user (accessible only via SSH key, no password) ---#
sudo adduser --disabled-password --gecos "" --home /home/snoprod --shell /bin/bash snoprod

#--- Install unattended-upgrades to automatically install security patches daily ---#
sudo apt-get install -y unattended-upgrades

#--- Install and configure fail2ban to help with SSH bruteforcing ---#
sudo apt-get install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i 's/^#bantime\.increment = true/bantime\.increment = true/' /etc/fail2ban/jail.local

#--- Set up ephemeral storage as scratch ---#
### LIKELY ONLY NECESSARY FOR OPENSTACK
sudo mkdir /mnt/scratch /scratch
sudo chown snoprod /mnt/scratch /scratch
echo "/mnt/scratch    /scratch    none bind" | sudo tee -a /etc/fstab
sudo mount -a

#--- Install CVMFS acording to official docs ---#
wget https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest_all.deb
sudo dpkg -i cvmfs-release-latest_all.deb
sudo apt-get update -y
sudo apt-get install -y cvmfs
sudo rm -f cvmfs-release-latest_all.deb

# Ensure AutoFS is working
sudo cvmfs_config setup

# Set up the CVMFS config file with the necessary repos and proxy config
echo "CVMFS_REPOSITORIES='grid.cern.ch,sft.cern.ch,snoplus.egi.eu'" | sudo tee /etc/cvmfs/default.local
echo "CVMFS_HTTP_PROXY='DIRECT'" | sudo tee -a /etc/cvmfs/default.local

# Reload config and verify the repos are reachable
sudo cvmfs_config reload
sudo cvmfs_config probe

#--- Install Singularity ---#
export VERSION=3.7.4
wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
tar -xzf singularity-${VERSION}.tar.gz
rm -f singularity-${VERSION}.tar.gz
cd singularity

# Run installer
./mconfig
make -C ./builddir
sudo make -C ./builddir install

# Cleanup
cd ..
sudo rm -rf ./singularity ./go

# Test
singularity --version

sudo reboot
