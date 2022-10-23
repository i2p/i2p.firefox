Feature Goals
=============

For information about the "Goals guiding the Goals" see: `[PRINCIPLES]`.

While Windows is the primary platform, some goals may represent cross-platform
utility as well. Since a portable jpackage really only needs slightly different
arguments on different platforms, cross-platform support is often low-cost.

- **See Also:**
- *Browser Integrations are provided by browser extensions which are contained in their own repositories.*
- Firefox:
- [git.idk.i2p/idk/I2P-in-Private-Browsing-Mode-Firefox](http://git.idk.i2p/idk/I2P-in-Private-Browsing-Mode-Firefox/)
- [i2pgit.org/idk/I2P-in-Private-Browsing-Mode-Firefox](https://i2pgit.org/idk/I2P-in-Private-Browsing-Mode-Firefox/)
- [github.com/eyedeekay/I2P-in-Private-Browsing-Mode-Firefox](https://github.com/eyedeekay/I2P-in-Private-Browsing-Mode-Firefox/)
- Chromium:
- [git.idk.i2p/idk/I2P-Configuration-For-Chromium](http://git.idk.i2p/idk/I2P-Configuration-For-Chromium/)
- [i2pgit.org/idk/I2P-Configuration-For-Chromium](https://i2pgit.org/idk/I2P-Configuration-For-Chromium/)
- [github.com/eyedeekay/I2P-Configuration-For-Chromium](https://github.com/eyedeekay/I2P-Configuration-For-Chromium/)
- *Browser profile management are provided by a freestanding, cross-platform library which is contained in its own repository.*
- [git.idk.i2p/idk/i2p.plugins.firefox](http://git.idk.i2p/idk/i2p.plugins.firefox)
- [i2pgit.org/idk/i2p.plugins.firefox](https://i2pgit.org/idk/i2p.plugins.firefox)
- [github.com/eyedeekay/i2p.plugins.firefox](https://github.com/eyedeekay/i2p.plugins.firefox)

Build Methods
-------------

- `[X]` Cleanly separate jpackage generation phase from NSIS generation phase
- `[X]` Enable archive builds for generating Windows `.exe`'s from Linux hosts

Installation Methods
--------------------

- `[X]` NSIS installer
- `[X]` Portable, directory-based install
- `[ ]` Windows Service Support

Update Methods
--------------

- `[X]` NSIS installer in Default Directory
- `[X]` NSIS installer in Portable Directory
- `[X]` Handle admin and non-admin updates automatically
- `[ ]` Zip-Only portable updater

Launcher
--------

- `[X]` Detect and handle un-bundled routers on the host system, policy of non-interference
- `[X]` Wait for router console to be ready to launch router-console browser
- `[X]` Wait for proxy to be ready to launch I2P Web Browser
- `[X]` Launch browser instead of router when a repeat-launch is detected
- `[X]` GUI component for launching each available component
- `[X]` Introduce `browser.properties` for customization
- `[ ]` Registry-based browser discovery [Firefox](http://git.idk.i2p/idk/i2p.plugins.firefox/-/issues/3) [Chromium](http://git.idk.i2p/idk/i2p.plugins.firefox/-/issues/4)

Browser Configuration All
-------------------------

- `[X]` Use identical extensions in Firefox-based and Chromium-based browsers wherever possible
- `[X]` Always use a dedicated, I2P Easy-Install specific profile directory
- `[X]` Always configure an HTTP Proxy, and safe access to the router console
- `[X]` Provide I2P-Specific integrations to the browser UI through WebExtensions
- `[X]` Operate in "Strict" mode where the maximum level of defenses are up
- `[X]` Operate in "Usability" mode where defense is balanced with utility
- `[X]` Operate in "App" mode where we work as a single-purpose window where it is hard to access arbitrary, potentially malicious resources
- `[X]` All I2P-Specific profiles should be possible to generate automatically, sight-unseen

Browser Configuration Firefox
-----------------------------

- `[X]` When using Firefox, download extension updates automatically, from AMO, using an outproxy
- `[X]` Integrate I2P in Private Browsing for to provide UI for I2P within Firefox
- `[X]` Prevent WebRTC proxy escapes by setting mode `4` `disable_non_proxied_udp` or higher
- `[X]` Customize panel for Firefox `App` mode(Not required for Chromiums)

Browser Configuration Chromium
------------------------------

- `[X]` When using Chromium, load extensions from source and freeze them without updates to prevent unproxied updating.
- `[X]` Integrate `I2PChrome.js` to provide UI for I2P within Chrome
- `[X]` Prevent WebRTC proxy escapes by setting mode `4` `disable_non_proxied_udp`

Browser Configuration Strict Mode
---------------------------------

- `[X]` Disable Javascript by default with NoScript
- `[X]` Enforce HTTPS where available with HTTPS Everywhere **OR** HTTPS only Mode
- `[ ]` Proactively enumerate and disable "Fine" fingerprinting vectors where possible(ongoing)
- `[ ]` When running in Tor Browser, look as much like Tor Browser as possible but use an outproxy(ongoing)

Browser Configuration Usability Mode
------------------------------------

- `[X]` Enable Javascript by default but limit it with jShelter
- `[X]` Enforce HTTPS where available with HTTPS Everywhere **OR** HTTPS only Mode
- `[X]` Limit attempts to fetch useless junk like advertising with an up-to-date uBlock Origin
- `[X]` Limit attempts to reach clearnet CDN's with LocalCDN
- `[X]` Isolate `.onion` traffic from `outproxy` traffic and `.i2p` traffic using Onion in Container Tabs
