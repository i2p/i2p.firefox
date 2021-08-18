package net.i2p.router;

import net.i2p.router.*;
import net.i2p.I2PAppContext;

import java.util.function.*;
import java.io.*;
import net.i2p.util.Log;

class WinUpdateProcess implements Runnable {
    private final RouterContext ctx;
    private final Supplier<String> versionSupplier;
    private final Supplier<File> fileSupplier;
    
    WinUpdateProcess(RouterContext ctx, Supplier<String> versionSupplier, Supplier<File> fileSupplier) {
        this.ctx = ctx;
        this.versionSupplier = versionSupplier;
        this.fileSupplier = fileSupplier;
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

    private void runUpdateInstaller() throws IOException {
        String version = versionSupplier.get();
	File file = fileSupplier.get();
	if (file == null)
	    return;

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
                System.out.println("Unable to run update-program in background. Update will fail.");
        }
    }

    @Override
    public void run() {
        try {
            runUpdateInstaller();
        } catch(IOException ioe) {
            System.out.println("Error running updater, update may fail." + ioe);
        }
    }
}
