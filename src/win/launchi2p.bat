@echo on

SET MYPATH=%~dp0
call "%MYPATH%common.bat"

echo "check if I2P is already running"
::only launch I2P if the proxy is not up on 4444
netstat /o /a /n | findstr "LISTENING" | findstr "7657" >nul 2>nul && (
  echo "I2P is already running, not launching"
) || (
  echo "I2P is not running, launching"
  echo start "i2p" /D "%I2PPath%" i2p.exe
  start "i2p" /D "%I2PPath%" i2p.exe
)


