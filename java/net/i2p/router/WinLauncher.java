package net.i2p.router;

import java.io.*;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.*;
import net.i2p.app.ClientAppManager;
import net.i2p.crypto.*;
import net.i2p.router.Router;
import net.i2p.router.RouterLaunch;
import net.i2p.update.*;
import net.i2p.update.UpdateManager;
import net.i2p.update.UpdateType.*;
import net.i2p.util.Log;

/**
 * Launches a router from %WORKINGDIR%/I2P using configuration data in
 * %WORKINGDIR%/I2P.. Uses Java 9 APIs.
 *
 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config this points to the (read-write) config directory in local
 * appdata
 * router.pid - the pid of the java process.
 */
public class WinLauncher extends I2PAppUtil {
  // private final CopyConfigDir copyConfigDir;
  WinUpdatePostProcessor wupp = null;
  private Router i2pRouter;
  private final Log logger;

  public WinLauncher() {
    File programs = programFile();

    System.setProperty(
        "i2p.dir.base",
        appImageConfig().getAbsolutePath());
    System.setProperty("i2p.dir.config", appImageConfig().getAbsolutePath());
    System.setProperty("router.pid",
        String.valueOf(ProcessHandle.current().pid()));
    /**
     * IMPORTANT: You must set user.dir to the same directory where the
     * jpackage is intstalled, or when the launcher tries to re-run itself
     * to start the browser, it will start in the wrong directory and fail
     * to find the JVM and Runtime bundle. This broke Windows 11 installs.
     */
    System.setProperty("user.dir", programs.getAbsolutePath());

    i2pRouter = new Router(routerConfig(), System.getProperties());
    // copyConfigDir = new CopyConfigDir(i2pRouter.getContext());
    logger = i2pRouter.getContext().logManager().getLog(WinLauncher.class);
  }

  public static void main(String[] args) {
    var launcher = new WinLauncher();
    launcher.setupLauncher();
    int proxyTimeoutTime = 200;

    launcher.logger.info("\t" + System.getProperty("user.dir"));
    launcher.logger.info("\t" + System.getProperty("i2p.dir.base"));
    launcher.logger.info("\t" + System.getProperty("i2p.dir.config"));
    launcher.logger.info("\t" + System.getProperty("router.pid"));
    boolean continuerunning = launcher.promptServiceStartIfAvailable("i2p");
    if (!continuerunning) {
      launcher.logger.error(
          "Service startup failure, please start I2P service with services.msc");
      System.exit(2);
    }
    continuerunning = launcher.promptUserInstallStartIfAvailable();
    if (!continuerunning) {
      launcher.logger.error("User-install startup required.");
      System.exit(2);
    }

    // This actually does most of what we use NSIS for if NSIS hasn't
    // already done it, which essentially makes this whole thing portable.
    /*
     * if (!launcher.copyConfigDir.copyConfigDir()) {
     * launcher.logger.error("Cannot copy the configuration directory");
     * System.exit(1);
     * }
     */

    if (!launcher.isInstalled("i2p")) {
      if (launcher.i2pRouter.saveConfig("routerconsole.browser", "NUL")) {
        launcher.logger.info("updated routerconsole.browser config " +
            launcher.appImageExe());
      }
    }
    launcher.logger.info("Router is configured");

    Thread registrationThread = new Thread(launcher.REGISTER_UPP);
    registrationThread.setName("UPP Registration");
    registrationThread.setDaemon(true);
    registrationThread.start();

    launcher.i2pRouter.runRouter();
  }

  private void setupLauncher() {
    File jrehome = javaHome();
    logger.info("jre home is: " + jrehome.getAbsolutePath());
    File appimagehome = appImageHome();
    logger.info("appimage home is: " + appimagehome.getAbsolutePath());
  }

  private File programFile() {
    File programs = selectHome();
    if (!programs.exists())
      programs.mkdirs();
    else if (!programs.isDirectory()) {
      logger.warn(
          programs +
              " exists but is not a directory. Please get it out of the way");
      System.exit(1);
    }
    return programs;
  }

  // see
  // https://stackoverflow.com/questions/434718/sockets-discover-port-availability-using-java
  private boolean isAvailable(int portNr) {
    boolean portFree;
    try (var ignored = new ServerSocket(portNr)) {
      portFree = true;
    } catch (IOException e) {
      portFree = false;
    }
    return portFree;
  }

  private final Runnable REGISTER_UPP = () -> {
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
    while ((um = (UpdateManager) cam.getRegisteredApp(UpdateManager.APP_NAME)) == null) {
      sleep(1000);
    }
    WinUpdatePostProcessor wupp = new WinUpdatePostProcessor(ctx);
    um.register(wupp, UpdateType.ROUTER_SIGNED_SU3, SU3File.TYPE_EXE);
    um.register(wupp, UpdateType.ROUTER_DEV_SU3, SU3File.TYPE_EXE);
  };

  /**
   * sleep for 1 second
   *
   * @param millis
   */
  private void sleep(int millis) {
    try {
      Thread.sleep(millis);
    } catch (InterruptedException bad) {
      bad.printStackTrace();
      throw new RuntimeException(bad);
    }
  }
}
