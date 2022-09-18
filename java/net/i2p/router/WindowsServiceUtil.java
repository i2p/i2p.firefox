package net.i2p.router;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/*
 * Provides querying of Windows services in order to discover I2P Routers
 * running as a service and avoid launching jpackaged routers redundantly.
 * It will prompt a user to start their I2P service if one is discovered.
 * 
 * see also:
 * https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/sc-query
 * https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicecontrollerstatus?view=dotnet-plat-ext-6.0
 * https://stackoverflow.com/questions/10604844/how-to-verify-whether-service-exists-in-services-msc C#, API ideas only
 * https://stackoverflow.com/questions/334471/need-a-way-to-check-status-of-windows-service-programmatically
 * https://stackoverflow.com/questions/5388888/find-status-of-windows-service-from-java-application
 * https://stackoverflow.com/questions/21566847/how-to-check-particular-windows-service-is-running-using
 * https://stackoverflow.com/questions/9792051/start-windows-service-with-java
 * 
 * There's a chance we can't tell ServiceController to do anything so if
 * that is the case then we'll just launch services.msc and tell the user to
 * take it from there.
 *
 * @author idk
 * @since 1.9.7
 */

public class WindowsServiceUtil {
  public WindowsServiceUtil() {}
  private String queryService(String serviceName) {
    String result = "";
    String line;
    ProcessBuilder pb = new ProcessBuilder("sc", "query", serviceName);
    try {
      Process p = pb.start();
      try {
        p.waitFor(); // wait for process to finish then continue.
        BufferedReader bri =
            new BufferedReader(new InputStreamReader(p.getInputStream()));
        while ((line = bri.readLine()) != null) {
          result += line;
        }
      } catch (InterruptedException e) {
      } catch (IOException e) {
      }
    } catch (IOException e) {
    }
    return result;
  }
  public String getServiceState(String serviceName) {
    String STATE_PREFIX = "STATE              : ";
    String s = queryService(serviceName);
    // check that the temp string contains the status prefix
    int ix = s.indexOf(STATE_PREFIX);
    String stateString = "uninstalled";
    if (ix >= 0) {
      // compare status number to one of the states
      String stateStr = s.substring(ix + STATE_PREFIX.length(),
                                    ix + STATE_PREFIX.length() + 1);
      int state = Integer.parseInt(stateStr);
      switch (state) {
      case (1): // service stopped
        stateString = "stopped";
        break;
      case (2): // service starting
        stateString = "starting";
        break;
      case (3): // don't know yet
        //stateString = "started";
        break;
      case (4): // service started
        stateString = "started";
        break;
      }
    }
    return stateString;
  }
}
