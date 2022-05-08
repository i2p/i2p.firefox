@echo on

SET MYPATH=%~dp0

call %MYPATH%common.bat

call %MYPATH%copy-config-profile.bat

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
