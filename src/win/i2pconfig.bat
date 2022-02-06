@echo off

if not exist "%LOCALAPPDATA%\I2P\eepsite\jetty.xml" (
  echo "Jetty files are missing, copying them..."
  xcopy "%PROGRAMFILES%\I2P\eepsite" "%LOCALAPPDATA%\I2P\eepsite" /y /s /i
)

if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p\" (
  echo "profile is configured"
  xcopy /s /i /y "$INSTDIR\firefox.profile.i2p\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
) else (
  echo "configuring profile"
  xcopy /s /i /y "$INSTDIR\firefox.profile.config.i2p" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p"
)

if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" (
  start "i2pbrowser" "%ProgramFiles%\Mozilla Firefox\firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p" -url %1
  exit
)

if exist "%USERPROFILE%/Desktop/Tor Browser/Browser/firefox.exe" (
  start "i2pbrowser" "%USERPROFILE%/Desktop/Tor Browser/Browser/firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p" -url %1
  exit
)

if exist "%USERPROFILE%/OneDrive/Desktop/Tor Browser/Browser/firefox.exe" (
  start "i2pbrowser" "%USERPROFILE%/OneDrive/Desktop/Tor Browser/Browser/firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p" -url %1
  exit
)

exit
