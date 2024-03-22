# I2P Easy-Install Bundle for Windows 2.4.91

This is a pre-release of the I2P Easy-Install Bundle for Windows.

This release embeds a "trunk" Java I2P router based on the git `master` branch.
Network behavior is close to the 2.5.0 release.
It is not an automatic update.

## 2.4.9 Release Notes.

This changes how the I2P bundle and browser profile manager are installed and integrated with the host system.
The Easy-Install bundle is now a "portable" system that can be moved to different locations within or between Windows file-systems while retaining all built-in functionality.
A shortcut for starting the I2P router is still provided by the installer for convenience, but the shortcuts for starting the I2P Browser are now integrated with the I2P desktop UI.

The browser profile manager itself has been split away from the monolithic I2P router+Java/jpackage, and moved into an I2P plugin managed by the router.
While this was done primarily to reduce how complex the existing code was, this also results in behavior which is closer to the main distribution of I2P for Windows and will lead to a more flexible installer, which can bundle additional default plugins and may be suitable for installation as a Windows service.
I2P Plugins can also be updated independently of the router that hosts them, so it will be possible to update the browser profile manager independently of the router itself.
It also means that the browser profile manager can be un-installed by uninstalling the plugin, and much more importantly that the browser profile manager is now compatible with all Java I2P distributions.

**Why a dev build 3 weeks before the release?**

By further delineating the components of the bundle, these changes also affected how the release process happens.
In particular the build process of each component has been encapsulated in a CI description which can be reproduced on a local PC.
This simplifies and automates the build process by ensuring that up-to-date build tools are installed in a brand-new container for every build.
In effect this should speed up the release process for I2P Easy-Install for Windows considerably.
This release is a test-run of the new process, so I can document what is going on.
It breaks down roughly like this:

 - It takes ~22 minutes to compile all the targets for the `i2p.plugins.firefox` and make the resulting artifacts available. During this process, I must insert 1 HSM and enter 1 password. (This part used to be about 30 steps, now it takes 1)
 - It takes ~22 minutes to compile all the targets for the `i2p.firefox` project and make the resulting artifacts available. This process produces only unsigned artifacts identified by their hashes, and is non-interactive. (This part used to be around 60 steps the first time, and 40 steps each additional time)
 - `i2p.firefox` updates are signed in their `.su3` form. The `NSIS`-powered `.exe` installer is the current updater. The next step is to sign *just this installer* and generate a torrent of the result. (This process used to depend on the previous build process and couldn't be done independently. Now it takes about 30 seconds)
 - Generate and sign a newsfeed to notify the users of an update. This process is the only process that is **slower** when containerized, because there are dozens of feeds to be signed in their respective containers. It takes about an hour.

For you the end user, nothing much should change.
You'll get your updates a lot faster, and have more options available for testing.
The same installer is used for the updater, and the process is handled the same way.
However for developers, testers, and maintainers, this release will result in big changes for the better.
