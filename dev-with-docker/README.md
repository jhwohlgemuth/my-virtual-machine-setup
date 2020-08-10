Development with Docker Containers
==================================
> Now is the time to leverage Docker to seamlessly employ Windows and Linux in your development environment!

Requirements
------------
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

Quick Start
-----------
1. Open Windows Terminal

2. Start new shell inside a docker container

```bash
docker run -it jhwohlgemuth/env
```

Less Quick Start
----------------
> ***5 Simple Steps™*** — no Docker know-how required
1. Open a Powershell terminal in a location, `C:/path/to/folder`, where you can save some files

> While holding <kbd>shift</kbd>, right-click `C:/path/to/folder` directory and select "Open PowerShell window here"

2. Clone this repository and navigate to `dev-with-docker` directory:

```bash
git clone https://github.com/jhwohlgemuth/env
cd env/dev-with-docker
```

3. Build docker image and "dev" container with `make` command (this command also starts container in background)

4. From within Windows Terminal, open a shell to the container with `make shell`

5. Enjoy your awesome new terminal in a ***Windows*** terminal. `#cantBelieveItsNotLinux`...although in this case, it is also Linux...in Windows

What Next?!
===========
Now that you have an awesome Docker container for development, you need to connect to it with [VSCode]() using the modern and maintained [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)!