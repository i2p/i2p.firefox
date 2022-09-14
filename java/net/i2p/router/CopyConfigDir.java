package net.i2p.router;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class CopyConfigDir {
  static final Logger logger = Logger.getLogger("configlog");

  public static void initLogger() {
    try {
      // This block configure the logger with handler and formatter
      FileHandler fh = new FileHandler(logFile().toString());
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
  }

  public static boolean copyDirectory(String baseDir, String workDir) {
    File baseFile = new File(baseDir);
    File workFile = new File(workDir);
    return copyDirectory(baseFile, workFile);
  }

  public static boolean copyDirectory(File baseDir, File workDir) {
    for (File file : baseDir.listFiles()) {
      String fPath = file.getAbsolutePath().replace(
          file.getParentFile().getAbsolutePath(), "");
      String newPath = workDir.toString() + fPath;
      if (file.isDirectory())
        if (copyDirectory(file, new File(newPath)))
          return false;
      if (file.isFile())
        if (!copyFile(file, new File(newPath), true))
          return false;
    }
    return true;
  }

  public static boolean copyConfigDirectory(File baseDir, File workDir) {
    for (File file : baseDir.listFiles()) {
      // System.out.println(file.getAbsolutePath());
      String fPath = file.getAbsolutePath().replace(
          file.getParentFile().getAbsolutePath(), "");
      String newPath = workDir.toString() + fPath;
      if (file.isDirectory())
        if (!copyConfigDirectory(file, new File(newPath)))
          return false;
      if (file.isFile())
        if (!copyFileNeverOverwrite(
                file,
                new File(newPath))) // new File(workDir, file.toString())))
          return false;
    }
    return true;
  }

  public static boolean copyFileNeverOverwrite(String basePath,
                                               String workPath) {
    File baseFile = new File(basePath);
    File workFile = new File(workPath);
    return copyFileNeverOverwrite(baseFile, workFile);
  }

  public static boolean copyFileNeverOverwrite(File basePath, File workPath) {
    return copyFile(basePath, workPath, false);
  }

  public static boolean copyFile(File basePath, File workPath,
                                 boolean overWrite) {
    if (!basePath.exists()) {
      logger.info(basePath.getAbsolutePath() + " doesn't exist, not copying");
      return false;
    }

    if (!overWrite && workPath.exists()) {
      logger.info(workPath.getAbsolutePath() +
                  " already exists, not overwriting");
      return true;
    }

    File workDir = workPath.getParentFile();
    if (!workDir.exists()) {
      workDir.mkdirs();
    }
    try (InputStream in =
             new BufferedInputStream(new FileInputStream(basePath));
         OutputStream out =
             new BufferedOutputStream(new FileOutputStream(workPath))) {

      byte[] buffer = new byte[1024];
      int lengthRead;
      while ((lengthRead = in.read(buffer)) > 0) {
        out.write(buffer, 0, lengthRead);
        out.flush();
      }
      in.close();
      out.close();
      return true;
    } catch (Throwable e) {
      logger.warning(e.toString());
      logger.warning("failed to copy " + basePath.getAbsolutePath() + " to " +
                     workPath.getAbsolutePath());
      return false;
    }
  }

  protected static File selectHome() { // throws Exception {
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

  protected static File selectProgramFile() {
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
   * get the OS name(windows, mac, linux only)
   *
   * @return os name in lower-case, "windows" "mac" or  "linux"
   */
  protected static String osName() {
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
  protected static File javaHome() {
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
  protected static File appImageHome() {
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
  protected static String appImageExe() {
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
  protected static File appImageConfig() {
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

  protected static boolean copyConfigDir() {
    File appImageConfigDir = appImageConfig();
    File appImageHomeDir = selectHome();
    return copyConfigDirectory(appImageConfigDir, appImageHomeDir);
  }

  protected static String routerConfig() {
    File appImageHomeDir = selectHome();
    File routerConf = new File(appImageHomeDir, "router.config");
    if (routerConf != null) {
      if (routerConf.exists()) {
        return routerConf.getAbsolutePath();
      }
    }
    return null;
  }

  /**
   * set up the path to the log file
   *
   * @return
   */
  protected static File logFile() { return logFile("launcher.log"); }

  /**
   * set up the path to the log file
   *
   * @return
   */
  protected static File logFile(String p) {
    File log = new File(selectProgramFile(), "logs");
    if (!log.exists())
      log.mkdirs();
    return new File(log, p);
  }
}
