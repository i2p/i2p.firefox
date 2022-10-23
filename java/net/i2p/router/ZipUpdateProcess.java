package net.i2p.router;

import java.io.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;
import java.util.function.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import net.i2p.I2PAppContext;
import net.i2p.router.*;
import net.i2p.util.Log;

public class ZipUpdateProcess implements Runnable {
  private final RouterContext ctx;
  private final Supplier<String> versionSupplier;
  private final Supplier<File> fileSupplier;
  private final Log _log;

  ZipUpdateProcess(RouterContext ctx, Supplier<String> versionSupplier,
                   Supplier<File> fileSupplier) {
    this.ctx = ctx;
    this.versionSupplier = versionSupplier;
    this.fileSupplier = fileSupplier;
    this._log = ctx.logManager().getLog(ZipUpdateProcess.class);
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

  private void unzipUpdateInstaller() throws IOException {
    String version = versionSupplier.get();
    File file = fileSupplier.get();
    if (file == null)
      return;

    File workingDir = workDir();
    File zipFile = new File(workingDir, "i2pupdate_portable.zip");
    File destDir = ctx.getConfigDir();

    String errors = unzip(zipFile.getAbsolutePath(), destDir.getAbsolutePath());
    _log.error(errors);
  }

  @Override
  public void run() {
    try {
      unzipUpdateInstaller();
    } catch (IOException ioe) {
      _log.error("Error running updater, update may fail." + ioe);
    }
  }

  // copied wholesale from this example:
  // https://www.digitalocean.com/community/tutorials/java-unzip-file-example
  // It doesn't check for zip-slips, but that's fine because if somebody's able
  // to deliver a malicious update then they can just run code anyway so there's
  // no point.
  private static String unzip(String zipFilePath, String destDir) {
    File dir = new File(destDir);
    // create output directory if it doesn't exist
    if (!dir.exists())
      dir.mkdirs();
    FileInputStream fis;
    // buffer for read and write data to file
    byte[] buffer = new byte[1024];
    try {
      fis = new FileInputStream(zipFilePath);
      ZipInputStream zis = new ZipInputStream(fis);
      ZipEntry ze = zis.getNextEntry();
      while (ze != null) {
        String fileName = ze.getName();
        File newFile = new File(destDir + File.separator + fileName);
        System.out.println("Unzipping to " + newFile.getAbsolutePath());
        // create directories for sub directories in zip
        new File(newFile.getParent()).mkdirs();
        FileOutputStream fos = new FileOutputStream(newFile);
        int len;
        while ((len = zis.read(buffer)) > 0) {
          fos.write(buffer, 0, len);
        }
        fos.close();
        // close this ZipEntry
        zis.closeEntry();
        ze = zis.getNextEntry();
      }
      // close last ZipEntry
      zis.closeEntry();
      zis.close();
      fis.close();
    } catch (IOException e) {
      return e.toString();
    }
    return null;
  }
}
