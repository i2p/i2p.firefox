@echo on

if not exist "%ProgramFiles%\I2P\" (
  set ProgramFiles="C:\Program Files"
)

if exist "%ProgramFiles%\I2P\jpackaged" (
  start "i2p" /D "%LOCALAPPDATA%\I2P" "%ProgramFiles%\I2P\i2p.exe"
) else (
  start "i2p" "%ProgramFiles%\I2P\i2p.exe"
)

timeout /t 3

if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\" (
  echo "profile is configured, updating extensions"
  xcopy /s /i /y "%ProgramFiles%\I2P\I2PBrowser-Launcher\firefox.profile.i2p\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
) else (
  echo "configuring profile"
  xcopy /s /i /y "%ProgramFiles%\I2P\I2PBrowser-Launcher\firefox.profile.i2p" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
)

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
