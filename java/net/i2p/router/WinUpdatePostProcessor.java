package net.i2p.router;

import static net.i2p.update.UpdateType.*;

import java.io.*;
import java.lang.InterruptedException;
import java.lang.Process;
import java.lang.ProcessBuilder;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.*;
import net.i2p.I2PAppContext;
import net.i2p.crypto.*;
import net.i2p.update.UpdatePostProcessor;
import net.i2p.update.UpdateType;
import net.i2p.util.Log;
import net.i2p.util.SystemVersion;

public class WinUpdatePostProcessor implements UpdatePostProcessor {
  private final Log _log;
  private final RouterContext ctx;
  private final AtomicBoolean hook = new AtomicBoolean();
  private final String fileName = "i2p-jpackage-update.exe";

  private volatile String version;

  private volatile File positionedFile = null;

  WinUpdatePostProcessor(RouterContext ctx) {
    this.ctx = ctx;
    this._log = ctx.logManager().getLog(WinUpdatePostProcessor.class);
  }

  public String getVersion() {
    return version;
  }

  public File getFile() {
    return positionedFile;
  }

  public void updateDownloadedandVerified(UpdateType type, int fileType,
      String version, File file)
      throws IOException {
    _log.info("Got an update to post-process");
    if (type != UpdateType.ROUTER_SIGNED_SU3 &&
        type != UpdateType.ROUTER_DEV_SU3) {
      _log.warn("Unsupported update type " + type);
      return;
    }
    if (SystemVersion.isWindows()) {

      if (fileType != SU3File.TYPE_EXE) {
        _log.warn("Unsupported file type " + fileType);
        return;
      }

      this.positionedFile = moveUpdateInstaller(file);
      this.version = version;

      if (!hook.compareAndSet(false, true)) {
        _log.info("shutdown hook was already set");
        return;
      }

      _log.info("adding shutdown hook");

      ctx.addFinalShutdownTask(
          new WinUpdateProcess(ctx, this::getVersion, this::getFile));
    } else {
      if (fileType == SU3File.TYPE_ZIP) {
        this.positionedFile = moveUpdateInstaller(file);
        this.version = version;

        if (!hook.compareAndSet(false, true)) {
          _log.info("shutdown hook was already set");
          return;
        }

        _log.info("adding shutdown hook");

        ctx.addFinalShutdownTask(
            new ZipUpdateProcess(ctx, this::getVersion, this::getFile));
      }
    }
  }

  private File moveUpdateInstaller(File file) throws IOException {
    if (this.ctx != null) {
      File newFile = new File(workDir(), fileName);
      boolean renamedStatus = file.renameTo(newFile);
      if (renamedStatus)
        return newFile;
      else
        throw new IOException(
            "WindowsUpdatePostProcesssor unable to move file to working directory, update will fail");
    }
    throw new IOException(
        "Router context not available to WindowsUpdatePostProcesssor, unable to find working directory, update will fail");
  }

  private File workDir() throws IOException {
    if (this.ctx != null) {
      File workDir = new File(this.ctx.getConfigDir().getAbsolutePath(), "i2p_update_win");
      if (workDir.exists()) {
        if (workDir.isFile())
          throw new IOException(workDir +
              " exists but is a file, get it out of the way");
        return null;
      } else {
        workDir.mkdirs();
      }
      return workDir;
    }
    return null;
  }
}