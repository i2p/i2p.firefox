Feature Goals
=============

The general idea is that it's possible, on most platforms, to make I2P
post-install configuration much simpler and much less error-prone.

The I2P Easy-Install Bundle for Windows considers basic configuration tasks
"Features" when they can be automated. The quintessential example of this
is **``Browser Profile Configuration``** where it injects settings into a
pre-existing browser from the host system. That means:

1. It considers the browser integral to the interactive use of the I2P network by a large fraction of users.
2. It considers effective browser configuration **impossible for a single user to achieve** because effective browser configuration must have the characteristic of being reflected en-masse(anti-fingerprinting measures are only remotely effective when widely used).
3. The browser profile it injects inherits the runtime security characteristics of the **host browser**.
4. The browser profile it injects obtains runtime privacy characteristics of the **easy-install bundle**
5. The number of coarse browser fingerprint sets is reduced from indeterminately large to `[supported browsers]*[variant configurations]`, give or take some creativity on the part of the fingerprinters

Because of the relatively high configurability of Firefox-based browser
telemetry, Firefox-based browsers are preferred over Chromium-based browsers.
Chromium-based browsers will be used by default **only** if a Firefox based
browser is unavailable. Only Firefox-variant releases of the Extended Support
Release or of the latest stable release are supportable. If a variant lags
behind Firefox releases, it will be dropped. The primary reason for the default
"Ordering" of Firefox Profile Selection is the speed at which updates can be
expected to be applied.

Chromium-based browser selection is more subjective and slightly more ad-hoc.
Chromium browsers are chosen based on the variant's stated goals and perceived
efficacy in pursuing those goals. For example, if a Chromium distribution is
focused on removing telemetry or providing anti-fingerprinting, it is chosen
before a Chromium that is provided by Google or integrated tightly with the
host OS. This is a matter of judgement on my part and if you disagree you should
open an issue and argue with me. I'm not infallible, I'll listen.


