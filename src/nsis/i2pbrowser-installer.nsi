!define APPNAME "I2PBrowser-Launcher"
!define COMPANYNAME "I2P"
!define DESCRIPTION "This launches Firefox with a browser profile pre-configured to use i2p"
!define FIREFOX_MESSAGE "Select the location of your Firefox installation."
!define I2P_MESSAGE "Select the location of your i2p installation."
!define LAUNCH_TEXT "Launch the i2p browser?"
!define LICENSE_TITLE "MIT License"
!define CONSOLE_URL "http://127.0.0.1:7657/home"

!include i2pbrowser-version.nsi

var FFINSTEXE
var I2PINSTEXE

!define FFINSTEXE
!define FFINSTEXE32 "$PROGRAMFILES32\Mozilla Firefox\"
!define FFINSTEXE64 "$PROGRAMFILES64\Mozilla Firefox\"

!define I2PINSTEXE
!define I2PINSTEXE32 "$PROGRAMFILES32\i2p\"
!define I2PINSTEXE64 "$PROGRAMFILES64\i2p\"

!define RAM_NEEDED_FOR_64BIT 0x80000000

InstallDir "$PROGRAMFILES\${COMPANYNAME}\${APPNAME}"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "license-all.txt"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
Icon "ui2pbrowser_icon.ico"
OutFile "install.exe"

RequestExecutionLevel admin

!include LogicLib.nsh
!include x64.nsh

PageEx license
    licensetext "${LICENSE_TITLE}"
    licensedata "license-all.txt"
PageExEnd
PageEx directory
    dirtext "${FIREFOX_MESSAGE}"
    dirvar $FFINSTEXE
    PageCallbacks firefoxDetect
PageExEnd
Page instfiles
PageEx directory
    dirtext "${I2P_MESSAGE}"
    dirvar $I2PINSTEXE
    PageCallbacks routerDetect
PageExEnd


!include i2pbrowser-mozcompat.nsi

Function .onInit
    Call ShouldInstall64Bit
    ${If} $0 == 1
        ${If} ${FileExists} "${FFINSTEXE64}/firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE64}"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE/OneDrive/Desktop/Tor Browser/Browser/firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE/OneDrive/Desktop/Tor Browser/Browser/"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE/Desktop/Tor Browser/Browser/firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE/Desktop/Tor Browser/Browser/"
        ${EndIf}
    ${Else}
        ${If} ${FileExists} "${FFINSTEXE32}/firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE32}"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE/OneDrive/Desktop/Tor Browser/Browser/firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE/OneDrive/Desktop/Tor Browser/Browser/"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE/Desktop/Tor Browser/Browser/firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE/Desktop/Tor Browser/Browser/"
        ${EndIf}
    ${EndIf}
    ${If} ${FileExists} "${I2PINSTEXE32}/i2p.exe"
        StrCpy $I2PINSTEXE "${I2PINSTEXE32}"
    ${EndIf}
    ${If} ${FileExists} "${I2PINSTEXE64}/i2p.exe"
        StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
    ${EndIf}
FunctionEnd

Function firefoxDetect
    ${If} ${FileExists} "$FFINSTEXE/firefox.exe"
        Abort directory
    ${EndIf}
FunctionEnd

Function routerDetect
    ${If} ${FileExists} "$I2PINSTEXE/i2p.exe"
        Abort directory
    ${EndIf}
FunctionEnd

# start default section
Section Install

    # set the installation directory as the destination for the following actions
    createDirectory $INSTDIR
    SetOutPath $INSTDIR
    File ui2pbrowser_icon.ico

    # Install the launcher scripts: This will need to be it's own section, since
    # now I think we just need to let the user select if the user is using a non
    # default Firefox path.
    FileOpen $0 "$INSTDIR\i2pbrowser.bat" w
    FileWrite $0 "@echo off"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 'start "" "$FFINSTEXE\firefox.exe" -no-remote -profile "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p" -url %1'
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 exit
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

    FileOpen $0 "$INSTDIR\i2pbrowser-private.bat" w
    FileWrite $0 "@echo off"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 'start "" "$FFINSTEXE\firefox.exe" -no-remote -profile "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p" -private-window about:blank'
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 exit
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

    # Install the profile
    createDirectory "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p"
    SetOutPath "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p"
    File profile/user.js
    File profile/bookmarks.html

    # Install the extensions
    createDirectory "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions"
    SetOutPath "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions"
    File "profile/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
    File profile/extensions/https-everywhere-eff@eff.org.xpi

    SetOutPath "$INSTDIR"
    createDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser.bat$\" ${CONSOLE_URL}" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Private Browsing-${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser-private.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$DESKTOP\${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser.bat$\" ${CONSOLE_URL}" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$DESKTOP\Private Browsing-${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser-private.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"


    SetShellVarContext current
    !define I2PAPPDATA "$APPDATA\I2P\"

    SetOutPath "${I2PAPPDATA}"

    ;# Point the browser config setting
    FileOpen $0 "${I2PAPPDATA}\router.config" a
    FileSeek $0 0 END
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "routerconsole.browser=$\"$INSTDIR\i2pbrowser.bat$\""
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0

    SetOutPath "$INSTDIR"
    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall-i2pbrowser.exe"

    # create a shortcut to the uninstaller
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall-${APPNAME}.lnk" "$INSTDIR\uninstall-i2pbrowser.exe"

SectionEnd

# uninstaller section start
Section "uninstall"

    # Uninstall the launcher scripts
    Delete $INSTDIR\i2pbrowser.bat
    Delete $INSTDIR\i2pbrowser-private.bat
    Delete $INSTDIR\ui2pbrowser_icon.ico

    # Uninstall the profile
    Delete $LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\user.js
    Delete $LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\bookmarks.html

    # Uninstall the extensions
    Delete "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions\{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
    Delete "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions\https-everywhere-eff@eff.org.xpi"

    # Remove shortcuts and folders
    Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Private Browsing-${APPNAME}.lnk"
    Delete "$SMPROGRAMS\Uninstall-${APPNAME}.lnk"
    Delete "$DESKTOP\${APPNAME}.lnk"
    Delete "$DESKTOP\Private Browsing-${APPNAME}.lnk"
    rmDir "$SMPROGRAMS\${APPNAME}"
    rmDir "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions"
    rmDir "$LOCALAPPDATA\${APPNAME}\firefox.profile.i2p"
    rmDir "$LOCALAPPDATA\${APPNAME}"
    rmDir "$INSTDIR"

    # delete the uninstaller
    Delete "$INSTDIR\uninstall-i2pbrowser.exe"

    # uninstaller section end

SectionEnd

!include "MUI2.nsh"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "${LAUNCH_TEXT}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_FINISH

Function LaunchLink
  ExecShell "" "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
FunctionEnd
