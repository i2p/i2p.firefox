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
    
    private File workDir() throws IOException{
        if (ctx != null) {
            File workDir = new File(ctx.getConfigDir().getAbsolutePath(), "i2p_update_win");
            if (workDir.exists()) {
                if (workDir.isFile())
                    throw new IOException(workDir + " exists but is a file, get it out of the way");
                    return null;
            } else {
                workDir.mkdirs();
            }
            return workDir;
        }
        return null;
    }

    private void runUpdateInstaller(File file) throws IOException {
        String version = versionSupplier.get();

        var workingDir = workDir();
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
        try {
            runUpdateInstaller(file);
        } catch(IOException ioe) {
            _log.error("Error running updater, update may fail.", ioe);
        }
    }
}
