
set "I2PPath=%ProgramFiles%\I2P\"
if exist "%LocalAppData%\I2P\I2P.exe" (
  set "I2PPath=%LocalAppData%\I2P\"
)

if exist "%ProgramFiles%\I2P\" (
  set "I2PPath=%ProgramFiles%\I2P\"
)

if exist "%ProgramFiles(x86)%\I2P" (
  set "I2PPath=%ProgramFiles(x86)%\I2P"
)