package net.i2p.router;

import java.io.*;
import java.util.*;
import net.i2p.router.RouterLaunch;

/**
 * Launches a router from %PROGRAMFILES%/I2P using configuration data in
 * %LOCALAPPDATA%/I2P..  Uses Java 9 APIs.

 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config this points to the (read-write) config directory in local appdata
 * router.pid - the pid of the java process.
 */
public class WinLauncher {

    /** this is totally undocumented */
//    private static final String APP_PATH = "jpackage.app-path";
    private static final String LOCALAPPDATA = System.getenv("LOCALAPPDATA");

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

        try {
            // TODO: See if I need to do anything like this for Windows
            //System.load(resources.getAbsolutePath() + "/libMacLauncher.jnilib");
            //disableAppNap();
        } catch (Throwable bad) {
            // this is pretty bad - I2P is very slow if AppNap kicks in.
            // TODO: hook up to a console warning or similar.
            //bad.printStackTrace(); 
        }

        RouterLaunch.main(args);
    }

    private static File selectHome() throws Exception {
        File home = new File(System.getProperty("user.home"));
        File i2p;
        File appData = new File(home, "AppData");
        File local = new File(appData, "Local");
        i2p = new File(local, "I2P");
        return i2p.getAbsoluteFile();
    }

    private static File selectProgramFile() throws Exception {
        File programs = new File(System.getenv("ProgramFiles"));
        File i2p;
        i2p = new File(programs, "I2P");
        return i2p.getAbsoluteFile();
    }

}
