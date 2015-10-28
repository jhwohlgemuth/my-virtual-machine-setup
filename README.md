<div align="center">
    <a href="http://jhwohlgemuth.github.com/techtonic"><img src="http://images.jhwohlgemuth.com/original/logo/tech/techtonic.png?v=1" alt="techtonic"/></a>
</div>

Techtonic `Env`ironment
=====================
> Create development **env**ironments like a pro with Vagrant, VirtualBox, Packer, and Node

Requirements
------------
- [Node.js](https://nodejs.org/) is installed
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/) is installed
- [Packer](https://packer.io/) is installed

Quick Start
-----------
> **Note**: Internet connection is required

- Open up a command prompt (or [Git bash](https://git-scm.com/downloads))
- Create and enter a new directory:
```
mkdir path/to/dev/dir && cd path/to/dev/dir
```
- Initialize a Vagrantfile and start your VM:
```
vagrant init techtonic/env && vagrant up`
```
- After the VM is started, you can find useful files in the `~/.techtonic` directory

> For my personal setup, I run `bash ~/.techtonic/setup.sh`

Create Your Own Vagrant Box with Packer
---------------------------------------
> under construction

Tools, References & Resources
-----------------------------
- See wiki page, [Front-end Link Library](https://github.com/jhwohlgemuth/techtonic/wiki/Front-end-Link-Library)
