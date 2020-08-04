Vagrant Development Box
=======================

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

- [`~/.jhwohlgemuth/setup.sh`](./share/setup.sh) is a collection of tweaks and customizations.

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