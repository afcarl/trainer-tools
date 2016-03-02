# Trainer tools for Docker workshops

## Requirements

Required environment variables:

* `AWS_SECRET_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`

Optional environment variables:

* `AWS_REGION` (defaults to `us-west-1`
* `AWS_INSTANCE_TYPE` (defaults to `m3.large`)
* `WORKSHOP_TAG` (defaults to your username and today's date)

## Usage


### Start some VMs

    $ ./train start 10

If no VMs tagged YOUR_TAG exist yet, 10 will be started.

If 2 already exist, 8 more will be started.

#### Sync of SSH keys

When the `start` command is run, any public SSH keys you've added locally (`ssh-add`) will be added to your AWS EC2 keychain.

Run `ssh-add -L` or `-l` to see local keys.

#### Creation of ips_YOUR_TAG.txt

Following the creation of the VMs, a text file will be created containing a list of their IPs.

### List VMs

    $ ./train list

### Deploy VMs

You probably want some configuration of the VMs based on the workshop you're administering. 

    $ ./train deploy PATH/TO/YOUR_POSTPREP.rc

This file will be copied via parallel-ssh to all of the VMs and executed.


### Stop and destroy VMs

    $ ./train kill YOUR_TAG
