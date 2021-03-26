I2P Browsing Profile for Firefox
================================

Features:
---------

 - Automatically select an up-to-date, secure Firefox or Tor Browser(On Windows) variant
 - Automatically configure a profile for I2P
 - Automatically block-list all non-I2P local destinations
 - Enable first-party isolation, anti-fingerprinting, letterboxing
 - Automatically sandbox I2P, Non-I2P, and I2P-Application cookiestores

Build Dependencies:
-------------------

To build this, you will need the following software packages (all available in Debian) :

 * make
 * nsis
 * dos2unix
 * curl
 * jq

to build a Debian package, you'll also need

 * checkinstall

Preparation
-----------

Before you build, run the targets


        make clean-extensions
        make extensions

to update the extensions to point to their latest versions.

Windows Build
-------------

After installing the dependencies and completing the preparations,
just run `make`.  This will produce three files:

profile.tgz - the firefox profile, plus a shell script which will
launch it if Firefox is found in the $PATH on Unix-Like operating
systems.
app-profile.tgz - the Firefox profile plus a launcher shell script,
which will launch a *modified* Firefox without a URL bar as a router
console wrapper.
install.exe - the windows installer, which sets up shortcuts to
launch Firefox on Windows.

Unix Support
------------

It is possible to use these profiles on Linux and possibly other
Unixes, if Firefox is already installed on the system. It can be
installed system-wide using the `make install` target. Running
`make install` requires root, and requires `make` to have been run
first. To install on Unix, system-wide, run:

        make
        sudo make install

To run without installing them system wide, unpack the `profile*.tgz`
to a location of your choice and run the `i2pbrowser.sh` script. This
will start a Firefox profile configured to use I2P.

        tar xvf profile-0.3.tgz
        cd profile
        ./i2pbrowser.sh

If you want to run the app-like i2pconfig browser, then follow the
same steps with app-profile*.tgz.

        tar xvf app-profile-0.3.tgz
        cd app-profile
        ./i2pconfig.sh

To generate a `deb` package, install the package `checkinstall` and run
the `make checkinstall` target after building with `make`.

        make
        make checkinstall
        sudo apt install ./i2p-firefox*.deb

If you want to set up i2pconfig to run when you start the service
with `sudo service i2p start` then you can run the script:

        /usr/local/bin/i2p-config-service-setup

Including a jpackaged I2P Router(EXPERIMENTAL)
----------------------------------------------

In order to include a jpackaged(dependency-free) I2P router in the Profile
Bundle you will need to build the jpackaged I2P router as an "App Image" on
a Windows system and place it into a directory called `I2P` in your `i2p.firefox`
checkout.

Assuming a working java and jpackage environment on your Windows system, the
following command should generate a suitable "App Image" in a directory
called "I2P."

        export I2P_VERSION=0.9.49
        cp ../i2p.i2p/pkg-temp build
        jpackage --type app-image --name I2P --app-version "$I2P_VERSION" \
          --verbose \
          --resource-dir build \
          --input build --main-jar router.jar --main-class net.i2p.router.RouterLaunch

Transfer the I2P directory to the machine where you build i2p.firefox if
necessary, then complete the regular build instructions. If a jpackaged I2P router
isn't present to use at build time, the inclusion will be skipped automatically
with a non-fatal warning.

Issues
------

To report issues against this browser profile, please file issues
at [the official Gitlab](https://i2pgit.org/i2p-hackers/i2p.firefox)
or the [Github Mirror](https://github.com/i2p/i2p.firefox). Issues
pertaining to the plugins may be reported to their upstream
maintainers if it's determined that our configuration is not at
fault.

NoScript is developed on Github by `hackademix` and the community:
 - https://github.com/hackademix/noscript

HTTPS Everywhere is developed on Github by the EFF:
 - https://github.com/EFForg/https-everywhere

I2P in Private Browsing is developed on Gitlab and Github by idk and the community:
 - https://i2pgit.org/idk/I2P-in-Private-Browsing-Mode-Firefox
 - https://github.com/eyedeekay/I2P-in-Private-Browsing-Mode-Firefox


