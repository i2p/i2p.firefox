@echo on

SET MYPATH=%~dp0
call "%MYPATH%common.bat"

::only launch I2P if the proxy is not up on 4444
netstat /o /a | find /i "listening" | find ":4444" >nul 2>nul && (
  echo "I2P is already running, not launching"
) || (
  if exist "%I2PPath%jpackaged" (
    cd "%LOCALAPPDATA%\I2P" & start "i2p" /D "%LOCALAPPDATA%\I2P" "%I2PPath%\i2p.exe"
  ) else (
    start "i2p" "%I2PPath%\i2p.exe"
  )
)


