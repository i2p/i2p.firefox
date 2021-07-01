package net.i2p.router;

import java.io.*;
import java.util.*;
import net.i2p.router.RouterLaunch;
import net.i2p.router.Router;
import net.i2p.util.SystemVersion;

/**
 * Launches a router from %PROGRAMFILES%/I2P using configuration data in
 * %LOCALAPPDATA%/I2P..  Uses Java 9 APIs.

 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config this points to the (read-write) config directory in local appdata
 * router.pid - the pid of the java process.
 */
public class WinLauncher extends WindowsUpdatePostProcessor {

    public static void main(String[] args) throws Exception {
        File programs = selectProgramFile();

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

        i2pRouter = new Router(System.getProperties());

        i2pRouter.runRouter();
    }

    private static File selectHome() { //throws Exception {
        if (SystemVersion.isWindows()) {
            File home = new File(System.getProperty("user.home"));
            File appData = new File(home, "AppData");
            File local = new File(appData, "Local");
            File i2p;
            i2p = new File(local, "I2P");
            return i2p.getAbsoluteFile();
        } else {
            File jrehome = new File(System.getProperty("java.home"));
            File programs = new File(jrehome.getParentFile().getParentFile(), ".i2p");
            return programs.getAbsoluteFile();
        }
    }

}
