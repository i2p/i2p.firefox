package net.i2p.router;

import java.io.*;
import java.util.*;

import net.i2p.crypto.*;

import net.i2p.app.ClientAppManager;
import net.i2p.router.RouterLaunch;
import net.i2p.router.Router;
import net.i2p.update.UpdateManager;
import net.i2p.update.UpdatePostProcessor;
import net.i2p.util.SystemVersion;
import net.i2p.update.*;

import static net.i2p.update.UpdateType.*;

/**
 * Launches a router from %PROGRAMFILES%/I2P using configuration data in
 * %LOCALAPPDATA%/I2P.. Uses Java 9 APIs.
 * 
 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config this points to the (read-write) config directory in local
 * appdata
 * router.pid - the pid of the java process.
 */
public class WinLauncher {
    public static void main(String[] args) throws Exception {
        File programs = selectProgramFile();
        if (!programs.exists())
            programs.mkdirs();
        else if (!programs.isDirectory()) {
            System.err.println(programs + " exists but is not a directory. Please get it out of the way");
            System.exit(1);
        }

        File home = selectHome();
        if (!home.exists())
            home.mkdirs();
        else if (!home.isDirectory()) {
            System.err.println(home + " exists but is not a directory. Please get it out of the way");
            System.exit(1);
        }

        System.setProperty("i2p.dir.base", programs.getAbsolutePath());
        System.setProperty("i2p.dir.config", home.getAbsolutePath());
        System.setProperty("router.pid", String.valueOf(ProcessHandle.current().pid()));
        System.out.println("\t" + System.getProperty("i2p.dir.base") + "\n\t" + System.getProperty("i2p.dir.config")
                + "\n\t" + System.getProperty("router.pid"));

        // wupp.i2pRouter = new Router(System.getProperties());
        System.out.println("Router is configured");

        Thread registrationThread = new Thread(REGISTER_UPP);
        registrationThread.setName("UPP Registration");
        registrationThread.setDaemon(true);
        registrationThread.start();

        // wupp.i2pRouter.runRouter();
        RouterLaunch.main(args);
    }

    private static final Runnable REGISTER_UPP = () -> {

        // first wait for the RouterContext to appear
        RouterContext ctx;
        while ((ctx = (RouterContext) RouterContext.getCurrentContext()) == null) {
            sleep(1000);
        }

        // then wait for the update manager

        ClientAppManager cam;
        while ((cam = ctx.clientAppManager()) == null) {
            sleep(1000);
        }

        UpdateManager um;
        while ((um = (UpdateManager) cam.getRegisteredApp(UpdateManager.APP_NAME)) == null) {
            sleep(1000);
        }

        WindowsUpdatePostProcessor wupp = new WindowsUpdatePostProcessor(ctx);
        um.register(wupp, UpdateType.ROUTER_SIGNED_SU3, SU3File.TYPE_EXE);
        um.register(wupp, UpdateType.ROUTER_DEV_SU3, SU3File.TYPE_EXE);
    };

    private static void sleep(int millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException bad) {
            bad.printStackTrace();
            throw new RuntimeException(bad);
        }
    }

    private static File selectHome() { // throws Exception {
        String path_override = System.getenv("I2P");
        File path = new File(path_override);
        if (path.exists()) {
            if (path.isDirectory())
                return path.getAbsoluteFile();
            else
                throw new RuntimeException("I2P is not a directory: " + path);
        }
        if (SystemVersion.isWindows()) {
            File home = new File(System.getProperty("user.home"));
            File appData = new File(home, "AppData");
            File local = new File(appData, "Local");
            File i2p;
            i2p = new File(local, "I2P");
            System.out.println("Windows jpackage wrapper started, using: " + i2p + " as base config");
            return i2p.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), ".i2p");
            System.out.println("Linux portable jpackage wrapper started, using: " + programs + " as base config");
            return programs.getAbsoluteFile();
        }
    }

    private static File selectProgramFile() {
        String path_override = System.getenv("I2P_CONFIG");
        File path = new File(path_override);
        if (path.exists()) {
            if (path.isDirectory())
                return path.getAbsoluteFile();
            else
                throw new RuntimeException("I2P_CONFIG is not a directory: " + path);
        }
        if (SystemVersion.isWindows()) {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = jrehome.getParentFile();
            System.out.println("Windows portable jpackage wrapper found, using: " + programs + " as working config");
            return programs.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), "i2p");
            System.out.println("Linux portable jpackage wrapper found, using: " + programs + " as working config");
            return programs.getAbsoluteFile();
        }
    }
}
