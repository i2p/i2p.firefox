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
user_pref("network.proxy.no_proxies_on", 0);
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
