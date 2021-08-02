@echo off

start "" "$I2PINSTEXE\i2p.exe"

if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\" (
  echo "profile is configured, updating extensions"
  xcopy /s /i /y "$INSTDIR\firefox.profile.i2p\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p\extensions"
) else (
  echo "configuring profile"
  xcopy /s /i /y "$INSTDIR\firefox.profile.i2p" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p"
)

start "" "$FFINSTEXE\firefox.exe" -no-remote -profile "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.i2p" -url %1

exit
