Setting up an Update Server for an I2P Bundle
=============================================

It is important to set up a signed update server so that people are able to
safely and anonymously update your I2P bundle. There are two sort of "Levels"
to what you might do to provide updates to your users. Each of them requires the
generation of a [signed newsfeed](https://eyedeekay.github.io/Hopefully-Holistic-Guide-to-I2P-Dev-Build-Update-Hosting/),
which also serves as a way to provide information to your users about updates,
features, and security events.

This project, `i2p.firefox` a.k.a. the "I2P Easy Install Bundle" uses the "Executable"
update subtype, meaning that it capable of installing itself by executing code as the
user who runs the update, which is usually the main user of a Windows 10 or 11 PC.
This update subtype is highly flexible, but requires the creation of a "Scripted" using
something like `NSIS`, `wixl`, or custom code. Other update types include ZIP (used by
the core I2P product) and DMG(used by Mac OSX).

Static HTTP Update URL over I2P
===============================

Bittorrent Update URL over I2P
==============================

[If you choose to do this, consider using zzzot to host your open tracker instead of a normal site](https://github.com/i2p/i2p.plugins.zzzot),
which you can obtain from [this I2P link](http://stats.i2p/i2p/plugins/zzzot.su3).