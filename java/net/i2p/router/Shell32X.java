package net.i2p.router;

import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.Structure;
import com.sun.jna.WString;
import com.sun.jna.platform.win32.Shell32;
import com.sun.jna.platform.win32.WinDef.HINSTANCE;
import com.sun.jna.platform.win32.WinDef.HWND;
import com.sun.jna.platform.win32.WinNT.HANDLE;
import com.sun.jna.platform.win32.WinReg.HKEY;
import com.sun.jna.win32.W32APIOptions;
import java.util.*;

//TODO: This is obsolete. I don't know if a single user still has an admin-style install of this.
// it should be removed a the earliest convenient time.
public interface Shell32X extends Shell32 {
  Shell32X INSTANCE = (Shell32X)Native.loadLibrary(
      "shell32", Shell32X.class, W32APIOptions.UNICODE_OPTIONS);

  int SW_HIDE = 0;
  int SW_MAXIMIZE = 3;
  int SW_MINIMIZE = 6;
  int SW_RESTORE = 9;
  int SW_SHOW = 5;
  int SW_SHOWDEFAULT = 10;
  int SW_SHOWMAXIMIZED = 3;
  int SW_SHOWMINIMIZED = 2;
  int SW_SHOWMINNOACTIVE = 7;
  int SW_SHOWNA = 8;
  int SW_SHOWNOACTIVATE = 4;
  int SW_SHOWNORMAL = 1;

  /** File not found. */
  int SE_ERR_FNF = 2;

  /** Path not found. */
  int SE_ERR_PNF = 3;

  /** Access denied. */
  int SE_ERR_ACCESSDENIED = 5;

  /** Out of memory. */
  int SE_ERR_OOM = 8;

  /** DLL not found. */
  int SE_ERR_DLLNOTFOUND = 32;

  /** Cannot share an open file. */
  int SE_ERR_SHARE = 26;

  int SEE_MASK_NOCLOSEPROCESS = 0x00000040;

  int ShellExecute(int i, String lpVerb, String lpFile, String lpParameters,
                   String lpDirectory, int nShow);

  boolean ShellExecuteEx(SHELLEXECUTEINFO lpExecInfo);

  public static class SHELLEXECUTEINFO extends Structure {
    /*
     * DWORD cbSize;
     * ULONG fMask;
     * HWND hwnd;
     * LPCTSTR lpVerb;
     * LPCTSTR lpFile;
     * LPCTSTR lpParameters;
     * LPCTSTR lpDirectory;
     * int nShow;
     * HINSTANCE hInstApp;
     * LPVOID lpIDList;
     * LPCTSTR lpClass;
     * HKEY hkeyClass;
     * DWORD dwHotKey;
     * union {
     * HANDLE hIcon;
     * HANDLE hMonitor;
     * } DUMMYUNIONNAME;
     * HANDLE hProcess;
     */

    public int cbSize = size();
    public int fMask;
    public HWND hwnd;
    public WString lpVerb;
    public WString lpFile;
    public WString lpParameters;
    public WString lpDirectory;
    public int nShow;
    public HINSTANCE hInstApp;
    public Pointer lpIDList;
    public WString lpClass;
    public HKEY hKeyClass;
    public int dwHotKey;

    /*
     * Actually:
     * union {
     * HANDLE hIcon;
     * HANDLE hMonitor;
     * } DUMMYUNIONNAME;
     */
    public HANDLE hMonitor;
    public HANDLE hProcess;

    protected List getFieldOrder() {
      return Arrays.asList(new String[] {
          "cbSize",
          "fMask",
          "hwnd",
          "lpVerb",
          "lpFile",
          "lpParameters",
          "lpDirectory",
          "nShow",
          "hInstApp",
          "lpIDList",
          "lpClass",
          "hKeyClass",
          "dwHotKey",
          "hMonitor",
          "hProcess",
      });
    }
  }
}
