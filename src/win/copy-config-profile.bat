
if exist "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p\" (
  echo "profile is configured"
  xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.config.i2p\extensions" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p\extensions"
) else (
  echo "configuring profile"
  xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.config.i2p" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p"
)

xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.config.i2p\user.js" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p\user.js"
xcopy /s /i /y "%I2PPath%\I2PBrowser-Launcher\firefox.profile.config.i2p\prefs.js" "%LOCALAPPDATA%\I2PBrowser-Launcher\firefox.profile.config.i2p\prefs.js"
