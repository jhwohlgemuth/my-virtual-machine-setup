**Terminal Aliases**
- `rf <dir>` - `rm -frd <dir>`
- `clean <dir>` - Empty `<dir>` and enter it
- `dip <container name>` - Returns IP adress of container
- `docker_rm_all` - Stop and remove all containers

**Bash Functions** ([`functions.sh`](functions.sh)):
- `install_atom`
- `install_cairo`
- `install_couch`
- `install_desktop`
- `install_docker`
- `install_java8`
- `install_jenkins`
- `install_julia`
- `install_mesa`
- `install_mongodb`
- `install_pandoc`
- `install_python`
- `install_redis`
- `log`
- `setup_github_ssh`
- `setup_npm_proxy`
- `update`

**Set-up Script** ([`setup.sh`](setup.sh)):
- installs and configures [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) (*with a couple custom docker aliases*)
- turns on workspaces
- turns off screen lock
- installs the [latest and greatest node modules](https://github.com/jhwohlgemuth/techtonic/wiki/Node-Modules-You-Should-Be-Using)
