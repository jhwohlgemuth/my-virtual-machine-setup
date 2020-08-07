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
- `customize_ohmyzsh`
- `customize_run_commands`
- `install_couch`
- `install_docker`
- `install_docker_compose`
- `install_dotnet`
- `install_firacode`
- `install_jenkins`
- `install_mongodb`
- `install_nix`
- `install_nix_packages`
- `install_node_modules`
- `install_nvm`
- `install_ohmyzsh`
- `install_ohmyzsh_plugins`
- `install_powerline_font`
- `install_python`
- `install_R`
- `install_redis`
- `install_rust`
- `install_rust_crates`
- `install_rvm`
- `install_vscode`
- `install_vscode_extensions`
- `log`
- `prevent_root`
- `prevent_user`
- `setup`
- `setup_dependencies`
- `setup_github_ssh`
- `setup_npm_proxy`
- `update`

**Vagrant box setup** ([`share/setup.sh`](setup.sh))
-----------------
> For use with [jhwohlgemuth/env Vagrant box](https://app.vagrantup.com/jhwohlgemuth/boxes/env)

- Turns on workspaces
- Turns off screen lock
- Installs and configures [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) (*with a couple custom docker aliases*)
- Installs Node and Ruby
- Installs the [latest and greatest node modules](https://github.com/omahajs/omahajs.github.io/wiki/Notable-Node-Modules)
