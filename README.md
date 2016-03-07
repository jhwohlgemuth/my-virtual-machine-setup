<div align="center">
    <a href="http://jhwohlgemuth.github.com/techtonic"><img src="http://images.jhwohlgemuth.com/techtonic/logo.png?v=1" alt="techtonic"/></a>
</div>

> Create development **env**ironments like a pro with Packer, Vagrant, & Docker

What?
-----
- [Vagrant](https://www.vagrantup.com/) is a high-level wrapper API for kernel-based virtual machines (KVM).
Vagrant uses packaged environments called [boxes](https://docs.vagrantup.com/v2/boxes.html)
and allows one to manage, configure, and control virtual environments with code and automation.

- [Packer](https://packer.io/) enables one to _create Vagrant boxes_
(and [other things](https://packer.io/docs/builders/docker.html))
via an automated and repeatable process driven by a single [JSON-formatted template file](./packer.json).

- [Docker](https://www.docker.com/) is to [LXC](https://stackoverflow.com/questions/16047306/how-is-docker-different-from-a-normal-virtual-machine)
 as Vagrant is to [KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)

> Vagrant, Packer, and Docker are tools that facilitate applying
[SOLID](https://scotch.io/bar-talk/s-o-l-i-d-the-first-five-principles-of-object-oriented-design),
[WORA](https://en.wikipedia.org/wiki/Write_once,_run_anywhere),
[PoLA](https://en.wikipedia.org/wiki/Principle_of_least_astonishment),
[YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it),
[DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
practices to the code that you write,
_and the environments in which the code is written and used_ (spoken:  _" infrastructure and stuff "_).

Requirements
------------
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/downloads.html) is installed

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

Customize the` techtonic/env` VM
--------------------------------
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

- Clone this repo with `git clone https://github.com/jhwohlgemuth/techtonic-env.git`
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
- [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/jhwohlgemuth/techtonic?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
- See the [techtonic wiki](https://github.com/jhwohlgemuth/techtonic/wiki)

Future
------
- See [techtonic Trello board](https://trello.com/b/WEMB9CEL/techtonic)
