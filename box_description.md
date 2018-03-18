v7.0.0 (1.5GB)
- First version with Virtualbox **and** VMWare providers!
- Built on Xenial Xerus (Ubuntu 16.04)

v6.0.0 (1.5GB)
- Upgrade to Ubuntu Xenial (v16.04) 
- Updated `install_rust`
- Removed `install_desktop` from `functions.sh`

v5.0.0 (1.36GB)
- Massive update of functions and scripts
- More modular, more better
- Install less by default
- F# support
- OCaml/ReasonML support

v4.1.2 (1.5GB)
- Fix oh-my-zsh issue

v4.1.1 (1.5GB)
- Added `install_rlwrap` function
- Added `profiles.clj` file for clojure user configuration

v4.1.0 (1.53GB)
**Clojure(script) Support**
- Add `install_clojure` script, which includes `install_lein` script
- Add `install_planck` script ([planck](http://planck-repl.org/) is a clojure REPL)
- Add [lumo](https://github.com/anmonteiro/lumo) npm global module (lumo is a clojure REPL)
- [Install *some* Clojure(script) Atom packages](https://gist.github.com/jhwohlgemuth/45fcb219bce777777c809158d25f4d90#install-these-packages)

v4.0.0 (1.5GB)
- First version using vagrant-cloud post-processor
- Refactored Atom BDD snippets to use ES6 arrow functions
- Removed `npx` from installed node modules (included with current version of npm)
- Added [`atom-quokka` plugin](https://medium.com/@artem.govorov/quokka-live-javascript-scratchpad-for-atom-editor-a4edd27b7d91)

v3.0.0 (1.44GB)
- Removed `setup_npm_proxy` function
- Replaced sinopia with verdaccio (a maintained fork)
- **more** awesome node modules

v2.0.0 (1.38GB)
- First version with jhwohlgemuth default naming
- Increases disk size --> 200GB
- Added more functions, atom plugins and node modules

v1.0.4 (1.37GB)
- Removed Java 8 from default build (script still exists in `functions.sh`)
- Removed `local-npm` from installed global node modules
- Added some functions and aliases

v1.0.3 (1.73GB)
- Bumped version of Ubuntu (next patch version)
- Changed default setting for accelerate3d to "off"
- Added "rf" alias and "clean" function
- Added LESS and JS snippets to snippets.cson
- Removed some node modules

v1.0.2 (1.68GB)
- Removed Julia language from default build (script still exists in `functions.sh`)
- Added and removed various global node modules

v1.0.1 (1.72GB)
Added:
- handy docker command aliases
- Ruby version manager (rvm)
- **more** awesome node modules
- **more** awesome Atom plugins
- improved setup script and function library

Visit the [techtonic-env GitHub repo](https://github.com/jhwohlgemuth/techtonic-env)

v1.0.0 (1.64GB)
Minimal desktop development environment built on Ubuntu 14.04 (x64)

Installed Software:
- Firefox and Chromium
- Unity and GNOME session fallback desktop environments
- Python, Node.js, and Julia languages
- iPython, iJavascript and iJulia kernels
- Atom IDE with the best plugins
- Java 8 JRE & JDK
- Docker

Includes scripts to easily install more software, configure SSH and more.

See the [techtonic-env GitHub repo](https://github.com/jhwohlgemuth/techtonic-env) for more details.
