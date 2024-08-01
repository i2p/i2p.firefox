package net.i2p.router;

import java.io.File;
import java.io.IOException;
import javax.swing.JOptionPane;
import net.i2p.router.RouterContext;

public class I2PAppUtil extends WindowsAppUtil {

  public String ServiceUpdaterString() {
    return "http://tc73n4kivdroccekirco7rhgxdg5f3cjvbaapabupeyzrqwv5guq.b32.i2p/news.su3";
  }
  public String ServiceBackupUpdaterString() {
    return "http://dn3tvalnjz432qkqsvpfdqrwpqkw3ye4n4i2uyfr4jexvo3sp5ka.b32.i2p/news.su3";
  }
  public String ServiceStaticUpdaterString() {
    return "http://echelon.i2p/i2p/i2pupdate.sud,http://stats.i2p/i2p/i2pupdate.sud";
  }

  public String getProgramFilesInstall() {
    String programFiles = System.getenv("PROGRAMFILES");
    if (programFiles != null) {
      File programFilesI2P = new File(programFiles, "i2p/i2p.exe");
      if (programFilesI2P.exists())
        return programFilesI2P.getAbsolutePath();
    }
    String programFiles86 = System.getenv("PROGRAMFILES86");
    if (programFiles86 != null) {
      File programFiles86I2P = new File(programFiles86, "i2p/i2p.exe");
      if (programFiles86I2P.exists())
        return programFiles86I2P.getAbsolutePath();
    }
    return null;
  }

  public boolean checkProgramFilesInstall() {
    String programFiles = System.getenv("PROGRAMFILES");
    if (programFiles != null) {
      File programFilesI2P = new File(programFiles, "i2p/i2p.exe");
      if (programFilesI2P.exists())
        return true;
    }
    String programFiles86 = System.getenv("PROGRAMFILES86");
    if (programFiles86 != null) {
      File programFiles86I2P = new File(programFiles86, "i2p/i2p.exe");
      if (programFiles86I2P.exists())
        return true;
    }
    return false;
  }

  public boolean promptUserInstallStartIfAvailable() {
    if (osName() != "windows") {
      return true;
    }
    if (checkProgramFilesInstall()) {
      int a;
      String message =
          "It appears you have an existing, unbundled I2P rotuer installed.\n";
      message +=
          "However, it is not running yet. Please start it using the shortcut on the desktop.\n";
      message +=
          "If you click \"No\", the Easy-Install router will be launched instead.\n";
      a = JOptionPane.showConfirmDialog(null, message,
                                        "I2P Service detected not running",
                                        JOptionPane.YES_NO_OPTION);
      if (a == JOptionPane.NO_OPTION) {
        // Do nothing here, this will continue on to launch a jpackaged router
        return true;
      } else {
        try {
          String pfi = getProgramFilesInstall();
          if (pfi != null)
            Runtime.getRuntime().exec(new String[] {pfi});
        } catch (IOException e) {
          return false;
        }
        return true;
      }
    }
    return true;
  }

}
