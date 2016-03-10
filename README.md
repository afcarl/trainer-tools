# Trainer tools for Docker workshops

## TL;DR

Summary of steps to launch a batch of instances for a workshop:

* `source AWS_ECS_CREDENTIALS` to export the environment variables needed by the AWS CLI
* `trainer start NUMBER_OF_VMS` to create AWS instances
* `trainer deploy TAG` to run `scripts/postprep.rc` via parallel-ssh
* `trainer pull-images TAG` to pre-pull a bunch of Docker images 
* `trainer cards TAG` to generate an HTML file you can print to PDF

## Getting started

Clone this repo to your machine:

  `git clone https://github.com/soulshake/trainer-tools.git`


### Requirements

Required environment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_DEFAULT_REGION`

Currently, it is not possible to specify a custom tag.

## Usage

Tip: You can create a symlink in your path for this script:

  ln -s $PWD/trainer $HOME/bin/trainer

### Create a new workshop

  trainer create-workshop WORKSHOP_NAME

Replace `WORKSHOP_NAME` with a simple, unique nickname for this workshop (no spaces, and should not start with a digit).

This will copy the template directory.

### Activate a workshop

  trainer activate WORKSHOP_NAME

This will symlink workshops/WORKSHOP_NAME/settings.txt to the base directory, where `trainer` will source it.
Not fully implemented.

### Start some VMs

    $ trainer start 10

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

## Set up a new workshop

Create a subdirectory in workshops/ with a simple identifier for your workshop.
From that directory, run:

    $ git submodule add <url_of_your_repo>

Run:
    $ scripts/scrape-slides.py PATH_TO_YOUR_SLIDES_INDEX.HTML

## To do

### Optional environment variables:

* `AWS_INSTANCE_TYPE` (current behavior: `m3.large`)
* `WORKSHOP_TAG` (current behavior: tag generated with your username and today's date)

### Symlink support

Allow running a symlink to ./trainer from any working directory.

### Custom deployment behavior

Allow configuration of the VMs based on the workshop you're administering. 

Current behavior: defaults to postprep.rc

### settings

Use JSON instead of shell
