package net.i2p.router;

import java.io.*;
import java.util.Map;
import java.util.function.*;
import net.i2p.I2PAppContext;
import net.i2p.router.*;
import net.i2p.util.Log;

class WinUpdateProcess implements Runnable {
  private final RouterContext ctx;
  private final Supplier<String> versionSupplier;
  private final Supplier<File> fileSupplier;
  private final Log _log;

  WinUpdateProcess(RouterContext ctx, Supplier<String> versionSupplier,
                   Supplier<File> fileSupplier) {
    this.ctx = ctx;
    this.versionSupplier = versionSupplier;
    this.fileSupplier = fileSupplier;
    this._log = ctx.logManager().getLog(WinUpdateProcess.class);
  }

  private File workDir() throws IOException {
    if (ctx != null) {
      File workDir =
          new File(ctx.getConfigDir().getAbsolutePath(), "i2p_update_win");
      if (workDir.exists()) {
        if (workDir.isFile())
          throw new IOException(workDir +
                                " exists but is a file, get it out of the way");
        return workDir;
      } else {
        workDir.mkdirs();
      }
      return workDir;
    }
    return null;
  }

  private void runUpdateInstaller() throws IOException {
    String version = versionSupplier.get();
    File file = fileSupplier.get();
    if (file == null)
      return;

    File workingDir = workDir();
    File logFile = new File(workingDir, "log-" + version + ".txt");

    // check if we can write to the log file. If we can, use the
    // ProcessBuilder to run the installer.
    ProcessBuilder pb = new ProcessBuilder(
        file.getAbsolutePath(), "/S", "/D=" + workingDir.getAbsolutePath());
    Map<String, String> env = pb.environment();
    env.put("OLD_I2P_VERSION", version);
    env.remove("RESTART_I2P");

    int exitCode = ctx.router().scheduledGracefulExitCode();
    if (exitCode == Router.EXIT_HARD_RESTART ||
        exitCode == Router.EXIT_GRACEFUL_RESTART)
      env.put("RESTART_I2P", "true");

    try {
      Process p = pb.directory(workingDir)
                      .redirectErrorStream(true)
                      .redirectOutput(logFile)
                      .start();
      exitCode = p.waitFor();
      if (exitCode != 0)
        _log.error("Update failed with exit code " + exitCode + " see " +
                   logFile.getAbsolutePath() + " for more details");
    } catch (IOException ex) {
      _log.error(
          "Unable to run update program in background. Update will fail.", ex);
    } catch (InterruptedException ex) {
      _log.error(
          "Unable to run update program in background. Update will fail.", ex);
    }
  }

  @Override
  public void run() {
    try {
      runUpdateInstaller();
    } catch (IOException ioe) {
      _log.error("Error running updater, update may fail." + ioe);
    }
  }
}
