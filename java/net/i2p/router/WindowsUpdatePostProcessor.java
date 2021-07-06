package net.i2p.router;

import java.io.*;
import java.util.*;
import java.util.concurrent.TimeUnit;

import static net.i2p.update.UpdateType.*;
import net.i2p.update.UpdateType;
import net.i2p.update.UpdatePostProcessor;
import net.i2p.util.SystemVersion;

import java.lang.ProcessBuilder;
import java.lang.Process;
import java.lang.InterruptedException;

public class WindowsUpdatePostProcessor implements UpdatePostProcessor {
    protected Router i2pRouter = null;
    public void updateDownloadedandVerified(UpdateType type, int fileType, String version, File file) throws IOException {
        if (fileType == 6) {
            if (!runUpdateInstaller(file)) {
                i2pRouter.cancelGracefulShutdown();
            }
        }
    }

    private boolean runUpdateInstaller(File file){
        i2pRouter.shutdownGracefully();
        Process updateProcess = null;
        ProcessBuilder pb = new ProcessBuilder("cmd", "/c", file.getAbsolutePath(), "/S");
        while (i2pRouter.gracefulShutdownInProgress()) {
            try {
                TimeUnit.MILLISECONDS.sleep(125);
            } catch (InterruptedException ex) {
                return false;
            }
        }
        if (i2pRouter.isFinalShutdownInProgress()) {
            try {
                updateProcess = pb.start();
            } catch (IOException ex) {
               // At this point a failure is harmless, but it's also not at all important to
               // restart the router. Return false.
                return false;
            }
            return true;
        }
        return false;
    }

    protected File selectProgramFile() {
        if (SystemVersion.isWindows()) {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = jrehome.getParentFile();
            return programs.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), "i2p");
            return programs.getAbsoluteFile();
        }
    }

    protected File selectProgramFileExe() {
        File pfpath = selectProgramFile();
        if (SystemVersion.isWindows()) {
            File app = new File(pfpath, "I2P.exe");
            return app.getAbsoluteFile();
        } else {
            File app = new File(pfpath, "bin/I2P");
            return app.getAbsoluteFile();
        }
    }

}