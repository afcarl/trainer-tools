#!/bin/sh


# On EC2, the ephemeral disk might be mounted on /mnt.
# If /mnt is a mountpoint, place Docker workspace on it.
#if mountpoint -q /mnt
#then
#	mkdir /mnt/docker
#	ln -s /mnt/docker /var/lib/docker
#fi

# Set the hostname to be the public IP address of the instance.
# If the call to myip fails, set a default hostname.
#if ! curl --silent --fail http://myip.enix.org/REMOTE_ADDR >/etc/hostname; then
#    echo dockerhost >/etc/hostname
#fi
#hostname $(cat /etc/hostname)

# Temporary prompt to show that we're not done cloudinit-ing yet.
#update_status " [creating docker user]"

# Create Docker user.
#useradd -d /home/docker -m -s /bin/bash docker

#echo docker:training | chpasswd

#echo "docker ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/docker

#sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#service ssh restart

#apt-get -q update
#apt-get -qy install git jq python-pip

# This will install the latest Docker.
#curl https://get.docker.com/ | sh

# Make sure that the daemon listens on 55555 (for orchestration workshop).
#sed -i 's,-H fd://$,-H fd:// -H tcp://0.0.0.0:55555,' /lib/systemd/system/docker.service
#systemctl daemon-reload

# There seems to be a bug in the systemd scripts; so work around it.
# See https://github.com/docker/docker/issues/18444
#systemctl start docker || true

#update_status " [installing compose]"
#pip install -U docker-compose

## Link so that older versions of the training still work properly
#ln -s /usr/local/bin/docker-compose /usr/local/bin/fig

# Wait for docker to be up.
# If we don't do this, Docker will not be responsive during the next step.
#while ! docker version
#do
#	sleep 1
#done

# Pre-pull a bunch of images.
#for I in \
#	debian:latest ubuntu:latest fedora:latest centos:latest \
#	postgres redis training/namer nathanleclaire/redisonrails

#do
#	docker pull $I
#done

# Fancy prompt courtesy of @soulshake.
#update_status "DONE"
