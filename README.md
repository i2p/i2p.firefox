I2P Easy-Install Bundle for Windows(Also/formerly)I2P Browsing Profile for Firefox
==================================================================================

Features:
---------

- Automatically select an up-to-date, secure browser from the host platform, with Tor Browser and Firefox preferred.
- Automatically configure a profile for I2P
- Automatically block-list all non-I2P local destinations
- Enable first-party isolation, anti-fingerprinting, letterboxing, fusion, other privacy and security options
- Automatically sandbox I2P, Non-I2P, and I2P-Application cookiestores

Build Dependencies:
-------------------

To build this, you will need the following software packages
(all available in Debian and Ubuntu, see WSL section below):

- make
- nsis
- dos2unix
- curl
- jq

These need to be installed in the environment where the NSIS
Package is build, NOT the environment where the java package
is built. These may be different, because you will need to
use a system which provides a Unix-like environment on top of
a Windows system. You can use WSL or Cygwin, and more detailed
instructions are provided below.

Building for Windows target from Linux is not possible unless
you obtain a Windows package from my github.

In addition, you will need the NSIS plugin "ShellExecAsUser" which you can get from the
[NSIS Wiki Page](https://nsis.sourceforge.io/ShellExecAsUser_plug-in). In order to install
the plugin on Debian, Ubuntu, or using `WSL`, you can download the: [7zip release](https://nsis.sourceforge.io/mediawiki/images/6/68/ShellExecAsUser_amd64-Unicode.7z)
and copy the content of `Plugins` to `/usr/share/nsis/Plugins`.

```sh
cp -rv Plugins/* /usr/share/nsis/Plugins/
```

Including a jpackaged I2P Router
--------------------------------

**Prerequisites:** You need to have OpenJDK 14 or greater installed and configured
with your `%JAVA_HOME%` environment variable configured and `%JAVA_HOME%/bin` on
your `%PATH%`. You need to have Apache Ant installed and configured with `%ANT_HOME%`
environment variable configured and `%ANT_HOME%/bin` on your `%PATH%`. You must have
Cygwin installed. You must have `NSIS.exe` installed and `makensis` available on your
`%PATH%`. You must have Git for Windows installed. When installing git for Windows,
you should select "Checkout as is, commit as is" and leave line-endings alone.

The Windows build tools listed above must be installed on the Windows host machine.

TODO: Add links to the respective instructions for each of these.

**Note that after the dependencies are installed, this step is automated**
**with `./buildscripts/build.sh`.**

In order to include a jpackaged(dependency-free) I2P router in the Profile
Bundle you will need to build the jpackaged I2P router as an "App Image" on
a Windows system and place it into a directory called `I2P` in your `i2p.firefox`
checkout. Building without a jpackage is no longer supported.

Assuming a working java and jpackage environment on your Windows system, the
following command should generate a suitable "App Image" in a directory
called "I2P."

        export I2P_VERSION=0.9.49
        cp -R ../i2p.i2p/pkg-temp/lib build/lib
        jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
          --verbose \
          --resource-dir build/lib \
          --input build/lib --main-jar router.jar --main-class net.i2p.router.RouterLaunch

Transfer the I2P directory to the machine where you build i2p.firefox if
necessary, then complete the regular build instructions. If a jpackaged I2P router
isn't present to use at build time, the inclusion will be skipped automatically
with a non-fatal warning.

Pre-built app-images are available from my daily releases at:

        https://github.com/eyedeekay/i2p.plugins.firefox/releases/

Windows Build
-------------

After installing the dependencies and completing the preparations,
just run `make`.  This will produce the install.exe - the windows
installer, which sets up the shortcuts to launch Firefox on Windows.
Building without a jpackage is no longer supported.

When generating a build it's important to make sure that the
licenses for all the bundled softare are included. This should happen
automatically. When bundling software, describe the terms and where
they are applied in the `LICENSE.index`, then add the full license
to the `licenses` directory. Then, add the full license to the `cat`
command in the `build/licenses` make target. The build/licenses
target is run automatically during the build process.

End-to-End Windows build process using WSL(**Recommended**)
-----------------------------------------------------------

**See `config.sh` and `i2pversion` for instructions on how to tweak**
**the build process. File an issue if you need help.**

**If you've already done this once, you can just use:** `./unsigned.sh`
**in `git bash`** to automatically build an installer. If you
are using this method, you may use the `makensis` and `make` from
Ubuntu in WSL.

 1. [Set up Windows Subsystem for Linux per Microsoft's instructions](https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps)
 2. [Install Ubuntu Focal per Microsoft's instructions](https://www.microsoft.com/store/apps/9n6svws3rx71)
 3. Open Git Bash.
 4. Install prerequisites `wsl sudo apt-get update && sudo apt-get install make nsis nsis-pluginapi dos2unix curl jq`
 5. Clone `i2p.i2p` and `i2p.firefox`

        git clone https://github.com/i2p/i2p.i2p
        git clone https://github.com/i2p/i2p.firefox

 6. Move to the i2p.i2p directory. Build the .jar files required to build the App Image
  inside i2p.i2p. Return to home.

        cd i2p.i2p
        ant clean pkg
        cd ..

 7. Move into the i2p.firefox directory. Run the `./buildscripts/build.sh` script.

        cd i2p.firefox
        ./buildscripts/build.sh

 8. Compile the NSIS installer using WSL.

        wsl make

End-to-End Windows build process using Cygwin(More difficult than WSL for now)
------------------------------------------------------------------------------

I highly recommend you look into the Chocolatey package manager, which makes it much
easier to configure these tools and keep them up to date.

**Prerequisites:** In addition to the other prerequisites, you will need to to have
`make` installed with `cygwin`. If you are using this method, you cannot use the
automated build scripts without a hack. You will need to create a file called `wsl`
in a place that is in the path used by `git-bash.exe` sessions, with the content:

```
#! /usr/bin/env bash
$@
```

For our purposes, as long as everything else is set up and you're using git bash,
that is enough to make the scripts compatible with `cygwin`. Cygwin builds without
git bash are not likely to work.

1. Run the Cygwin `setup-$arch.exe` for your platform to set up new packages. Select the `make` `jq` `dos2unix` and `curl` packages.
2. Open a cygwin terminal.
3. Clone `i2p.i2p` and `i2p.firefox`

        git clone https://github.com/i2p/i2p.i2p
        git clone https://github.com/i2p/i2p.firefox

4. Move to the i2p.i2p directory. Build the .jar files required to build the App Image
  inside i2p.i2p. Return to home.

        cd i2p.i2p
        ant clean pkg
        cd ..

5. Move into the i2p.firefox directory. Run the `./buildscripts/build.sh` script.

        cd i2p.firefox
        ./buildscripts/build.sh

6. Run `make` to build the installer.

Doing a Release
---------------

Once you have the installer `.exe` file produced by NSIS, you're almost ready to
do a release. As a final step, someone must sign the `.exe` file using a
Certificate which Windows will recognize. The current signer of the Windows
bundle is Zlatinb. Standard Windows signing tools are used.

```sh
./release.sh
```

produces the binary.

Building a signed update file
-----------------------------

Building a signed update file for automatically updating a Windows I2P router
requires you to either be using linux, or have Go installed in your Cygwin or WSL environment.
On Linux(Where I sign the su3 files), this works:

        make su3

to run the signing tool if necessary and then package the installer in a
signed update file.

Docker Support
--------------

**MOVED, DEPRECATION NOTICE:** Most of this functionality has been moved
to http://git.idk.i2p/idk/i2p.plugins.firefox which is more stable,
easier to build and use, and easier to incorporate into other
projects.

 - https://git.idk.i2p/idk/i2p.plugins.firefox/-/blob/main/docker.sh

Unix Support
------------

**MOVED. DEPRECATION NOTICE:** Most of this functionality has been moved
to http://git.idk.i2p/idk/i2p.plugins.firefox which is more stable,
easier to build and use, and easier to incorporate into other
projects. It is the better option for nearly every non-Windows case
right now. You can get binary packages from:

 - https://github.com/eyedeekay/i2p.plugins.firefox/releases

or look at

 - https://i2pgit.org/idk/i2p.plugins.firefox/-/blob/master/PACKAGES.md

for instructions on how to build your own packages. These packages are
unofficial! Although I do dogfood most of them and the `.jar` gets thorough
testing.

**The only remotely interesting Unix functionality that remains in this**
**repository is the construction of a portable. You can use `targz.sh` to**
**generate that. Once generated, `cd I2P && ./lib/torbrowser.sh` to complete**
**setup, and `./bin/I2P` to run it.**

Issues
------

To report issues against this browser profile, please file issues
at [the official Gitlab](https://i2pgit.org/i2p-hackers/i2p.firefox)
or the [Github Mirror](https://github.com/i2p/i2p.firefox). Issues
pertaining to the plugins may be reported to their upstream
maintainers if it's determined that our configuration is not at
fault.

## Credits

This profile manager makes use of a set of browser extensions which are largely the work of others.
It makes use of dependencies that are the work of others. In many ways, it's merely an elaborate
configuration tool. A smart one, but a configuration tool nonetheless. Many thanks to the following
projects, developers, and communities:

### Firefox and Chrome Extensions

- [NoScript - Giorgio Maone and others](https://noscript.net)
- [HTTPS Everywhere - Electronic Frontier Foundation](https://www.eff.org/https-everywhere)
- [uBlock Origin - Raymond Gorhill and others](https://ublockorigin.com/)
- [LocalCDN - nobody and others](https://www.localcdn.org/)
- [jShelter - Libor Polčák and others](https://jshelter.org/)

### Firefox Configuration Modifiations

- [Arkenfox - Thorin Oakenpants and Others](https://github.com/arkenfox/user.js/)

You can find the license files for each of the these projects in the `src/i2p.firefox.*.profile/extensions/*`
directory for Firefox, and the `src/i2p.chromium.*.profile/extensions/*.js/*` directories for Chromium within
the [`i2p.plugins.firefox`](https://i2pgit.org/idk/i2p.plugins.firefox) project.

I2P in Private Browsing is developed on Gitlab and Github by idk and the community:
 - https://i2pgit.org/idk/I2P-in-Private-Browsing-Mode-Firefox
 - https://github.com/eyedeekay/I2P-in-Private-Browsing-Mode-Firefox
