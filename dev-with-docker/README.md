Development with Docker Containers
==================================
> Now is the time to leverage Docker to seamlessly employ Windows and Linux in your development environment!


Requirements
------------
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

Quick Start  
-----------
> ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/jhwohlgemuth/env?style=for-the-badge)
1. Open Windows Terminal

> Ideally, you have already configured your Windows Terminal according to the [development with Windows Terminal](../dev-with-windows-terminal) instructions

2. Start new shell inside a docker container (I like to name mine "dev")

```bash
docker run -it --name dev jhwohlgemuth/env
```

Build Your Own
--------------
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
> Now that you have an awesome Docker container for development, you need to connect to it with [VSCode]() using the modern and maintained [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)!

Requirements
------------
- [Docker Desktop](https://www.docker.com/products/docker-desktop) (obviously...)
- VS Code [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

Quick Start
-----------
1. Open Windows Terminal and create a Docker container (I like to call mine "dev"):

```bash
docker run -dit --name dev jhwohlgemuth/env
```

> Instead of creating a new container, you *could* use the container you created up in the "Quick Start" section

2. Within VS Code, open the Command Pallete with <kbd>CTRL</kbd>+<kbd>SHIFT</kbd>+<kbd>P</kbd> and type `Remote-Containers: Attach to Running Container...`, press <kbd>ENTER</kbd>

3. In the dropdown, select the container you started in step 1 (or from "Quick Start" section)

4. After VS Code reloads, open a folder on your container using the "Explorer" panel (toggle explorer panel with <kbd>CTRL</kbd>+<kbd>\\</kbd>)

5. Smile. You are developing inside Linux with VS Code running on Windows. Maybe check out the [VS Code docs](https://code.visualstudio.com/docs).

Tips
====
- Copy this directory's [`Makefile`](./Makefile) into your Windows user home directory for easy access. This enables you to quickly open a shell in your container by opening Windows Terminal and executing `make` and `make shell` (if you have not created the `dev` container) or `make start` and `make shell` (after you have created the `dev` container)

> **Note:** If you skipped the [development with Windows Terminal](../dev-with-windows-terminal) instructions, you can install `make` on Windows with [Chocolatey](https://chocolatey.org/install) via `choco install make`