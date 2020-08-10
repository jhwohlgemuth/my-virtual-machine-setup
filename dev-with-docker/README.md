Development with Docker Container
=================================
> **Under construction**

Requirements
------------
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

Quick Start
-----------
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