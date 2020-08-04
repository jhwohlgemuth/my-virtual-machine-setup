env
===

> Create development **env**ironments like a pro with Packer, Powershell, Vagrant, & Docker

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

 - [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) is an [open source](https://github.com/microsoft/terminal) terminal for the modern developer. Combined with Powershell, anyone can easily enjoy a comfortable and truly robust developer experience on Windows.

> Vagrant, Packer, and Docker are tools that facilitate applying
[SOLID](https://scotch.io/bar-talk/s-o-l-i-d-the-first-five-principles-of-object-oriented-design),
[WORA](https://en.wikipedia.org/wiki/Write_once,_run_anywhere),
[PoLA](https://en.wikipedia.org/wiki/Principle_of_least_astonishment),
[YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it),
[DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
practices to the code that you write,
_and the environments in which the code is written and used_ (spoken:  _" infrastructure and stuff "_).

Why?
----
> This project codifies how I manage my development environment across Windows, Linux, and OSX.

Quickstart
----------

- [Easily manage a development virtual machine with Vagrant](dev-box/README.md)
- [Quickly create a development container with Docker](dev-container/README.md)
- [Customize your Windows Terminal and Powershell](dev-terminal/README.md)

Future
------
- See [env Trello board](https://trello.com/b/WEMB9CEL/env)
