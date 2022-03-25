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

if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p\" (
  echo "profile is configured"
  xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.i2p\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
) else (
  echo "configuring profile"
  xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.config.i2p" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p"
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
