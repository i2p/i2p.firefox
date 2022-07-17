user_pref("extensions.https_everywhere._observatory.enabled", false);
user_pref("extensions.https_everywhere.options.autoUpdateRulesets", false);
user_pref("extensions.https_everywhere.globalEnabled", false);
user_pref("extensions.https_everywhere._observatory.submit_during_tor", false);
user_pref("extensions.https_everywhere._observatory.submit_during_nontor", false);
user_pref("extensions.https_everywhere._observatory.use_custom_proxy", true);
user_pref("extensions.https_everywhere._observatory.proxy_host", "127.0.0.1");
user_pref("extensions.https_everywhere._observatory.proxy_port", 4444);

user_pref("extensions.torbutton.use_nontor_proxy", true);

//For socket conversion: in the future, I'll need to make TBB communicate with
//i2p over a unix socket. Fortunately, this is how you do that. It will be
//configurable in a similar way to the host:port configuration when that happens.
//user_pref("extensions.torlauncher.socks_port_use_ipc", );
//user_pref("extensions.torlauncher.socks_ipc_path", "");

user_pref("extensions.torlauncher.start_tor", false);
//user_pref("extensions.torlauncher.default_bridge_type", "");
user_pref("extensions.torlauncher.prompt_at_startup", false);

// Resist-fingerprinting and first-party isolation enable

user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.firstparty.isolate", true);

// Use i2p http proxy for all connections and set homepage to safe local form.

// DON'T allow access to the admin panel from the profile we browse i2p with.
user_pref("network.proxy.no_proxies_on", "127.0.0.1:7657,localhost:7657,127.0.0.1:7662,localhost:7662,127.0.0.1:7669,localhost:7669");
user_pref("network.proxy.type", 1);
user_pref("network.proxy.http", "127.0.0.1");
user_pref("network.proxy.http_port", 4444);
user_pref("network.proxy.ssl", "127.0.0.1");
user_pref("network.proxy.ssl_port", 4444);
user_pref("network.proxy.ftp", "127.0.0.1");
user_pref("network.proxy.ftp_port", 4444);
user_pref("network.proxy.socks", "127.0.0.1");
user_pref("network.proxy.socks_port", 4444);
user_pref("network.proxy.share_proxy_settings", true);
user_pref("browser.startup.homepage", "about:blank");
user_pref("dom.security.https_only_mode", false);
user_pref("keyword.enabled", false);
user_pref("extensions.allowPrivateBrowsingByDefault", true);
user_pref("extensions.PrivateBrowsing.notification", false);
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "http://planet.i2p/,http://legwork.i2p/,http://i2pwiki.i2p/,http://i2pforums.i2p/,http://zzz.i2p/");
user_pref("browser.newtabpage.activity-stream.feeds.topsites", true);
user_pref("ui.use_standins_for_native_colors", true);
user_pref("webgl.disable-extensions", true);
user_pref("webgl.min_capability_mode", true);
user_pref("webgl.disable-fail-if-major-performance-caveat", true);
user_pref("webgl.enable-webgl2", false);
user_pref("media.navigator.enabled", false);
user_pref("dom.w3c_touch_events.enabled", false);
user_pref("browser.privatebrowsing.autostart", false);
user_pref("browser.display.use_system_colors", false);
user_pref("dom.image-lazy-loading.enabled", false)