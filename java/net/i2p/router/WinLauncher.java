package net.i2p.router;

import java.io.*;
import java.util.*;

import net.i2p.app.ClientAppManager;
import net.i2p.router.RouterLaunch;
import net.i2p.router.Router;
import net.i2p.update.UpdateManager;
import net.i2p.update.UpdatePostProcessor;
import net.i2p.util.SystemVersion;

import static net.i2p.update.UpdateType.*;

/**
 * Launches a router from %PROGRAMFILES%/I2P using configuration data in
 * %LOCALAPPDATA%/I2P..  Uses Java 9 APIs.

 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config this points to the (read-write) config directory in local appdata
 * router.pid - the pid of the java process.
 */
public class WinLauncher {
    private static WindowsUpdatePostProcessor wupp = new WindowsUpdatePostProcessor();
    public static void main(String[] args) throws Exception {
        File programs = wupp.selectProgramFile();

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
        System.out.println("\t"+System.getProperty("i2p.dir.base") +"\n\t"+System.getProperty("i2p.dir.config")+"\n\t"+ System.getProperty("router.pid"));

        wupp.i2pRouter = new Router(System.getProperties());
        System.out.println("Router is configured");

        UpdateManager upmgr = updateManagerClient();
        while (upmgr == null) {
            upmgr = updateManagerClient();
            System.out.println("Waiting for update manager so we can pull our own updates");
        }
        upmgr.register(wupp, ROUTER_SIGNED_SU3, 6);
        System.out.println("Registered signed updates");
        upmgr.register(wupp, ROUTER_DEV_SU3, 6);
        System.out.println("Registered dev updates");

        wupp.i2pRouter.runRouter();
    }

    private static File selectHome() { //throws Exception {
        if (SystemVersion.isWindows()) {
            File home = new File(System.getProperty("user.home"));
            File appData = new File(home, "AppData");
            File local = new File(appData, "Local");
            File i2p;
            i2p = new File(local, "I2P");
            System.out.println("Windows jpackage wrapper started, using: " + i2p + "as config");
            return i2p.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), ".i2p");
            System.out.println("Linux portable jpackage wrapper started, using: " + programs + "as config");
            return programs.getAbsoluteFile();
        }
    }

    private static UpdateManager updateManagerClient() {
        ClientAppManager clmgr = wupp.i2pRouter.getContext().getCurrentContext().clientAppManager();
        if (clmgr == null) {
            return null;
        }

        UpdateManager upmgr = (UpdateManager) clmgr.getRegisteredApp(UpdateManager.APP_NAME);
        if (upmgr == null) {
            return null;
        }

        return upmgr;
    }

}
