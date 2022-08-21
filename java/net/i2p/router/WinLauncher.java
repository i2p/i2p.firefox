package net.i2p.router;

import java.io.*;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.*;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

import net.i2p.crypto.*;

import net.i2p.app.ClientAppManager;
import net.i2p.router.RouterLaunch;
import net.i2p.router.Router;
import net.i2p.update.UpdateManager;
import net.i2p.update.UpdatePostProcessor;
import net.i2p.util.SystemVersion;
import net.i2p.update.*;
import net.i2p.i2pfirefox.*;

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
    static Logger logger = Logger.getLogger("launcherlog");
    static FileHandler fh;

    public static void main(String[] args) throws Exception {
        try {
            // This block configure the logger with handler and formatter
            fh = new FileHandler(logFile().toString());
            logger.addHandler(fh);
            SimpleFormatter formatter = new SimpleFormatter();
            fh.setFormatter(formatter);
            // the following statement is used to log any messages
            logger.info("My first log");
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        boolean privateBrowsing = false;
        if (args != null && args.length > 0) {
            if (args[0].equals("-private")) {
                privateBrowsing = true;
                return;
            }
        }

        File programs = selectProgramFile();
        if (!programs.exists())
            programs.mkdirs();
        else if (!programs.isDirectory()) {
            logger.warning(programs + " exists but is not a directory. Please get it out of the way");
            System.exit(1);
        }

        File home = selectHome();
        if (!home.exists())
            home.mkdirs();
        else if (!home.isDirectory()) {
            logger.warning(home + " exists but is not a directory. Please get it out of the way");
            System.exit(1);
        }

        if (i2pIsRunning()) {
            logger.warning("I2P is already running");
            I2PFirefox i2pFirefox = new I2PFirefox();
            System.out.println("I2PFirefox");
            i2pFirefox.launch(privateBrowsing);
            return;
        }

        System.setProperty("i2p.dir.base", programs.getAbsolutePath());
        System.setProperty("i2p.dir.config", home.getAbsolutePath());
        System.setProperty("router.pid", String.valueOf(ProcessHandle.current().pid()));
        logger.info("\t" + System.getProperty("i2p.dir.base") + "\n\t" + System.getProperty("i2p.dir.config")
                + "\n\t" + System.getProperty("router.pid"));

        // wupp.i2pRouter = new Router(System.getProperties());
        logger.info("Router is configured");

        Thread registrationThread = new Thread(REGISTER_UPP);
        registrationThread.setName("UPP Registration");
        registrationThread.setDaemon(true);
        registrationThread.start();

        // wupp.i2pRouter.runRouter();
        RouterLaunch.main(args);
    }

    // see https://stackoverflow.com/questions/434718/sockets-discover-port-availability-using-java
    public static boolean isAvailable(int portNr) {
        boolean portFree;
        try (var ignored = new ServerSocket(portNr)) {
            portFree = true;
        } catch (IOException e) {
            portFree = false;
        }
        return portFree;
      }

    private static boolean i2pIsRunning() {
        // check if there's something listening on port 7657
        if (!isAvailable(7657)) {
            return true;
        }
        // check for the existence of router.ping file, if it's less then 2 minutes old,
        // exit
        File home = selectHome();
        File ping = new File(home, "router.ping");
        if (ping.exists()) {
            long diff = System.currentTimeMillis() - ping.lastModified();
            if (diff < 2 * 60 * 1000) {
                logger.info("router.ping exists and is less than 2 minutes old, I2P appears to be running already.");
                return true;
            }
        }
        return false;
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
        String path_override = System.getenv("I2P_CONFIG");
        if (path_override != null) {
            File path = new File(path_override);
            if (path != null && path.exists()) {
                if (path.isDirectory())
                    return path.getAbsoluteFile();
                else
                    throw new RuntimeException("I2P_CONFIG is not a directory: " + path);
            }
        }
        if (SystemVersion.isWindows()) {
            File home = new File(System.getProperty("user.home"));
            File appData = new File(home, "AppData");
            File local = new File(appData, "Local");
            File i2p;
            i2p = new File(local, "I2P");
            logger.info("Windows jpackage wrapper started, using: " + i2p + " as base config");
            return i2p.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), ".i2p");
            logger.info("Linux portable jpackage wrapper started, using: " + programs + " as base config");
            return programs.getAbsoluteFile();
        }
    }

    private static File selectProgramFile() {
        String path_override = System.getenv("I2P");
        if (path_override != null) {
            File path = new File(path_override);
            if (path.exists()) {
                if (path.isDirectory())
                    return path.getAbsoluteFile();
                else
                    throw new RuntimeException("I2P is not a directory: " + path);
            }
        }
        if (SystemVersion.isWindows()) {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = jrehome.getParentFile();
            logger.info("Windows portable jpackage wrapper found, using: " + programs + " as working config");
            return programs.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), "i2p");
            logger.info("Linux portable jpackage wrapper found, using: " + programs + " as working config");
            return programs.getAbsoluteFile();
        }
    }

    private static File logFile() {
        File log = new File(selectProgramFile(), "log");
        if (!log.exists())
            log.mkdirs();
        return new File(log, "launcher.log");
    }
}
