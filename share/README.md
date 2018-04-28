**Terminal Aliases & Functions**
--------------------------------
- `rf <dir>` - `rm -frd <dir>`
- `clean <dir>` - Empty `<dir>` and enter it
- `set_git_user <User Name>` - `git config --global user.name <User Name>`
- `set_git_email <email>` - `git config --global user.email <email>`
- `dip <container name>` - Returns IP adress of container
- `docker_rm_all` - Stop and remove all containers

**Bash Functions** ([`functions.sh`](functions.sh))
-----------------
- `create_cached_repo`
- `customize_ohmyzsh`
- `fix_enospc_issue`
- `install_atom`
- `install_cairo`
- `install_clojure`
- `install_couch`
- `install_desktop`
- `install_docker`
- `install_fsharp`
- `install_heroku`
- `install_ionide`
- `install_java8`
- `install_jenkins`
- `install_julia`
- `install_lein`
- `install_mesa`
- `install_mongodb`
- `install_mono`
- `install_ohmyzsh`
- `install_opam`
- `install_popular_atom_plugins`
- `install_popular_node_modules`
- `install_powerline_font`
- `install_nvm`
- `install_pandoc`
- `install_planck`
- `install_python`
- `install_R`
- `install_reason`
- `install_redis`
- `install_rlwrap`
- `install_rust`
- `install_rvm`
- `install_sdkman`
- `install_vscode`
- `install_vscode_extensions`
- `log`
- `prevent_root`
- `prevent_user`
- `setup_github_ssh`
- `setup_npm_proxy`
- `turn_off_screen_lock`
- `turn_on_workspaces`
- `update`

**Vagrant box setup** ([`share/setup.sh`](setup.sh))
-----------------
> For use with [jhwohlgemuth/env Vagrant box](https://app.vagrantup.com/jhwohlgemuth/boxes/env)

- Turns on workspaces
- Turns off screen lock
- Installs and configures [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) (*with a couple custom docker aliases*)
- Installs Node and Ruby
- Installs the [latest and greatest node modules](https://github.com/omahajs/omahajs.github.io/wiki/Notable-Node-Modules)

**Bare metal setup**
--------------------
> For use with clean Ubuntu (v14) install

    export ORG_NAME=<optional folder name for files>
    export SSH_PASSWORD=<your password>
    git clone https://github.com/jhwohlgemuth/env.git
    cd env/share
    sudo sh install_bare_metal_root.sh
    sh install_bare_metal.sh
