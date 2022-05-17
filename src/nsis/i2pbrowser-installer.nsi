# This now requires v3
UniCode true

!define APPNAME "I2PBrowser-Launcher"
!define COMPANYNAME "I2P"
!define DESCRIPTION "This launches Firefox with a browser profile pre-configured to use i2p"
!define FIREFOX_MESSAGE "Could not find Firefox.  Please point to where you have installed Firefox.  If you have not installed Firefox yet, exit this installer and install Firefox, then start this installer again."
!define I2P_MESSAGE "Could not find I2P.  Please point to where you have installed I2P.  If you have not installed I2P yet, exit this installer and install I2P, then start this installer again."
!define LAUNCH_TEXT "Start I2P?"
!define LICENSE_TITLE "Many Licenses"
!define CONSOLE_URL "http://127.0.0.1:7657/home"

!include i2pbrowser-version.nsi
!include i2pbrowser-jpackage.nsi
!include FindProcess.nsh

var FFINSTEXE
var FFNONTORINSTEXE
var I2PINSTEXE

SetOverwrite on
!define FFINSTEXE
!define FFNONTORINSTEXE
!define FFINSTEXE32 "$PROGRAMFILES32\Mozilla Firefox\"
!define FFINSTEXE64 "$PROGRAMFILES64\Mozilla Firefox\"

!define I2PINSTEXE
!define I2PINSTEXE32 "$PROGRAMFILES32\i2p"
!define I2PINSTEXE64 "$PROGRAMFILES64\i2p"
!define I2PINSTEXE_USERMODE "$LOCALAPPDATA\i2p"


!define RAM_NEEDED_FOR_64BIT 0x80000000

InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "licenses\LICENSE.index"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
Icon ui2pbrowser_icon.ico
OutFile "I2P-Profile-Installer-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}-wrapped.exe"

RequestExecutionLevel user

!include LogicLib.nsh
!include x64.nsh
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
#  !insertmacro MUI_LANGUAGE "Asturian"
#  !insertmacro MUI_LANGUAGE "Pashto"
#  !insertmacro MUI_LANGUAGE "ScotsGaelic"
#  !insertmacro MUI_LANGUAGE "Georgian"
#  !insertmacro MUI_LANGUAGE "Vietnamese"
#  !insertmacro MUI_LANGUAGE "Armenian"
#  !insertmacro MUI_LANGUAGE "Corsican"
#  !insertmacro MUI_LANGUAGE "Tatar"
#  !insertmacro MUI_LANGUAGE "Hindi"
### END LANGUAGES

# small speed optimization
!insertmacro MUI_RESERVEFILE_LANGDLL
# show all languages, regardless of codepage
!define MUI_LANGDLL_ALLLANGUAGES

PageEx license
    licensetext "${LICENSE_TITLE}"
    licensedata "licenses\LICENSE.index"
PageExEnd
PageEx directory
    dirtext "${FIREFOX_MESSAGE}"
    dirvar $FFINSTEXE
    dirvar $FFNONTORINSTEXE
    PageCallbacks firefoxDetect
PageExEnd
PageEx directory
    dirtext "${I2P_MESSAGE}"
    dirvar $I2PINSTEXE
    PageCallbacks routerDetect
PageExEnd
Page instfiles

!include i2pbrowser-mozcompat.nsi

Function .onInit
    StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
    UserInfo::GetAccountType
    pop $0
    ${If} $0 != "admin"
        StrCpy $INSTDIR "$LOCALAPPDATA\${COMPANYNAME}\${APPNAME}"
        StrCpy $I2PINSTEXE "${I2PINSTEXE_USERMODE}"
    ${EndIf}
    !insertmacro MUI_LANGDLL_DISPLAY
    Call ShouldInstall64Bit
    ${If} $0 == 1
        ${If} ${FileExists} "${FFINSTEXE64}\firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE64}"
            StrCpy $FFNONTORINSTEXE "${FFINSTEXE64}"
    ${ElseIf} ${FileExists} "${FFINSTEXE32}\firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE32}"
            StrCpy $FFNONTORINSTEXE "${FFINSTEXE32}"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE\OneDrive\Desktop\Tor Browser\Browser\firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE\OneDrive\Desktop\Tor Browser\Browser\"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE\Desktop\Tor Browser\Browser\firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE\Desktop\Tor Browser\Browser\"
        ${EndIf}
    ${Else}
        ${If} ${FileExists} "${FFINSTEXE32}\firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE32}"
            StrCpy $FFNONTORINSTEXE "${FFINSTEXE32}"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE\OneDrive\Desktop\Tor Browser\Browser\firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE\OneDrive\Desktop\Tor Browser\Browser\"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE\Desktop\Tor Browser\Browser\firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE\Desktop\Tor Browser\Browser\"
        ${EndIf}
    ${EndIf}
    UserInfo::GetAccountType
    pop $0
    ${If} $0 == "admin"
        StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
        ${If} ${FileExists} "${I2PINSTEXE32}\i2p.exe"
            StrCpy $I2PINSTEXE "${I2PINSTEXE32}"
        ${EndIf}
        ${If} ${FileExists} "${I2PINSTEXE64}\i2p.exe"
            StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
        ${EndIf}
    ${EndIf}
    # look for user installs
FunctionEnd

Function firefoxDetect
    ${If} ${FileExists} "$FFINSTEXE\firefox.exe"
        Abort directory
    ${EndIf}
FunctionEnd

Function routerDetect
    ${If} ${FileExists} "$I2PINSTEXE"
        Abort directory
    ${Else}
        createDirectory $I2PINSTEXE
        SetOutPath $I2PINSTEXE
        File /nonfatal /a /r "I2P\"
        File /nonfatal /a /r "I2P\I2P.exe"
        File /nonfatal "I2P\config\jpackaged"

        createDirectory "$I2PINSTEXE\"
        SetOutPath "$I2PINSTEXE\"
        File /nonfatal /a /r "I2P/config/*"

        Abort directory
    ${EndIf}
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

    # Update jpackaged I2P router, if it exists
    ${If} ${FileExists} "$I2PINSTEXE\jpackaged"
        createDirectory $I2PINSTEXE
        SetOutPath $I2PINSTEXE

        ${If} ${Silent}
          ReadEnvStr $0 OLD_I2P_VERSION
          ${If} $0 < ${I2P_VERSION}
            File /nonfatal /a /r "I2P\"
            File /nonfatal "I2P\config\jpackaged"

            createDirectory "$I2PINSTEXE\"
            SetOutPath "$I2PINSTEXE\"
            File /nonfatal /a /r "I2P/config/*"

          ${EndIf}  
        ${Else}
          File /nonfatal /a /r "I2P\"
          File /nonfatal "I2P\config\jpackaged"

          createDirectory "$I2PINSTEXE\"
          SetOutPath "$I2PINSTEXE\"
          File /nonfatal /a /r "I2P/config/*"

        ${EndIf}
    ${EndIf}

    # Install the launcher scripts
    createDirectory "$INSTDIR"
    SetOutPath "$INSTDIR"
    File "win/*"

    # Install the licenses
    createDirectory "$INSTDIR\licenses"
    SetOutPath "$INSTDIR\licenses"
    File /a /r "licenses/*"

    # Install the profile
    createDirectory "$INSTDIR\firefox.profile.i2p"
    SetOutPath "$INSTDIR\firefox.profile.i2p"
    File /a /r "profile/*"

    # Install the config profile
    createDirectory "$INSTDIR\firefox.profile.config.i2p"
    SetOutPath "$INSTDIR\firefox.profile.config.i2p"
    File /a /r "app-profile/*"

    SetOutPath "$INSTDIR"
    createDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Browse I2P.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser.bat$\" ${CONSOLE_URL}" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Browse I2P - Temporary Identity.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser-private.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"
;    CreateShortCut "$SMPROGRAMS\${APPNAME}\I2P Applications.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pconfig.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"

    CreateShortCut "$DESKTOP\Browse I2P.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser.bat$\" ${CONSOLE_URL}" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$DESKTOP\Browse I2P - Temporary Identity.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser-private.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"
;    CreateShortCut "$DESKTOP\I2P Applications.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pconfig.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"

    ;# Point the browser config setting in the base router.config
    FileOpen $0 "$I2PINSTEXE\router.config" a
    FileSeek $0 0 END
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "routerconsole.browser=$\"$INSTDIR\i2pconfig.bat$\""
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "router.disableTunnelTesting=false"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

    SetShellVarContext current
    Var /Global I2PAPPDATA 

    IfFileExists "$I2PINSTEXE\clients.config" 0 +2
        StrCpy $I2PAPPDATA "$I2PINSTEXE"
    IfFileExists "$APPDATA\I2P\clients.config.d" 0 +2
        StrCpy $I2PAPPDATA "$APPDATA\I2P\"
    IfFileExists "$LOCALAPPDATA\I2P\clients.config.d" 0 +2
        StrCpy $I2PAPPDATA "$LOCALAPPDATA\I2P\"
    IfFileExists "$LOCALAPPDATA\I2P\clients.config" 0 +2
        StrCpy $I2PAPPDATA "$LOCALAPPDATA\I2P\"

    createDirectory "$I2PAPPDATA"
    SetOutPath "$I2PAPPDATA"

    IfFileExists "$LOCALAPPDATA\I2P\eepsite\docroot" +2 0
        File /nonfatal /a /r "I2P\eepsite"

    ;# Point the browser config setting in the working config
    FileOpen $0 "$I2PAPPDATA\router.config" a
    FileSeek $0 0 END
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "routerconsole.browser=$\"$INSTDIR\i2pconfig.bat$\""
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "router.disableTunnelTesting=false"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

    createDirectory "$I2PINSTEXE"
    SetOutPath "$I2PINSTEXE"

    SetOutPath "$INSTDIR"
    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall-i2pbrowser.exe"

    # create a shortcut to the uninstaller
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall-${APPNAME}.lnk" "$INSTDIR\uninstall-i2pbrowser.exe"
FunctionEnd

# start default section
Section Install
    Call installerFunction
SectionEnd

# uninstaller section start
Section "uninstall"

    # Remove the licenses
    rmDir /r "$INSTDIR\"

    # Uninstall the launcher scripts
    Delete $INSTDIR\i2pbrowser.bat
    Delete $INSTDIR\i2pconfig.bat
    Delete $INSTDIR\i2pbrowser-private.bat
    Delete $INSTDIR\ui2pbrowser_icon.ico

    # Remove shortcuts and folders
    Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Private Browsing-${APPNAME}.lnk"
    Delete "$SMPROGRAMS\Uninstall-${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Browse I2P.lnk"
    Delete "$DESKTOP\Browse I2P - Temporary Identity.lnk"
    Delete "$DESKTOP\Browse I2P.lnk"
    Delete "$DESKTOP\${APPNAME}.lnk"
    Delete "$DESKTOP\Private Browsing-${APPNAME}.lnk"
    rmDir "$SMPROGRAMS\${APPNAME}"
    rmDir "$INSTDIR\firefox.profile.i2p\extensions"
    rmDir "$INSTDIR\firefox.profile.i2p"
    rmDir "$LOCALAPPDATA\${APPNAME}"
    rmDir "$INSTDIR"
    
    ${If} ${FileExists} "$I2PINSTEXE\jpackaged"
        rmDir "$I2PINSTEXE"
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
  ${If} ${Silent}
    ReadEnvStr $0 RESTART_I2P
    ${If} $0 != ""
      ShellExecAsUser::ShellExecAsUser "open" "$DESKTOP\Browse I2P.lnk"
    ${EndIf}  
  ${Else}
    ShellExecAsUser::ShellExecAsUser "open" "$DESKTOP\Browse I2P.lnk"
  ${EndIf}
FunctionEnd
