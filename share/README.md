**Terminal Aliases & Functions**
- `rf <dir>` - `rm -frd <dir>`
- `clean <dir>` - Empty `<dir>` and enter it
- `set_git_user <User Name>` - `git config --global user.name <User Name>`
- `set_git_email <email>` - `git config --global user.email <email>`
- `dip <container name>` - Returns IP adress of container
- `docker_rm_all` - Stop and remove all containers

**Bash Functions** ([`functions.sh`](functions.sh)):
- `install_atom`
- `install_cairo`
- `install_clojure`
- `install_couch`
- `install_desktop`
- `install_docker`
- `install_heroku`
- `install_java8`
- `install_jenkins`
- `install_julia`
- `install_lein`
- `install_mesa`
- `install_mongodb`
- `install_pandoc`
- `install_planck`
- `install_python`
- `install_R`
- `install_redis`
- `install_rlwrap`
- `log`
- `setup_github_ssh`
- `setup_npm_proxy`
- `update`

**Set-up Script** ([`setup.sh`](setup.sh)):
- installs and configures [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) (*with a couple custom docker aliases*)
- turns on workspaces
- turns off screen lock
- installs the [latest and greatest node modules](https://github.com/omahajs/omahajs.github.io/wiki/Notable-Node-Modules)
