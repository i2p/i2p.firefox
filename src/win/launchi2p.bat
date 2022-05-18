@echo on

SET MYPATH=%~dp0
call "%MYPATH%common.bat"

echo "check if I2P is already running"
::only launch I2P if the proxy is not up on 4444
netstat /o /a | find /i "listening" | find ":4444" >nul 2>nul && (
  echo "I2P is already running, not launching"
) || (
  start "i2p" /D "%I2PData%" "%I2PPath%i2p.exe"
)


