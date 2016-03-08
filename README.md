# Trainer tools for Docker workshops

## Requirements

Required environment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION`


Currently, it is not possible to specify a custom tag.

## Usage

You can create a symlink in your path for this script:

  ln -s $PWD/trainer $HOME/bin/trainer

But note that the script is not smart enough to know its real directory,
so only use the symlink there!

### Start some VMs

    $ ./trainer start 10

A few things will happen:

#### Instance + tag creation

10 VMs will be started and tagged with a timestamp + your username.

#### Sync of SSH keys

When the `start` command is run, your local RSA SSH public key will be added to your AWS EC2 keychain.

To see which local key will be uploaded, run `ssh-add -l | grep RSA`.

#### Creation of ./$TAG/ directory and contents

Following the creation of the VMs, a text file will be created containing a list of their IPs.

This ips.txt file will be created in the $TAG/ directory and a symlink will be placed in the working directory of the script.

#### Deployment

If the instances were created successfully, the script will attempt to deploy them.

Instances can also be deployed manually using the `deploy` command.

### List VMs

    $ ./trainer list TAG

This will print a human-friendly list containing some information about each instance.

### Deploy VMs

    $ ./trainer deploy TAG

This file will be copied via parallel-ssh to all of the VMs and executed.


### Stop and destroy VMs

    $ trainer stop TAG

## To do

### Optional environment variables:

* `AWS_INSTANCE_TYPE` (current behavior: `m3.large`)
* `WORKSHOP_TAG` (current behavior: tag generated with your username and today's date)

### Symlink support

Allow running a symlink to ./trainer from any working directory.

### Custom deployment behavior

Allow configuration of the VMs based on the workshop you're administering. 

Current behavior: defaults to postprep.rc
