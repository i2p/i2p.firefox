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
    private final File file;
    
    WinUpdateProcess(RouterContext ctx, Supplier<String> versionSupplier, File file) {
        this.ctx = ctx;
        this.versionSupplier = versionSupplier;
        this.file = file;
    }

    private void runUpdateInstaller(File file){
        String version = versionSupplier.get();

        var workingDir = new File(ctx.getConfigDir(), "mac_updates");
        var logFile = new File(workingDir, "log-" + version + ".txt");

        ProcessBuilder pb = new ProcessBuilder(file.getAbsolutePath());
        var env = pb.environment();
        env.put("OLD_I2P_VERSION", version);
        env.remove("RESTART_I2P");

        int exitCode = ctx.router().scheduledGracefulExitCode();
        if (exitCode == Router.EXIT_HARD_RESTART || exitCode == Router.EXIT_GRACEFUL_RESTART)
            env.put("RESTART_I2P", "true");

        try {
            pb.directory(workingDir).
                redirectErrorStream(true).
                redirectOutput(logFile).
                start();
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
