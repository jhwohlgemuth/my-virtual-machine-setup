**Terminal Aliases & Functions**
--------------------------------
- `rf <dir>` - `rm -frd <dir>`
- `clean <dir>` - Empty `<dir>` and enter it
- `set_git_user <User Name>` - `git config --global user.name <User Name>`
- `set_git_email <email>` - `git config --global user.email <email>`
- `dip <container name>` - Returns IP address of container
- `docker_rm_all` - Stop and remove all containers

**Bash Functions** ([`functions.sh`](functions.sh))
---------------------------------------------------
- `install_couch`
- `install_docker_compose`
- `install_dotnet`
- `install_jenkins`
- `install_mongodb`
- `install_nix`
- `install_nvm`
- `install_python`
- `install_R`
- `install_redis`
- `install_rust`
- `log`

**Vagrant box setup** ([`scripts/setup.sh`](setup.sh))
-----------------
> For use with [jhwohlgemuth/env Vagrant box](https://app.vagrantup.com/jhwohlgemuth/boxes/env)

- Turns on workspaces
- Turns off screen lock
- Installs and configures [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) (*with a couple custom docker aliases*)
- Installs Node and Ruby
- Installs the [latest and greatest node modules](https://github.com/omahajs/omahajs.github.io/wiki/Notable-Node-Modules)
