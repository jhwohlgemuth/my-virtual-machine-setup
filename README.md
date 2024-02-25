My Virtual Machine Setup &nbsp;
[![CodeFactor](https://www.codefactor.io/repository/github/jhwohlgemuth/my-virtual-machine-setup/badge)](https://www.codefactor.io/repository/github/jhwohlgemuth/my-virtual-machine-setup)
===

> Create development **env**ironments with Vagrant & Packer

> [!CAUTION]
> This project is not actively maintained and may or may not actively function as described. You will find my current shell setup [here](https://github.com/jhwohlgemuth/my-shell-setup) and my current dev environment (using containers) [here](https://github.com/jhwohlgemuth/gold) 🤓

What?
-----

- [Vagrant](https://www.vagrantup.com/) is a high-level wrapper API for kernel-based virtual machines (KVM).
Vagrant uses packaged environments called [boxes](https://docs.vagrantup.com/v2/boxes.html)
and allows one to manage, configure, and control virtual environments with code and automation.

- [Packer](https://packer.io/) enables one to _create Vagrant boxes_
(and [other things](https://packer.io/docs/builders/docker.html))
via an automated and repeatable process driven by a single [JSON-formatted template file](./packer.focal.json).

Requirements
------------
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/downloads.html) is installed
- [Packer](https://packer.io/) is installed

Quick Start
-----------
> **Warning**: Internet connection is required

- Open up a command prompt (or [Git bash](https://git-scm.com/downloads))
- Create and enter a new directory:
```
mkdir path/to/dev/dir && cd path/to/dev/dir
```
- Initialize a Vagrantfile and start your Vagrant box:
```
vagrant init jhwohlgemuth/env && vagrant up
```

> See the [Vagrant Getting Started guide](https://docs.vagrantup.com/v2/getting-started/index.html) for more information

Customize the Vagrant Box
--------------------------------
The default `jhwohlgemuth/env` Vagrant box hosted on [Atlas](https://atlas.hashicorp.com/jhwohlgemuth/boxes/env),
includes the `~/.jhwohlgemuth` directory that has some useful files.

- [`~/.jhwohlgemuth/setup.sh`](./scripts/setup.sh) is a collection of tweaks and customizations.

> **usage:**
```bash
#setup.sh is executable and can be run with just:
~/.jhwohlgemuth/setup.sh
```

- [`~/.jhwohlgemuth/functions.sh`](./share/functions.sh) is a collection of functions for installing and configuring software.

> **usage:**
```bash
#Most functions require root privileges
sudo -s
#Functions are sourced when terminal is opened
#Type 'install_' followed by tab to see the available install functions
#Type 'setup_' followed by tab to see the available setup functions
```

Create Your Own Vagrant Box with Packer
---------------------------------------
> **Warning**: Internet connection is required

> **Warning**: This sections requires that [Packer](https://packer.io/downloads.html) is installed

> **Warning**: An [Atlas token](https://atlas.hashicorp.com/tutorial/packer-vagrant/0) is not required for box creation, but not having one set will cause the `atlas` post-provisioner to fail.

- Clone this repo with `git clone https://github.com/jhwohlgemuth/env.git`
- [Customize](https://packer.io/docs/templates/introduction.html) [`packer.json`](./packer.json) and the [provisioning scripts](./scripts) to your liking
- Open up a [Git bash](https://git-scm.com/downloads) in the root directory:
```bash
#Set token for connecting to Atlas
export ATLAS_TOKEN=<your secret token>
#Validate Packer template and fix errors if applicable
packer validate packer.json
#Start the build process. Go get a coffee.
packer build packer.json
```

> See the official [Packer Introduction](https://www.packer.io/intro) for more information
