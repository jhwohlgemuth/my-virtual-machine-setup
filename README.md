<div align="center">
    <a href="http://jhwohlgemuth.github.com/techtonic"><img src="http://images.jhwohlgemuth.com/original/logo/tech/techtonic.png?v=1" alt="techtonic"/></a>
</div>

Environment
===========
> Create development **env**ironments quickly and easily with Vagrant VirtualBox, Packer and Node

Requirements
------------
- [Node.js](https://nodejs.org/) is installed
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) is installed
- [Vagrant](https://www.vagrantup.com/) is installed
- [Packer](https://packer.io/) is installed

Quick Start
-----------
- Open up a command prompt (or [Git bash](https://git-scm.com/downloads))
- Create a new directory with `mkdir dev`
- Enter the new directory with `cd dev`
- Initialize a Vagrantfile with `vagrant init techtonic/env`
- Start the VM with `vagrant up`
- After the VM is started, you can find useful files in the `~/.techtonic` directory (for my personal setup, I run `bash ~/.techtonic/setup.sh`)

`~/.techtonic/setup.sh`:
- customize your terminal with [oh my zsh](http://ohmyz.sh/) and the [agnoster](https://gist.github.com/agnoster/3712874) theme
- install node using nvm
- install useful global node modules
- install and configure the npm proxy, [sinopia](https://github.com/rlidwka/sinopia)

`~/.techtonic/functions.sh`:
- Source with `sudo -s && . ~/.techtonic/functions.sh`
- See the [read me](./share/README.md) and [functions.sh](./share/functions.sh) for more details on the available functions.

Create Your Own Vagrant Box with Packer
---------------------------------------
> under construction

Tools, References & Resources
-----------------------------
- See wiki page, [Front-end Link Library](https://github.com/jhwohlgemuth/techtonic/wiki/Front-end-Link-Library)
