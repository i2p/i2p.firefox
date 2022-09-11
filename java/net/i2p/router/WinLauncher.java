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
import net.i2p.util.SystemVersion;

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
public class WinLauncher {
  static Logger logger = Logger.getLogger("launcherlog");
  static FileHandler fh;

  public static void main(String[] args) throws Exception {
    setupLauncher();
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

    if (launchBrowser(privateBrowsing, usabilityMode, chromiumFirst, proxyTimeoutTime, newArgsList)) {
      System.exit(0);
    }

    System.setProperty("i2p.dir.base", programs.getAbsolutePath());
    System.setProperty("i2p.dir.config", home.getAbsolutePath());
    System.setProperty("router.pid",
                       String.valueOf(ProcessHandle.current().pid()));
    logger.info("\t" + System.getProperty("i2p.dir.base") + "\n\t" +
                System.getProperty("i2p.dir.config") + "\n\t" +
                System.getProperty("router.pid"));
    /**
     * IMPORTANT: You must set user.dir to the same directory where the
     * jpackage is intstalled, or when the launcher tries to re-run itself
     * to start the browser, it will start in the wrong directory and fail
     * to find the JVM and Runtime bundle. This broke Windows 11 installs.
     */
    System.setProperty("user.dir", programs.getAbsolutePath());

    // wupp.i2pRouter = new Router(System.getProperties());
    logger.info("Router is configured");

    Thread registrationThread = new Thread(REGISTER_UPP);
    registrationThread.setName("UPP Registration");
    registrationThread.setDaemon(true);
    registrationThread.start();

    setNotRunning();
    // wupp.i2pRouter.runRouter();
    RouterLaunch.main(args);

  }

  private static void setupLauncher() {
    try {
      // This block configure the logger with handler and formatter
      fh = new FileHandler(logFile().toString());
      logger.addHandler(fh);
      SimpleFormatter formatter = new SimpleFormatter();
      fh.setFormatter(formatter);
      // the following statement is used to log any messages
      logger.info("My first log");
    } catch (SecurityException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
    setRunning();
    File jrehome = javaHome();
    logger.info("jre home is: " + jrehome.getAbsolutePath());
    File appimagehome = appImageHome();
    logger.info("appimage home is: " + appimagehome.getAbsolutePath());
  }

  private static File programFile(){
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

  private static File homeDir(){
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
      if (chromiumFirst){
        logger.warning("favoring Chromium instead of Firefox");
      }
      i2pBrowser.setProxyTimeoutTime(proxyTimeoutTime);
      System.out.println("I2PBrowser");
      String[] newArgs = newArgsList.toArray(new String[newArgsList.size()]);
      i2pBrowser.launch(privateBrowsing, newArgs);
      setNotRunning();
      return true;
    }
    return false;
  }

  // see
  // https://stackoverflow.com/questions/434718/sockets-discover-port-availability-using-java
  public static boolean isAvailable(int portNr) {
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

  private static void setNotRunning() {
    logger.info("removing startup file, the application has started");
    File home = selectHome();
    File starting = new File(home, "starting");
    if (starting.exists()) {
      starting.delete();
    }
  }
  
  private static void setRunning() {
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

  private static boolean checkRunning() {
    logger.info("checking startup file");
    File home = selectHome();
    File starting = new File(home, "starting");
    if (starting.exists()) {
      logger.info("startup file exists, I2P is already starting up");
      return true;
    }
    logger.info("startup file does not exist but we're running now");
    setRunning();
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
    if (checkRunning())
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
    // first wait for the RouterContext to appear
    RouterContext ctx;
    while ((ctx = (RouterContext)RouterContext.getCurrentContext()) == null) {
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

  private static File selectHome() { // throws Exception {
    String path_override = System.getenv("I2P_CONFIG");
    if (path_override != null) {
      File path = new File(path_override);
      if (path != null && path.exists()) {
        if (path.isDirectory())
          return path.getAbsoluteFile();
        else
          throw new RuntimeException("I2P_CONFIG is not a directory: " + path);
      }
    }
    if (SystemVersion.isWindows()) {
      File i2p = appImageHome();
      logger.info("Windows jpackage wrapper starting up, using: " + i2p +
                  " as base config");
      return i2p;
    } else {
      File i2p = appImageHome();
      File programs = new File(i2p, ".i2p");
      logger.info("Linux portable jpackage wrapper starting up, using: " +
                  programs + " as base config");
      return programs.getAbsoluteFile();
    }
  }

  private static File selectProgramFile() {
    String path_override = System.getenv("I2P");
    if (path_override != null) {
      File path = new File(path_override);
      if (path.exists()) {
        if (path.isDirectory())
          return path.getAbsoluteFile();
        else
          throw new RuntimeException("I2P is not a directory: " + path);
      }
    }
    if (SystemVersion.isWindows()) {
      File jrehome = new File(System.getProperty("java.home"));
      File programs = jrehome.getParentFile();
      logger.info("Windows portable jpackage wrapper found, using: " +
                  programs + " as working config");
      return programs.getAbsoluteFile();
    } else {
      File jrehome = new File(System.getProperty("java.home"));
      File programs = new File(jrehome.getParentFile().getParentFile(), "i2p");
      logger.info("Linux portable jpackage wrapper found, using: " + programs +
                  " as working config");
      return programs.getAbsoluteFile();
    }
  }

  /**
   * get the the local application data on Windows
   *
   * @return localAppData
   */
  private static File localAppData() {
    File localAppData = new File(System.getenv("LOCALAPPDATA"));
    if (localAppData != null) {
      if (localAppData.exists()) {
        if (localAppData.getAbsolutePath().length() > 3) {
          return localAppData;
        }
      }
    }
    localAppData = new File(System.getenv("user.home"), "AppData/Local");
    return localAppData;
  }

  /**
   * get the OS name(windows, mac, linux only)
   *
   * @return os name in lower-case, "windows" "mac" or  "linux"
   */
  private static String osName() {
    String osName = System.getProperty("os.name").toLowerCase();
    if (osName.contains("windows"))
      return "windows";
    if (osName.contains("mac"))
      return "mac";
    return "linux";
  }

  /**
   * get the path to the java home, for jpackage this is related to the
   * executable itself, which is handy to know. It's a directory called runtime,
   * relative to the root of the app-image on each platform:
   *
   * Windows - Root of appimage is 1 directory above directory named runtime
   *     ./runtime
   *
   * Linux - Root of appimage is 2 directories above directory named runtime
   *     ./lib/runtime
   *
   * Mac OSX - Unknown for now
   *
   * @return
   */
  private static File javaHome() {
    File jrehome = new File(System.getProperty("java.home"));
    if (jrehome != null) {
      if (jrehome.exists()) {
        return jrehome;
      }
    }
    return null;
  }

  /**
   * get the path to the root of the app-image root by getting the path to
   * java.home and the OS, and traversing up to the app-image root based on that
   * information.
   *
   * @return the app-image root
   */
  private static File appImageHome() {
    File jreHome = javaHome();
    if (jreHome != null) {
      switch (osName()) {
      case "windows":
        return jreHome.getAbsoluteFile().getParentFile();
      case "mac":
      case "linux":
        return jreHome.getAbsoluteFile().getParentFile().getParentFile();
      }
    }
    return null;
  }

  /**
   * set up the path to the log file
   *
   * @return
   */
  private static File logFile() {
    File log = new File(selectProgramFile(), "logs");
    if (!log.exists())
      log.mkdirs();
    return new File(log, "launcher.log");
  }

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
