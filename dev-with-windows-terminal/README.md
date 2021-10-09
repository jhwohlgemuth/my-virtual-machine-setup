Development with Windows Terminal
=================================
> `#cantBelieveItsNotLinux`

<div align="center">
    <a href="#"><img alt="Windows Terminal in action!" src="http://www.jasonwohlgemuth.com/env/images/env_terminal_demo.gif" alt="So pretty!" width="1280"/></a>
</div>

Requirements
------------
- [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701)

Quick Start
-----------
1. Open a Powershell terminal in a location, `C:/path/to/folder`, where you can save some files

> While holding <kbd>shift</kbd>, right-click `C:/path/to/folder` directory and select "Open PowerShell window here"

2. Clone this repository:

```bash
git clone https://github.com/jhwohlgemuth/env
```

3. Navigate to the `dev-with-windows-terminal` directory:

```bash
cd /path/to/env/dev-with-windows-terminal
```

4. Run installation PowerShell script <sup>[[1]](#1)</sup>:
> You are encouraged to read the content of [Invoke-Install.ps1](./Invoke-Install.ps1). You can access the script's help with `./Invoke-Install.ps1 -Help`

**Install applications with [Chocolatey](https://chocolatey.org/)**:
```powershell
./Invoke-Install.ps1
```

**Install applications with [Scoop](https://scoop.sh/)**:
```powershell
./Invoke-Install.ps1 -PackageManager scoop
```

> Not sure which package manager to use? [Here is a comparison](https://github.com/lukesampson/scoop/wiki/Chocolatey-Comparison) provided by the maker of Scoop.

5. Copy content of [Microsoft.Powershell_profile.ps1](./Microsoft.Powershell_profile.ps1) into Windows Terminal profile:

```powershell
Set-Content -Path $PROFILE -Value (Get-Content -Path .\Microsoft.Powershell_profile.ps1)
```

6. Copy content of [settings.json](./settings.json) into Windows Terminal settings:


```powershell
Set-Content -Path "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Value (Get-Content -Path .\settings.json)
```

> **Note**: You can open the Windows terminal `settings.json` file manually by pressing <kbd>CTRL</kbd>+<kbd>,</kbd>

What Next?!
===========
Now that you have an amazing terminal, [install Neovim](../dev-with-neovim), and/or [give Docker a try!](../dev-with-docker)

-------------

**Footnotes**
-------------

[1]
---
> Depending on your system configuration, you may experience issues trying to execute [Invoke-Install.ps1](./Invoke-Install.ps1).
> For execution policy problems, you can bypass the policy one time with

```
Set-ExecutionPolicy Bypass -Scope Process -Force; ./Invoke-Install.ps1
```