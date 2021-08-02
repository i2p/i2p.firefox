package net.i2p.router;

import java.io.*;
import java.util.*;
import java.util.concurrent.TimeUnit;

import static net.i2p.update.UpdateType.*;
import net.i2p.I2PAppContext;
import net.i2p.update.UpdateType;
import net.i2p.update.UpdatePostProcessor;
import net.i2p.util.Log;
import net.i2p.util.SystemVersion;

import java.lang.ProcessBuilder;
import java.lang.Process;
import java.lang.InterruptedException;


public class WindowsUpdatePostProcessor implements UpdatePostProcessor {
    private final Log _log = I2PAppContext.getGlobalContext().logManager().getLog(WindowsUpdatePostProcessor.class);
    protected static Router i2pRouter = null;

    public void updateDownloadedandVerified(UpdateType type, int fileType, String version, File file) throws IOException {
        if (fileType == 6) {
            File newFile = moveUpdateInstaller(file);
            runUpdateInstaller(newFile);
        }
    }

    private File moveUpdateInstaller(File file){
        RouterContext i2pContext = i2pRouter.getContext();
        if (i2pContext != null) {
            File appDir = i2pContext.getAppDir();
            File newFile = new File(i2pContext.getAppDir().getAbsolutePath(), file.getName());
            file.renameTo(newFile);
            return newFile;
        }
        return null;
    }

    private void runUpdateInstaller(File file){
        ProcessBuilder pb = new ProcessBuilder("cmd", "/c", file.getAbsolutePath(), "/S");
        try {
            pb.start();
        } catch (IOException ex) {
            if (_log.shouldWarn())
                _log.warn("Unable to loop update-program in background. Update will fail.");
        }
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