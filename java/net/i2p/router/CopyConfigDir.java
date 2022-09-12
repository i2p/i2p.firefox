package net.i2p.router;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

public class CopyConfigDir {

  public static boolean copyDirectory(String baseDir, String workDir) {
    File baseFile = new File(baseDir);
    File workFile = new File(workDir);
    return copyDirectory(baseFile, workFile);
  }
  
  public static boolean copyDirectory(File baseDir, File workDir) {
    for (File file : baseDir.listFiles()) {
      System.out.println(file.getAbsolutePath());
      if (file.isDirectory())
        copyDirectory(file, new File(workDir, file.toString()));
      if (file.isFile())
        copyFileNeverOverwrite(file, new File(workDir, file.toString()));
    }
    return true;
  }

  public static boolean copyConfigDirectory(File baseDir, File workDir) {
    for (File file : baseDir.listFiles()) {
      System.out.println(file.getAbsolutePath());
      if (file.isDirectory())
        copyDirectory(file, new File(workDir, file.toString()));
      if (file.isFile())
        copyFileNeverOverwrite(file, new File(workDir, file.toString()));
    }
    return true;
  }

  public static boolean copyFileNeverOverwrite(String basePath, String workPath) {
    File baseFile = new File(basePath);
    File workFile = new File(workPath);
    return copyFileNeverOverwrite(baseFile, workFile);
  }

  public static boolean copyFileNeverOverwrite(File basePath, File workPath) {
    return copyFile(basePath, workPath, false);
  }

  public static boolean copyFile(File basePath, File workPath, boolean overWrite) {
    if (!basePath.exists()) {
      return false;
    }
    if (!overWrite && workPath.exists()) {
      return false;
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
      return false;
    }
  }
}
