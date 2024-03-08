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
import java.util.logging.SimpleFormatter;
import net.i2p.util.Log;

public class CopyConfigDir extends WindowsServiceUtil {
  final Log logger;

  public CopyConfigDir(RouterContext ctx) {
    logger = ctx.logManager().getLog(CopyConfigDir.class);
  }

  public boolean copyDirectory(String baseDir, String workDir) {
    File baseFile = new File(baseDir);
    File workFile = new File(workDir);
    return copyDirectory(baseFile, workFile);
  }

  public boolean copyDirectory(File baseDir, File workDir) {
    for (File file : baseDir.listFiles()) {
      String fPath = file.getAbsolutePath().replace(
          file.getParentFile().getAbsolutePath(), "");
      String newPath = workDir.toString() + fPath;
      if (file.isDirectory())
        if (copyDirectory(file, new File(newPath)))
          return false;
      if (file.isFile())
        if (0 == copyFile(file, new File(newPath), true))
          return false;
    }
    return true;
  }

  public boolean copyConfigDirectory(File baseDir, File workDir) {
    for (File file : baseDir.listFiles()) {
      // System.out.println(file.getAbsolutePath());
      String fPath = file.getAbsolutePath().replace(
          file.getParentFile().getAbsolutePath(), "");
      String newPath = workDir.toString() + fPath;
      if (file.isDirectory())
        if (!copyConfigDirectory(file, new File(newPath)))
          return false;
      if (file.isFile()) {
        int cnr = copyFileNeverOverwrite(file, new File(newPath));
        if (0 == cnr)
          return false;
        if (1 == cnr) {
          logger.info(
              "using jpackaged configs in a jpackaged install, creating jpackaged file");
          File jpackagedConfigsInUse = new File(appImageHome(), "jpackaged");
          if (!jpackagedConfigsInUse.exists()) {
            try {
              jpackagedConfigsInUse.createNewFile();
            } catch (IOException e) {
              logger.warn(
                  "Error creating jpackaged file, delete config files manually when uninstalling");
            }
          }
        }
        if (-1 == cnr) {
          logger.info(
              "not overwriting existing config file, not creating jpackaged file");
        }
      }
    }
    return true;
  }

  public int copyFileNeverOverwrite(String basePath, String workPath) {
    File baseFile = new File(basePath);
    File workFile = new File(workPath);
    return copyFileNeverOverwrite(baseFile, workFile);
  }

  public int copyFileNeverOverwrite(File basePath, File workPath) {
    return copyFile(basePath, workPath, false);
  }

  public int copyFile(File basePath, File workPath, boolean overWrite) {
    if (!basePath.exists()) {
      logger.info(basePath.getAbsolutePath() + " doesn't exist, not copying");
      return 0;
    }

    if (!overWrite && workPath.exists()) {
      logger.info(workPath.getAbsolutePath() +
                  " already exists, not overwriting");
      return -1;
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
      return 1;
    } catch (Throwable e) {
      logger.warn(e.toString());
      logger.warn("failed to copy " + basePath.getAbsolutePath() + " to " +
                  workPath.getAbsolutePath());
      return 0;
    }
  }

  protected boolean copyConfigDir() {
    File appImageConfigDir = appImageConfig();
    File appImageHomeDir = selectHome();
    return copyConfigDirectory(appImageConfigDir, appImageHomeDir);
  }

  /**
   * set up the path to the log file
   *
   * @return
   */
  protected File logFile() { return logFile("launcher.log"); }

  /**
   * set up the path to the log file
   *
   * @return
   */
  protected File logFile(String p) {
    File log = new File(selectProgramFile(), "logs");
    if (!log.exists())
      log.mkdirs();
    return new File(log, p);
  }
}
