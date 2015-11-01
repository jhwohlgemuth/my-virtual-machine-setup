<div align="center">
    <a href="http://jhwohlgemuth.github.com/techtonic"><img src="http://images.jhwohlgemuth.com/original/logo/tech/techtonic.png?v=1" alt="techtonic"/></a>
</div>

> Create development **env**ironments like a pro with Vagrant, VirtualBox, & Packer

Minimum Requirements
--------------------
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/downloads.html) is installed
- [Git for Windows](https://git-scm.com/downloads) is not _required_, but is very useful

> **Warning:** [Linux syntax](http://linuxcommand.org/lc3_lts0060.php) is used in these instructions, use Windows syntax where appropriate.

Quick Start
-----------
> **Warning**: Internet connection is required

- Open up a command prompt (or [Git bash](https://git-scm.com/downloads))
- Create and enter a new directory:
```
mkdir path/to/dev/dir && cd path/to/dev/dir
```
- Initialize a Vagrantfile and start your VM:
```
vagrant init techtonic/env && vagrant up
```

> See the [Vagrant Getting Started guide](https://docs.vagrantup.com/v2/getting-started/index.html) for more information

Customize the` techtonic/env` Box
---------------------------------
The default `techtonic/env` Vagrant box hosted on [Atlas](https://atlas.hashicorp.com/techtonic/boxes/env),
includes the `~/.techtonic` directory that has some useful files.

- [`~/.techtonic/setup.sh`](./share/setup.sh) is a collection of tweaks and customizations.
> **usage:**
```bash
#setup.sh is executable and can be run with just:
~/.techtonic/setup.sh
```

- [`~/.techtonic/functions.sh`](./share/functions.sh) is a collection of functions for installing and configuring software.
> **usage:**
```bash
#The functions require root privileges
sudo -s
#Source the functions
. ~/.techtonic/functions.sh
#Run a function like install_docker, install_jenkins, or install_redis
```

Create Your Own Vagrant Box with Packer
---------------------------------------
> **Warning**: Internet connection is required

> **Warning**: This sections requires that [Packer](https://packer.io/downloads.html) is installed

> **Warning**: An [Atlas token](https://atlas.hashicorp.com/tutorial/packer-vagrant/0) is not required for box creation, but not having one set will cause the `atlas` post-provisioner to fail.

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

Tools, References & Resources
-----------------------------
- See the [techtonic wiki](https://github.com/jhwohlgemuth/techtonic/wiki)

Future
------
- See [techtonic Trello board](https://trello.com/b/WEMB9CEL/techtonic)
