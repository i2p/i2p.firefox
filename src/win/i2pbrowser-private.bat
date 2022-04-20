@echo on

set "I2PPath=%ProgramFiles%\I2P\"
if exist "%ProgramFiles%\I2P\" (
  set "I2PPath=%ProgramFiles%\I2P\"
)

if exist "%ProgramFiles(x86)%\I2P" (
  set "I2PPath=%ProgramFiles(x86)%\I2P"
)

set "I2PPath=%LocalAppData%\I2P\"
if exist "%LocalAppData%\I2P\I2P.exe" (
  set "I2PPath=%LocalAppData%\I2P\"
)

if exist "%I2PPath%\jpackaged" (
  cd "%LOCALAPPDATA%\I2P"
  start "i2p" /D "%LOCALAPPDATA%\I2P" "%I2PPath%\i2p.exe"
) else (
  start "i2p" "%I2PPath%\i2p.exe"
)

timeout /t 3

if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\" (
  echo "profile is configured, updating extensions"
  xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.i2p\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
) else (
  echo "configuring profile"
  xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.i2p" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
)

xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.i2p\user.js" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\user.js"
xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.i2p\prefs.js" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\prefs.js"

if exist "%USERPROFILE%/Desktop/Tor Browser/Browser/firefox.exe" (
  start "i2pbrowser" "%USERPROFILE%/Desktop/Tor Browser/Browser/firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p" -private-window about:blank
  exit
)

if exist "%USERPROFILE%/OneDrive/Desktop/Tor Browser/Browser/firefox.exe" (
  start "i2pbrowser" "%USERPROFILE%/OneDrive/Desktop/Tor Browser/Browser/firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p" -private-window about:blank
  exit
)

if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" (
  start "i2pbrowser" "%ProgramFiles%\Mozilla Firefox\firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p" -private-window about:blank
  exit
)

exit
