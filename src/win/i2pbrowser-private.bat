@echo on

set "I2PPath=%ProgramFiles%\I2P\"
if exist "%ProgramFiles%\I2P\" (
  set "I2PPath=%ProgramFiles%\I2P\"
)

if exist "%ProgramFiles(x86)%\I2P" (
  set "I2PPath=%ProgramFiles(x86)%\I2P"
)

netstat /o /a | find /i "listening" | find ":7657" >nul 2>nul && (
   echo I2P is already running
) || (
  if exist "%ProgramFiles%\I2P\jpackaged" (
    start "i2p" /D "%LOCALAPPDATA%\I2P" "%I2PPath%\i2p.exe"
  ) else (
    start "i2p" "%I2PPath%\i2p.exe"
  )
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
