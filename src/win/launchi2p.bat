
if exist "%I2PPath%\jpackaged" (
  cd "%LOCALAPPDATA%\I2P"
  start "i2p" /D "%LOCALAPPDATA%\I2P" "%I2PPath%\i2p.exe"
) else (
  start "i2p" "%I2PPath%\i2p.exe"
)
