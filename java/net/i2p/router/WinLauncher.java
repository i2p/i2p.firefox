package net.i2p.router;

import java.io.*;
import java.util.*;

/**
 * Launches a router from a Mac App Bundle.  Uses Java 9 APIs.
 * Sets the following properties:
 * i2p.dir.base - this points to the (read-only) resources inside the bundle
 * i2p.dir.config - this points to the folder the configuration files are located in
 * router.pid - the pid of the java process.
 */
public class WinLauncher {

    /** this is totally undocumented */
    private static final String APP_PATH = "jpackage.app-path";
    private static final String LOCALAPPDATA = System.getenv("LOCALAPPDATA");

    public static void main(String[] args) throws Exception {
        String path = System.getProperty(APP_PATH,"unknown");
        File f = new File(path);
        File contents = f.getParentFile().getParentFile();


        File resources = new File(contents, "Resources");
        File bundleLocation = contents.getParentFile().getParentFile();

        System.setProperty("i2p.dir.base", resources.getAbsolutePath());

        System.setProperty("router.pid", String.valueOf(ProcessHandle.current().pid()));

        try {
            //System.load(resources.getAbsolutePath() + "/libMacLauncher.jnilib");
            //disableAppNap();
        } catch (Throwable bad) {
            // this is pretty bad - I2P is very slow if AppNap kicks in.
            // TODO: hook up to a console warning or similar.
            //bad.printStackTrace(); 
        }

        RouterLaunch.main(args);
    }



}
