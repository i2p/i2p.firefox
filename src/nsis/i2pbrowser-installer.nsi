# This now requires v3
UniCode true

!define APPNAME "i2peasy"
!define COMPANYNAME "I2P"
!define DESCRIPTION "This is a tool which contains an I2P router, a bundled JVM, and a tool for automatically configuring a browser to use with I2P."
!define I2P_MESSAGE "Please choose a directory."
!define LAUNCH_TEXT "Start I2P?"
!define LICENSE_TITLE "Many Licenses"
!define CONSOLE_URL "http://127.0.0.1:7657/home"

!include i2pbrowser-version.nsi
!include i2pbrowser-jpackage.nsi
!include FindProcess.nsh

#var INSTDIR

SetOverwrite on

!define INSTDIR
!define I2PINSTEXE_USERMODE "$LOCALAPPDATA\${APPNAME}"

!define RAM_NEEDED_FOR_64BIT 0x80000000

InstallDir $LOCALAPPDATA\${APPNAME}

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "licenses\LICENSE.txt"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
Icon ui2pbrowser_icon.ico
OutFile "I2P-Easy-Install-Bundle-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.exe"

RequestExecutionLevel user

!include LogicLib.nsh
!include x64.nsh
!include FileFunc.nsh
!define MUI_ICON ui2pbrowser_icon.ico
!define MUI_FINISHPAGE
!include "MUI2.nsh"

### Available languages
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Esperanto"
  !insertmacro MUI_LANGUAGE "Basque"
  !insertmacro MUI_LANGUAGE "Welsh"
# Commented out languages below do not compile on NSIS v2
  !insertmacro MUI_LANGUAGE "Asturian"
  !insertmacro MUI_LANGUAGE "Pashto"
  !insertmacro MUI_LANGUAGE "ScotsGaelic"
  !insertmacro MUI_LANGUAGE "Georgian"
  !insertmacro MUI_LANGUAGE "Vietnamese"
  !insertmacro MUI_LANGUAGE "Armenian"
  !insertmacro MUI_LANGUAGE "Corsican"
  !insertmacro MUI_LANGUAGE "Tatar"
  !insertmacro MUI_LANGUAGE "Hindi"
### END LANGUAGES

# small speed optimization
!insertmacro MUI_RESERVEFILE_LANGDLL
# show all languages, regardless of codepage
!define MUI_LANGDLL_ALLLANGUAGES

PageEx license
    licensetext "${LICENSE_TITLE}"
    licensedata "licenses\LICENSE.txt"
PageExEnd
PageEx directory
    dirtext "${I2P_MESSAGE}"
    dirvar $INSTDIR
    PageCallbacks routerDetect
PageExEnd
Page instfiles

Function .onInit
    # Note: This is all redundant and I know it.
    # Admin installs have been migrated to user-mode installs.
    # But I'm leaving it because I might need it again if I support service installs.
    StrCpy $INSTDIR "${I2PINSTEXE_USERMODE}"
    UserInfo::GetAccountType
    pop $0
    ${If} $0 != "admin"
        StrCpy $INSTDIR "${I2PINSTEXE_USERMODE}"
    ${EndIf}
    !insertmacro MUI_LANGDLL_DISPLAY
    #Call ShouldInstall64Bit
    # look for user installs
FunctionEnd

Function routerDetect
    createDirectory $INSTDIR
    SetOutPath $INSTDIR\app
    File /a /r "I2P\app\"
    SetOutPath $INSTDIR\runtime
    File /a /r "I2P\runtime\"
    SetOutPath $INSTDIR\config
    File /a /r "I2P\config\"
    SetOutPath $INSTDIR
    File /a /r "I2P\I2P.exe"
    # The NSIS Installer uses an ico icon, the jpackage-only ones use png
    File /a /r "I2P\ui2pbrowser_icon.ico"

    createDirectory "$INSTDIR\"
    SetOutPath "$INSTDIR\"
    File  /a /r "I2P/config/certificates"
    File  /a /r "I2P/config/geoip"
FunctionEnd

Function installerFunction
    ${If} ${Silent}
        ${Do}
            ${FindProcess} "I2P.exe" $0
            Sleep 500
        ${LoopWhile} $0 <> 0
    ${EndIf}

    # set the installation directory as the destination for the following actions
    createDirectory $INSTDIR
    SetOutPath $INSTDIR
    File ui2pbrowser_icon.ico

    # Update jpackaged I2P router
    call routerDetect

    # Install the launcher scripts
    createDirectory "$INSTDIR"

    # Install the licenses
    createDirectory "$INSTDIR\licenses"
    SetOutPath "$INSTDIR\licenses"
    File /a /r "licenses/*"

    SetOutPath "$INSTDIR"
    createDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Browse I2P.lnk" "$INSTDIR\I2P.exe" "" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Browse I2P - Temporary Identity.lnk" "$INSTDIR\I2P.exe -private" "" "$INSTDIR\ui2pbrowser_icon.ico"

    CreateShortCut "$DESKTOP\Browse I2P.lnk" "$INSTDIR\I2P.exe" "" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$DESKTOP\Browse I2P - Temporary Identity.lnk" "$INSTDIR\I2P.exe -private" "" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall I2P Easy-Install Bundle.lnk" "$INSTDIR\uninstall-i2pbrowser.exe" "" "$INSTDIR\ui2pbrowser_icon.ico"
    SetOutPath "$INSTDIR"

    SetShellVarContext current

    IfFileExists "$INSTDIR\eepsite\docroot" +2 0
        File  /a /r "I2P\eepsite"

    createDirectory "$INSTDIR"
    SetOutPath "$INSTDIR"

    SetOutPath "$INSTDIR"
    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall-i2pbrowser.exe"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall I2P Easy-Install Bundle.lnk" "$INSTDIR\uninstall-i2pbrowser.exe" "" "$INSTDIR\ui2pbrowser_icon.ico"

FunctionEnd


# start default section
Section Install
    Call installerFunction
SectionEnd

# uninstaller section start
Section "uninstall"
    # Don't try to uninstall until the router is fully shut down.
    ${un.FindProcess} "I2P.exe" $0
    ${If} $0 <> 0
        MessageBox MB_OK "I2P is still running, uninstaller is paused. Uninstaller will continue after I2P has shut down."
        ${Do}
            ${un.FindProcess} "I2P.exe" $0
            Sleep 500
        ${LoopWhile} $0 <> 0
    ${EndIf}
    
    # Uninstall the launcher scripts
    rmDir /r "$INSTDIR\app"
    rmDir /r "$INSTDIR\config"
    rmDir /r "$INSTDIR\runtime"
    Delete "$INSTDIR\ui2pbrowser_icon.ico"
    Delete "$INSTDIR\windowsUItoopie2.png"
    Delete "$INSTDIR\I2P.exe"

    # Remove shortcuts and folders
    Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Private Browsing-${APPNAME}.lnk"
    Delete "$SMPROGRAMS\Uninstall-${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Browse I2P.lnk"
    Delete "$DESKTOP\Browse I2P - Temporary Identity.lnk"
    Delete "$DESKTOP\Browse I2P.lnk"
    Delete "$DESKTOP\${APPNAME}.lnk"
    Delete "$DESKTOP\Private Browsing-${APPNAME}.lnk"
    rmDir /r "$SMPROGRAMS\${APPNAME}"
    
    #### SUPER SUPER EXTRA IMPORTANT!
    ### RELATED: line 169
    ## IF YOU DO THIS WRONG YOU WILL BREAK CONFIGS:
    ## The purpose of the `jpackaged` file has changed, as has the point
    ## where it is created.
    # 1. The jpackaged file is now created only **after** the jpackage itself
    #  has migrated default configs into the $INSTDIR. IF THEY ALREADY EXIST,
    #  it WILL NOT BE CREATED, even if there is a jpackage present. This is
    #  intentional behavior.
    # 2. The jpackaged file now indicates that the configurations were created
    #  by running the jpackage, and not by an un-bundled router. If it is not
    #  present, then we have already deleted everything we are responsible for
    #  and don't need to do the section below.
    ${If} ${FileExists} "$INSTDIR\jpackaged"
        Delete $INSTDIR\*
        rmDir /r "$INSTDIR"
    ${EndIf}
    # delete the uninstaller
    Delete "$INSTDIR\uninstall-i2pbrowser.exe"
    # uninstaller section end
SectionEnd

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "${LAUNCH_TEXT}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_FINISH

Function LaunchLink
  SetOutPath "$INSTDIR"
  StrCpy $OUTDIR $INSTDIR
  ${If} ${Silent}
    ReadEnvStr $0 RESTART_I2P
    ${If} $0 != ""
        UserInfo::GetAccountType
        pop $0
        ${If} $0 == "admin"
            ShellExecAsUser::ShellExecAsUser "open" "$DESKTOP\Browse I2P.lnk"
        ${Else}
           ExecShell "" "$DESKTOP\Browse I2P.lnk"
        ${EndIf}
    ${EndIf}  
  ${Else}
    UserInfo::GetAccountType
    pop $0
    ${If} $0 == "admin"
        ShellExecAsUser::ShellExecAsUser "open" "$DESKTOP\Browse I2P.lnk"
    ${Else}
        ExecShell "" "$DESKTOP\Browse I2P.lnk"
    ${EndIf}
  ${EndIf}
FunctionEnd
