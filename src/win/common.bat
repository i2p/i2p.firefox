@echo off

SET "MYPATH=%~dp0"

set ProgramFiles64=%ProgramFiles: (x86)=%
set "I2PData=%LocalAppData%\I2P\"

set I2PPath="%ProgramFiles%\I2P\"
if exist "%LocalAppData%\I2P\I2P.exe" (
  set "I2PPath=%LocalAppData%\I2P\"
)

if exist "%ProgramFiles64%\I2P\" (
  set "I2PPath=%ProgramFiles64%\I2P\"
)

if exist "%ProgramFiles(x86)%\I2P" (
  set "I2PPath=%ProgramFiles(x86)%\I2P\"
)
