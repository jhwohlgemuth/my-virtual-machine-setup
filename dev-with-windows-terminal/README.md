Development with Windows Terminal
=================================

Requirements
------------
- [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701)

Quick Start
-----------
1. Open a Powershell terminal in a location, `C:/path/to/folder`, where you can save some files

> While holding <kbd>shift</kbd>, right-click `C:/path/to/folder` directory and select "Open PowerShell window here"

2. Clone this repository and navigate to `dev-with-windows-terminal` directory:

```bash
git clone https://github.com/jhwohlgemuth/env
cd env/dev-with-windows-terminal
```

3. Install PowerShell modules and Chocolatey packages:
> You are encouraged to read the content of [install.ps1](./install.ps1)

```powershell
./install.ps1
```

4. Copy content of [Microsoft.Powershell_profile.ps1](./Microsoft.Powershell_profile.ps1) into Windows Terminal settings:

```powershell
Set-Content -Path $PROFILE -Value (Get-Content -Path .\Microsoft.Powershell_profile.ps1)
```

5. Open the Windows terminal `settings.json` file by pressing <kbd>CTRL</kbd>+<kbd>,</kbd> and replace contents with content of [settings.json](./settings.json) from this repository

> Enjoy your awesome new ***Windows*** terminal. `#cantBelieveItsNotLinux`

What Next?!
===========
Now that you have an amazing terminal, [give Docker a try!](../dev-with-docker)