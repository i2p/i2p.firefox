package net.i2p.router;

import java.io.File;
import net.i2p.util.Log;
import net.i2p.router.RouterContext;

public class WindowsAppUtil extends WindowsServiceUtil {
  private Log _log;

  public void setLog(Log log) {
    this._log = log;
  }

  private File checkPathEnvironmentVariable(String name) {
    String path_override = System.getenv(name);
    if (path_override != null) {
      File path = new File(path_override);
      if (path != null && path.exists()) {
        if (path.isDirectory())
          return path.getAbsoluteFile();
        else
          throw new RuntimeException(name + " is not a directory: " + path);
      }
    }
    return null;
  }

  protected File selectHome() { // throws Exception {
    File i2p = checkPathEnvironmentVariable("JPACKAGE_HOME");
    if (i2p == null)
      i2p = appImageHome();
    return i2p;
  }

  /**
   * get the path to the java home, for jpackage this is related to the
   * executable itself, which is handy to know. It's a directory called runtime,
   * relative to the root of the app-image on each platform:
   *
   * Windows - Root of appimage is 1 directory above directory named runtime
   * ./runtime
   *
   * Linux - Root of appimage is 2 directories above directory named runtime
   * ./lib/runtime
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
      // get the name of the aih directory itself, which will be the default
      // name of the executable as well
      String baseName = aih.getName();
      switch (osName()) {
        case "windows":
          return baseName + ".exe";
        case "mac":
        case "linux":
          return "./bin/" + baseName;
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
