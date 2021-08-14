package net.i2p.router;

import net.i2p.router.*;
import net.i2p.I2PAppContext;

import java.util.function.*;
import java.io.*;
import net.i2p.util.Log;

class WinUpdateProcess implements Runnable {
    private final Log _log = I2PAppContext.getGlobalContext().logManager().getLog(WinUpdateProcess.class);
    private final RouterContext ctx;
    private final Supplier<String> versionSupplier;
    private final File file = null;
    
    WinUpdateProcess(RouterContext ctx, Supplier<String> versionSupplier, File file) {
        this.ctx = ctx;
        this.versionSupplier = versionSupplier;
    }

    private void runUpdateInstaller(File file){
        ProcessBuilder pb = new ProcessBuilder("cmd", "/c", file.getAbsolutePath(), "/S");
        try {
            pb.start();
        } catch (IOException ex) {
            if (_log.shouldWarn())
                _log.warn("Unable to run update-program in background. Update will fail.");
        }
    }

    @Override
    public void run() {
        runUpdateInstaller(file);
    }
}
