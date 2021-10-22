@echo on

if exist "%ProgramFiles%\I2P\" (
  set "I2PPath=%ProgramFiles%\I2P\"
  set "I2PProfilePath=%ProgramFiles%\I2P\I2PBrowser-Launcher\firefox.profile.i2p"
  if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\" (
    echo "profile is configured, updating extensions"
    xcopy /s /i /y "%I2PProfilePath%\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
  ) else (
    echo "configuring profile"
    xcopy /s /i /y "%I2PProfilePath%" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
  )
  set "I2PProfilePath=%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
)

if exist "%ProgramFiles(x86)%\I2P\" {
  set "I2PPath=%ProgramFiles(x86)%\I2P"
  set "I2PProfilePath=%ProgramFiles%\I2P\I2PBrowser-Launcher\firefox.profile.i2p"
  if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\" (
    echo "profile is configured, updating extensions"
    xcopy /s /i /y "%I2PProfilePath%\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
  ) else (
    echo "configuring profile"
    xcopy /s /i /y "%I2PProfilePath%" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
  )
  set "I2PProfilePath=%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
}

set "scriptPath=%~dp0"
if exist "%scriptPath%\I2P\" (
  set "I2PPath=%scriptPath%\I2P\"
  set "I2PProfilePath=%scriptPath%\"
  set "PortableArg=portable"
)

if exist "%I2PPath%\jpackaged" (
  start "i2p" /D "%LOCALAPPDATA%\I2P" "%I2PPath%\i2p.exe" "%PortableArg%"
) else (
  start "i2p" "%I2PPath%\i2p.exe"
)

timeout /t 3

if exist "%USERPROFILE%/Desktop/Tor Browser/Browser/firefox.exe" (
  start "i2pbrowser" "%USERPROFILE%/Desktop/Tor Browser/Browser/firefox.exe" -no-remote -profile "%I2PProfilePath%" -private-window about:blank
  exit
)

if exist "%USERPROFILE%/OneDrive/Desktop/Tor Browser/Browser/firefox.exe" (
  start "i2pbrowser" "%USERPROFILE%/OneDrive/Desktop/Tor Browser/Browser/firefox.exe" -no-remote -profile "%I2PProfilePath%" -private-window about:blank
  exit
)

if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" (
  start "i2pbrowser" "%ProgramFiles%\Mozilla Firefox\firefox.exe" -no-remote -profile "%I2PProfilePath%" -private-window about:blank
  exit
)

exit
