package net.i2p.router;

import java.io.*;
import java.util.*;

import static net.i2p.update.UpdateType.*;
import net.i2p.update.UpdateType;
import net.i2p.util.SystemVersion;

import java.lang.ProcessBuilder;
import java.lang.Process;
import java.lang.InterruptedException;

public class WindowsUpdatePostProcessor {
    protected static Router i2pRouter = null;
    Process updateProcess = null;
    public void updateDownloadedandVerified(UpdateType type, int fileType, String version, File file) throws IOException {
        if (fileType == 6) {
            if (runUpdate(file)) {
                if (shutdownGracefullyAndRerun()) {
                }
            } else {
            }
        }
    }
    private boolean runUpdate(File file){
            ProcessBuilder pb = new ProcessBuilder("cmd", "/c", file.getAbsolutePath());
            try {
                updateProcess = pb.start();
            } catch (IOException ex) {
                // At this point a failure is harmless, but it's also not at all important to
                // restart the router. Return false.
                return false;
            }
            try {
                updateProcess.waitFor();
            } catch (InterruptedException ex) {
                // if the NSIS installer process got interrupted here, it's possible that the
                // install was left in a broken state. I think we should direct the uses to
                // re-run the installer if this happens. TODO: java dialog boxes. That should be
                // easy.
                return false;
            }
            return true;
    }
    private boolean shutdownGracefullyAndRerun() {
        i2pRouter.shutdownGracefully();
        ProcessBuilder pb = new ProcessBuilder("cmd", "/c", selectProgramFile().getAbsolutePath());
        while (i2pRouter.gracefulShutdownInProgress()){
        }
        if (i2pRouter.isFinalShutdownInProgress()){
            try {
                Process restartProcess = pb.start();
            } catch (IOException ex) {
                //
                return false;
            }
            return true;
        }
        return false;
    }

    protected static File selectProgramFile() {
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

}