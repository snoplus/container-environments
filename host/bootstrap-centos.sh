#!/bin/bash

set -e

#--- Dependencies and other tools ---#
sudo yum update -y
sudo yum -y install epel-release
sudo yum groupinstall -y 'Development Tools'
sudo yum install -y ca-certificates curl wget git python libcgroup libcgroup-tools \
    libuuid-devel gpgme-devel squashfs-tools libseccomp-devel pkgconfig make emacs \
    voms-clients-java myproxy yum-cron fail2ban openssl-devel cryptsetup singularity

# Set up automatic security updates
sudo systemctl start yum-cron
sudo systemctl enable yum-cron
sed -i 's/update_cmd = default/update_cmd = security/' yum-cron.conf
sed -i 's/apply_updates = no/apply_updates = yes/' yum-cron.conf
sudo systemctl restart yum-cron

#--- Create snoprod user (accessible only via SSH key, no password) ---#
sudo useradd snoprod -d /home/snoprod

#--- Install and configure fail2ban to help with SSH bruteforcing ---#
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo sed -i 's/^#bantime\.increment = true/bantime\.increment = true/' /etc/fail2ban/jail.local

#--- Set up ephemeral storage as scratch ---#
## LIKELY ONLY NECESSARY FOR OPENSTACK
sudo mkdir /mnt/scratch /scratch
sudo chown snoprod /mnt/scratch /scratch
echo "/mnt/scratch    /scratch    none bind" | sudo tee -a /etc/fstab
sudo mount -a

#--- Install CVMFS acording to official docs ---#
sudo yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
sudo yum install -y cvmfs

# Ensure AutoFS is working
sudo cvmfs_config setup

# Set up the CVMFS config file with the necessary repos and proxy config
echo "CVMFS_REPOSITORIES='grid.cern.ch,sft.cern.ch,snoplus.egi.eu'" | sudo tee /etc/cvmfs/default.local
echo "CVMFS_HTTP_PROXY='DIRECT'" | sudo tee -a /etc/cvmfs/default.local

# Reload config and verify the repos are reachable
sudo cvmfs_config reload
sudo cvmfs_config probe

sudo reboot
