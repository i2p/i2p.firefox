# uncomment on v3
# UniCode true

!define APPNAME "I2PBrowser-Launcher"
!define COMPANYNAME "I2P"
!define DESCRIPTION "This launches Firefox with a browser profile pre-configured to use i2p"
!define FIREFOX_MESSAGE "Could not find Firefox.  Please point to where you have installed Firefox.  If you have not installed Firefox yet, exit this installer and install Firefox, then start this installer again."
!define I2P_MESSAGE "Could not find I2P.  Please point to where you have installed I2P.  If you have not installed I2P yet, exit this installer and install I2P, then start this installer again."
!define LAUNCH_TEXT "Launch the i2p browser?"
!define LICENSE_TITLE "Many Licenses"
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
LicenseData "licenses\LICENSE.index"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
Icon ui2pbrowser_icon.ico
OutFile "I2P-Profile-Installer-${VERSIONMAJOR}.${VERSIONMINOR}${VERSIONBUILD}.exe"

RequestExecutionLevel admin

!include LogicLib.nsh
!include x64.nsh
!define MUI_ICON ui2pbrowser_icon.ico
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
    !insertmacro MUI_LANGDLL_DISPLAY
    Call ShouldInstall64Bit
    ${If} $0 == 1
        ${If} ${FileExists} "${FFINSTEXE64}/firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE64}"
	${ElseIf} ${FileExists} "${FFINSTEXE32}/firefox.exe"
	    StrCpy $FFINSTEXE "${FFINSTEXE32}"
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

    # Install the licenses
    createDirectory "$INSTDIR\licenses"
    SetOutPath "$INSTDIR\licenses"
    File /r licenses\*.*

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

    # Remove the licenses
    rmDir /r "$INSTDIR\licenses"

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

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "${LAUNCH_TEXT}"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_FINISH

Function LaunchLink
  ExecShell "" "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
FunctionEnd
