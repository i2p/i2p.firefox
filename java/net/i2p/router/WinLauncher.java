package net.i2p.router;

import static net.i2p.update.UpdateType.*;

import java.io.*;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.*;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import net.i2p.app.ClientAppManager;
import net.i2p.crypto.*;
import net.i2p.i2pfirefox.*;
import net.i2p.router.Router;
import net.i2p.router.RouterLaunch;
import net.i2p.update.*;
import net.i2p.update.UpdateManager;
import net.i2p.update.UpdatePostProcessor;

/**
 * Launches a router from %PROGRAMFILES%/I2P using configuration data in
 * %LOCALAPPDATA%/I2P.. Uses Java 9 APIs.
 *
 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config this points to the (read-write) config directory in local
 * appdata
 * router.pid - the pid of the java process.
 */
public class WinLauncher extends CopyConfigDir {
  static WindowsUpdatePostProcessor wupp = null;
  private static Router i2pRouter;

  public static void main(String[] args) {
    setupLauncher();
    initLogger();
    boolean privateBrowsing = false;
    boolean usabilityMode = false;
    boolean chromiumFirst = false;
    int proxyTimeoutTime = 200;
    ArrayList<String> newArgsList = new ArrayList<String>();

    if (args != null) {
      if (args.length > 0) {
        for (String arg : args) {
          if (arg.equals("-private")) {
            privateBrowsing = true;
            logger.info(
                "Private browsing is true, profile will be discarded at end of session.");
          } else if (arg.equals("-chromium")) {
            chromiumFirst = true;
            logger.info("Chromium will be selected before Firefox.");
          } else if (arg.equals("-usability")) {
            usabilityMode = true;
            logger.info(
                "Usability mode is true, using alternate extensions loadout.");
          } else if (arg.equals("-noproxycheck")) {
            proxyTimeoutTime = 0;
            logger.info("Proxy timeout time set to zero");
          } else {
            // make an effort to not let people launch into sites if the proxy
            // isn't quite ready yet, but also disable the proxy timeout if
            // they're reaching a router console
            if (arg.startsWith("http://localhost:76")) {
              newArgsList.add(arg);
              proxyTimeoutTime = 0;
            } else if (arg.startsWith("http://127.0.0.1:76")) {
              newArgsList.add(arg);
              proxyTimeoutTime = 0;
            } else if (arg.startsWith("https://localhost:76")) {
              newArgsList.add(arg);
              proxyTimeoutTime = 0;
            } else if (arg.startsWith("https://127.0.0.1:76")) {
              newArgsList.add(arg);
              proxyTimeoutTime = 0;
            } else if (proxyTimeoutTime > 0) {
              newArgsList.add(arg);
            } else if (!isAvailable(4444)) {
              newArgsList.add(arg);
            }
          }
        }
      }
    }

    File programs = programFile();
    File home = homeDir();

    System.setProperty("i2p.dir.base", programs.getAbsolutePath());
    System.setProperty("i2p.dir.config", home.getAbsolutePath());
    System.setProperty("router.pid",
                       String.valueOf(ProcessHandle.current().pid()));
    /**
     * IMPORTANT: You must set user.dir to the same directory where the
     * jpackage is intstalled, or when the launcher tries to re-run itself
     * to start the browser, it will start in the wrong directory and fail
     * to find the JVM and Runtime bundle. This broke Windows 11 installs.
     */
    System.setProperty("user.dir", programs.getAbsolutePath());
    logger.info("\t" + System.getProperty("user.dir"));
    logger.info("\t" + System.getProperty("i2p.dir.base"));
    logger.info("\t" + System.getProperty("i2p.dir.config"));
    logger.info("\t" + System.getProperty("router.pid"));
    boolean continuerunning = promptServiceStartIfAvailable("i2p");
    if (!continuerunning) {
      logger.severe(
          "Service startup failure, please start I2P service with services.msc");
      System.exit(2);
    } else {
      fixServiceConfig();
    }
    continuerunning = promptUserInstallStartIfAvailable();
    if (!continuerunning) {
      logger.severe("User-install startup required.");
      System.exit(2);
    } else {
      fixServiceConfig();
    }

    // This actually does most of what we use NSIS for if NSIS hasn't
    // already done it, which essentially makes this whole thing portable.
    if (!copyConfigDir()) {
      logger.severe("Cannot copy the configuration directory");
      System.exit(1);
    }

    if (launchBrowser(privateBrowsing, usabilityMode, chromiumFirst,
                      proxyTimeoutTime, newArgsList)) {
      System.exit(0);
    }
    i2pRouter = new Router(routerConfig(), System.getProperties());
    if (!isInstalled("i2p")) {
      if (i2pRouter.saveConfig("routerconsole.browser", null)) {
        logger.info("removed routerconsole.browser config");
      }
      if (i2pRouter.saveConfig("routerconsole.browser",
                               appImageExe() + " -noproxycheck")) {
        logger.info("updated routerconsole.browser config " + appImageExe());
      }
    }
    logger.info("Router is configured");

    Thread registrationThread = new Thread(REGISTER_UPP);
    registrationThread.setName("UPP Registration");
    registrationThread.setDaemon(true);
    registrationThread.start();

    setNotStarting();

    i2pRouter.runRouter();
  }

  private static void fixServiceConfig() {
    // If the user installed the Easy bundle before installing the
    // regulalr bundle, then they have a config file which contains the
    // wrong update URL. Check for it, and change it back if necessary.
    // closes #23
    i2pRouter = new Router(routerConfig(), System.getProperties());
    if (isInstalled("i2p") || checkProgramFilesInstall()) {
      String newsURL = i2pRouter.getConfig("router.newsURL");
      if (newsURL != null) {
        if (newsURL.contains("win/beta")) {
          logger.info(
              "checked router.newsURL config, containes win/beta in a service install, invalid update type");
          if (i2pRouter.saveConfig("router.newsURL", ServiceUpdaterString())) {
            logger.info("updated routerconsole.browser config " +
                        appImageExe());
          }
        }
      }
      String backupNewsURL = i2pRouter.getConfig("router.backupNewsURL");
      if (backupNewsURL != null) {
        if (backupNewsURL.contains("win/beta")) {
          logger.info(
              "checked router.backupNewsURL config, containes win/beta in a service install, invalid update type");
          if (i2pRouter.saveConfig("router.backupNewsURL",
                                   ServiceUpdaterString())) {
            logger.info("updated routerconsole.browser config " +
                        appImageExe());
          }
        }
      }
      String updateURL = i2pRouter.getConfig("router.updateURL");
      if (updateURL != null) {
        if (updateURL.contains("i2pwinupdate.su3")) {
          logger.info(
              "checked router.updateURL config, containes win/beta in a service install, invalid update type");
          if (i2pRouter.saveConfig("router.updateURL",
                                   ServerStaticUpdaterString())) {
            logger.info("updated routerconsole.browser config " +
                        appImageExe());
          }
        }
      }
    }
  }

  private static void setupLauncher() {
    File jrehome = javaHome();
    logger.info("jre home is: " + jrehome.getAbsolutePath());
    File appimagehome = appImageHome();
    logger.info("appimage home is: " + appimagehome.getAbsolutePath());
  }

  private static File programFile() {
    File programs = selectProgramFile();
    if (!programs.exists())
      programs.mkdirs();
    else if (!programs.isDirectory()) {
      logger.warning(
          programs +
          " exists but is not a directory. Please get it out of the way");
      System.exit(1);
    }
    return programs;
  }

  private static File homeDir() {
    File home = selectHome();
    if (!home.exists())
      home.mkdirs();
    else if (!home.isDirectory()) {
      logger.warning(
          home +
          " exists but is not a directory. Please get it out of the way");
      System.exit(1);
    }
    return home;
  }

  private static boolean launchBrowser(boolean privateBrowsing,
                                       boolean usabilityMode,
                                       boolean chromiumFirst,
                                       int proxyTimeoutTime,
                                       ArrayList<String> newArgsList) {
    if (i2pIsRunning()) {
      logger.info("I2P is already running, launching an I2P browser");
      I2PBrowser i2pBrowser = new I2PBrowser();
      i2pBrowser.usability = usabilityMode;
      i2pBrowser.chromiumFirst = chromiumFirst;
      i2pBrowser.firefox = !chromiumFirst;
      i2pBrowser.chromium = chromiumFirst;
      if (chromiumFirst) {
        logger.warning("favoring Chromium instead of Firefox");
      }
      i2pBrowser.setProxyTimeoutTime(proxyTimeoutTime);
      System.out.println("I2PBrowser");
      String[] newArgs = newArgsList.toArray(new String[newArgsList.size()]);
      setNotStarting();
      i2pBrowser.launch(privateBrowsing, newArgs);
      return true;
    }
    return false;
  }

  // see
  // https://stackoverflow.com/questions/434718/sockets-discover-port-availability-using-java
  private static boolean isAvailable(int portNr) {
    boolean portFree;
    try (var ignored = new ServerSocket(portNr)) {
      portFree = true;
    } catch (IOException e) {
      portFree = false;
    }
    return portFree;
  }

  private static boolean i2pIsRunningCheck() {
    // check if there's something listening on port 7657(Router Console)
    if (!isAvailable(7657))
      return true;
    // check if there's something listening on port 7654(I2CP)
    if (!isAvailable(7654))
      return true;
    if (checkPing())
      return true;
    return false;
  }

  private static void setNotStarting() {
    logger.info("removing startup file, the application has started");
    File home = selectHome();
    File starting = new File(home, "starting");
    if (starting.exists()) {
      starting.delete();
    }
  }

  private static void setStarting() {
    logger.info("creating startup file, router is starting up");
    File home = selectHome();
    File starting = new File(home, "starting");
    if (!starting.exists()) {
      try {
        starting.createNewFile();
      } catch (IOException e) {
        logger.info(e.toString());
      }
    }
  }

  private static boolean checkStarting() {
    logger.info("checking startup file");
    File home = selectHome();
    File starting = new File(home, "starting");
    if (starting.exists()) {
      logger.info("startup file exists, I2P is already starting up");
      return true;
    }
    logger.info("startup file does not exist but we're running now");
    setStarting();
    return false;
  }

  // check for the existence of router.ping file, if it's less then 2
  // minutes old, exit
  private static boolean checkPing() {
    File home = selectHome();
    File ping = new File(home, "router.ping");
    if (ping.exists()) {
      long diff = System.currentTimeMillis() - ping.lastModified();
      if (diff > 60 * 1000) {
        logger.info(
            "router.ping exists and is more than 1 minute old, I2P does not appear to be running.");
        logger.info("If I2P is running, report this as a bug.");
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  private static boolean i2pIsRunning() {
    if (checkStarting())
      return true;
    if (checkPing())
      return true;
    if (i2pIsRunningCheck())
      return true;
    for (int i = 0; i < 10; i++) {
      if (i2pIsRunningCheck())
        return true;
      sleep(1000);
    }
    return false;
  }

  private static final Runnable REGISTER_UPP = () -> {
    RouterContext ctx;
    while ((ctx = i2pRouter.getContext()) == null) {
      sleep(1000);
    }
    // then wait for the update manager
    ClientAppManager cam;
    while ((cam = ctx.clientAppManager()) == null) {
      sleep(1000);
    }
    UpdateManager um;
    while ((um = (UpdateManager)cam.getRegisteredApp(UpdateManager.APP_NAME)) ==
           null) {
      sleep(1000);
    }
    WindowsUpdatePostProcessor wupp = new WindowsUpdatePostProcessor(ctx);
    um.register(wupp, UpdateType.ROUTER_SIGNED_SU3, SU3File.TYPE_EXE);
    um.register(wupp, UpdateType.ROUTER_DEV_SU3, SU3File.TYPE_EXE);
  };

  /**
   * sleep for 1 second
   *
   * @param millis
   */
  private static void sleep(int millis) {
    try {
      Thread.sleep(millis);
    } catch (InterruptedException bad) {
      bad.printStackTrace();
      throw new RuntimeException(bad);
    }
  }
}
