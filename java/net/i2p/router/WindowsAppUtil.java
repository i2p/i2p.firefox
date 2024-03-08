package net.i2p.router;

import java.io.File;
import net.i2p.util.Log;

public class WindowsAppUtil extends WindowsServiceUtil {
  final Log logger;
  public WindowsAppUtil(RouterContext ctx) {
    super();
    logger = ctx.logManager().getLog(WindowsAppUtil.class);
  }
  protected File selectHome() { // throws Exception {
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
    File i2p = appImageHome();
    logger.info("Checking for signs of life in I2P_CONFIG directory: " + i2p);
    return i2p;
  }

  protected File selectProgramFile() {
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
    File i2p = appImageHome();
    logger.info("Checking for signs of life in I2P directory: " + i2p);
    return i2p;
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
  protected File javaHome() {
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
  protected File appImageHome() {
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
   * get the path to the binary of the app-image root by getting the path to
   * java.home and the OS, and traversing up to the app-image root based on that
   * information, then getting the binary path on a per-platform basis. The path
   * returned will be relative to the root.
   *
   * @return the app-image root
   */
  protected String appImageExe() {
    File aih = appImageHome();
    if (aih != null) {
      switch (osName()) {
      case "windows":
        return "I2P.exe";
      case "mac":
      case "linux":
        return "./bin/I2P";
      }
    }
    return null;
  }

  /**
   * get the path to the default config of the app-image by getting the path to
   * java.home and the OS, and traversing up to the app-image root based on that
   * information, then appending the config directory to the end onn a
   * per-platform basis
   *
   * @return the app-image root
   */
  protected File appImageConfig() {
    File aih = appImageHome();
    if (aih == null) {
      return null;
    }
    String osName = osName();
    switch (osName) {
    case "windows":
      File winConfigDir = new File(aih, "config");
      if (winConfigDir != null) {
        if (winConfigDir.exists()) {
          return winConfigDir;
        }
      }
    case "mac":
    case "linux":
      File linConfigDir = new File(aih, "lib/config");
      if (linConfigDir != null) {
        if (linConfigDir.exists()) {
          return linConfigDir;
        }
      }
    }
    return null;
  }

  protected String routerConfig() {
    File appImageHomeDir = selectHome();
    File routerConf = new File(appImageHomeDir, "router.config");
    if (routerConf != null) {
      if (routerConf.exists()) {
        return routerConf.getAbsolutePath();
      }
    }
    return null;
  }
}
