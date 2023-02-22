Guidance
========

This document explains the ideas which are guiding the development of
features specific to the I2P Easy-Install bundle.

The general idea is that it is possible, on most platforms, to make I2P
post-install configuration much simpler and much less error-prone. Each
section of this document has guidance for a different "Meta-Feature" of
the I2P Easy-Install Bundle. For granular, specific information about
goals both achieved and un-achieved see `[GOALS]`.

- **Sections:**

1. Guidance for Browser Profile Configuration

Guidance for Browser Profile Configuration
------------------------------------------

- **See also:**
- [git.idk.i2p/idk/i2p.plugins.firefox](http://git.idk.i2p/idk/i2p.plugins.firefox)
- [i2pgit.org/idk/i2p.plugins.firefox](https://i2pgit.org/idk/i2p.plugins.firefox)
- [github.com/eyedeekay/i2p.plugins.firefox](https://github.com/eyedeekay/i2p.plugins.firefox)

The I2P Easy-Install Bundle for Windows considers basic configuration tasks
"Features" when they can be automated. The quintessential example of this
is **``Browser Profile Configuration``** where it injects settings into a
pre-existing browser from the host system. Solving this problem pre-dates
the evolution of `i2p.firefox` into a fully-fledged I2P router distribution
and has been the defining goal of this project for its entire existence.

However, what good browser profile configuration is, is as complicated as
how to deploy it. I2P has a unique opportunity to decide how it will handle
problems related to browsing in its own context while the network grows
and synthesize a useful number of safe browser configurations while also
reducing existing browser config fragmentation.

Easy-Install attempts to limit the number of "Coarse Fingerprints" which it will
produce by default to a predictable number. A Coarse Fingerprint is basically
a fingerprint "That we know we're making" by offering the ability to configure
something differently.

- **That means:**

1. It considers the browser integral to the interactive use of the I2P network by a large fraction of users.
2. It considers effective browser configuration **impossible for a single user to achieve** because effective browser configuration must have the characteristic of being reflected en-masse(anti-fingerprinting measures are only remotely effective when widely used).
3. The browser profile it injects inherits the runtime security characteristics of the **host browser**.
4. The browser profile it injects obtains runtime privacy characteristics of the **easy-install bundle**
5. The number of coarse browser fingerprint sets is reduced from indeterminately large to `[supported browsers]*[variant configurations]`
6. It attempts to balance flexibility with privacy, and accommodate people's preferences where possible.
7. It considers browser vendors better at providing browser updates than the I2P Project

Browser Configurations and Coarse Fingerprints
----------------------------------------------

At this time it offers configuration for Tor Browser, Firefox, Waterfox, and
LibreWolf for Firefox-based browsers, and Ungoogled-Chromium, Chromium, Brave,
Chrome, and Edgium configuration for Chromium-based browsers. That is a total
of **Nine(9)** main browsers. There are **Two(2)** variant configurations,
which correspond to "Strict" and "Usability" Modes. That makes a total of
**Eighteen(18)** coarse browser fingerprints produced by this bundle. It also
has the ability to launch in a "Restricted to Apps" mode where it is only
possible to visit I2P sites using links on the I2P application interface(router
console, hidden services manager) itself.

### Strict Mode

This is not on its face as good as having an almost entirely unified browser
fingerprint like Tor Browser attempts to have. It is a simple fact that 18
is greater than one. Every active attempt to gain granularity from a browser
outside of off-the-shelf Fingerprinting techniques is classified as "Fine"
fingerprinting. It is unpredictable, and harder to defend against, more likely
to exhibit novelty, and more likely to be affected by the host browser's
security. When fingerprinters get this creative disabling Javascript by default
is the most complete defense. This is the primary characteristic of Strict Mode,
it disables Javascript by default with NoScript. **Strict Mode is the only**
**partial defense against fine-fingerprinting offered by this product.** Even
disabling Javascript does not close all fine fingerprinting vectors, but it
does close most of them and reduce attack surface significantly. It is recommended
in combination with Tor Browser, and attempts to be somewhat closer to Tor Browser
than Usability Mode. It is the default mode of operation.

### Usability Mode

In contrast to Strict Mode, Usability mode offers the greatest agreeable number
of browser features enabled by default, including a restricted subset of Javascript.
It makes no attempt at all to look like Tor Browser, even when using Tor Browser
as a host browser. It does attempt to optimize the browser for use within I2P, including
specific optimizations to keep traffic in-network or even retrieve information which is
stored on the localhost(while avoiding cache timing attacks). It does this by deploying
an alternative loadout of extensions, including ones which block advertising by default
and which include a cache of CDN resources in local browser storage.

### Firefox-Based Browsers

Because of the relatively high configurability of Firefox-based browser
telemetry, Firefox-based browsers are preferred over Chromium-based browsers.
Chromium-based browsers will be used by default **only** if a Firefox based
browser is unavailable. Only Firefox-variant releases of the Extended Support
Release or of the latest stable release are supportable. If a variant lags
behind Firefox releases, it will be dropped. The primary reason for the default
"Ordering" of Firefox Profile Selection is the speed at which updates can be
expected to be applied.

### Chromium-Based Browsers

Chromium-based browser selection is more subjective and slightly more ad-hoc.
Chromium browsers are chosen based on the variant's stated goals and perceived
efficacy in pursuing those goals. For example, if a Chromium distribution is
focused on removing telemetry or providing anti-fingerprinting, it is chosen
before a Chromium that is provided by Google or integrated tightly with the
host OS. This is a matter of judgement on my part and if you disagree you should
open an issue and argue with me. I'm not infallible, I'll listen.

### All other browsers

With all other browsers attempts at anti-fingerprinting are a moot point. It offers
limited configuration options using widely-supported generic browser configuration
means. If it doesn't recognize a Firefox or Chromium browser on the host, then it
sets the common proxy environment variables `http_proxy` `https_proxy` `ALL_PROXY`
and `NO_PROXY` to their appropriate values before launching the browser configuration
and attempts to set a directory for the runtime configuration(Profile) by changing
to the profile directory.
