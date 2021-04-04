# This now requires v3
UniCode true

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
var FFNONTORINSTEXE
var I2PINSTEXE
var USERLOCALAPPDATA


!define FFINSTEXE
!define FFNONTORINSTEXE
!define FFINSTEXE32 "$PROGRAMFILES32\Mozilla Firefox\"
!define FFINSTEXE64 "$PROGRAMFILES64\Mozilla Firefox\"
!define USERLOCALAPPDATA "$LOCALAPPDATA"

!define I2PINSTEXE
!define I2PINSTEXE32 "$PROGRAMFILES32\i2p"
!define I2PINSTEXE64 "$PROGRAMFILES64\i2p"

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
    !insertmacro MUI_LANGDLL_DISPLAY
    Call ShouldInstall64Bit
    ${If} $0 == 1
        ${If} ${FileExists} "${FFINSTEXE64}/firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE64}"
            StrCpy $FFNONTORINSTEXE "${FFINSTEXE64}"
    ${ElseIf} ${FileExists} "${FFINSTEXE32}/firefox.exe"
            StrCpy $FFINSTEXE "${FFINSTEXE32}"
            StrCpy $FFNONTORINSTEXE "${FFINSTEXE32}"
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
            StrCpy $FFNONTORINSTEXE "${FFINSTEXE32}"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE/OneDrive/Desktop/Tor Browser/Browser/firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE/OneDrive/Desktop/Tor Browser/Browser/"
        ${EndIf}
        ${If} ${FileExists} "$PROFILE/Desktop/Tor Browser/Browser/firefox.exe"
            StrCpy $FFINSTEXE "$PROFILE/Desktop/Tor Browser/Browser/"
        ${EndIf}
    ${EndIf}
    StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
    ${If} ${FileExists} "${I2PINSTEXE32}"
        StrCpy $I2PINSTEXE "${I2PINSTEXE32}"
    ${EndIf}
    ${If} ${FileExists} "${I2PINSTEXE64}"
        StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
    ${EndIf}
FunctionEnd

Function firefoxDetect
    ${If} ${FileExists} "$FFINSTEXE/firefox.exe"
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
        File /nonfatal "I2P\config\jpackaged"

        createDirectory "$I2PINSTEXE\"
        SetOutPath "$I2PINSTEXE\"
        File /nonfatal "I2P\config\clients.config"
        File /nonfatal "I2P\config\i2ptunnel.config"
        File /nonfatal "I2P\config\wrapper.config"
        File /nonfatal "I2P\config\hosts.txt"


        createDirectory "$I2PINSTEXE\webapps\"
        SetOutPath "$I2PINSTEXE\webapps\"
        File /nonfatal /a /r "I2P\config\webapps\"

        createDirectory "$I2PINSTEXE\geoip\"
        SetOutPath "$I2PINSTEXE\geoip\"
        File /nonfatal /a /r "I2P\config\geoip\"

        createDirectory "$I2PINSTEXE\certificates\"
        SetOutPath "$I2PINSTEXE\certificates\"
        File /nonfatal /a /r "I2P\config\certificates\"

        Abort directory
    ${EndIf}
FunctionEnd

# start default section
Section Install

    # set the installation directory as the destination for the following actions
    createDirectory $INSTDIR
    SetOutPath $INSTDIR
    File ui2pbrowser_icon.ico

    # Update jpackaged I2P router, if it exists
    ${If} ${FileExists} "$I2PINSTEXE\jpackaged"
        createDirectory $I2PINSTEXE
        SetOutPath $I2PINSTEXE
        File /nonfatal /a /r "I2P\"
        File /nonfatal "I2P\config\jpackaged"

        createDirectory "$I2PINSTEXE\"
        SetOutPath "$I2PINSTEXE\"

        createDirectory "$I2PINSTEXE\webapps\"
        SetOutPath "$I2PINSTEXE\webapps\"
        File /nonfatal /a /r "I2P\config\webapps\"

        createDirectory "$I2PINSTEXE\geoip\"
        SetOutPath "$I2PINSTEXE\geoip\"
        File /nonfatal /a /r "I2P\config\geoip\"

        createDirectory "$I2PINSTEXE\certificates\"
        SetOutPath "$I2PINSTEXE\certificates\"
        File /nonfatal /a /r "I2P\config\certificates\"
    ${EndIf}

    # Install the launcher scripts: This will need to be it's own section, since
    # now I think we just need to let the user select if the user is using a non
    # default Firefox path.
    FileOpen $0 "$INSTDIR\i2pbrowser.bat" w
    FileWrite $0 "@echo off"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    ${If} ${FileExists} "$I2PINSTEXE\jpackaged"
        FileWrite $0 'start /D "$I2PINSTEXE\" "" "$I2PINSTEXE\i2p.exe"'
    ${Else}
        FileWrite $0 'start "" "$I2PINSTEXE\i2p.exe"'
    ${EndIf}
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 'start "" "$FFINSTEXE\firefox.exe" -no-remote -profile "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p" -url %1'
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
    ${If} ${FileExists} "$I2PINSTEXE\jpackaged"
        FileWrite $0 'start /D "$I2PINSTEXE\" "" "$I2PINSTEXE\i2p.exe"'
    ${Else}
        FileWrite $0 'start "" "$I2PINSTEXE\i2p.exe"'
    ${EndIf}
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 'start "" "$FFINSTEXE\firefox.exe" -no-remote -profile "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p" -private-window about:blank'
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 exit
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileClose $0


    # Install the launcher scripts: This will need to be it's own section, since
    # now I think we just need to let the user select if the user is using a non
    # default Firefox path.
    FileOpen $0 "$INSTDIR\i2pconfig.bat" w
    FileWrite $0 "@echo off"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    ${If} ${FileExists} "$I2PINSTEXE\jpackaged"
        FileWrite $0 'start /D "$I2PINSTEXE\" "" "$I2PINSTEXE\i2p.exe"'
    ${Else}
        FileWrite $0 'start "" "$I2PINSTEXE\i2p.exe"'
    ${EndIf}
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 'start "" "$FFNONTORINSTEXE\firefox.exe" -no-remote -profile "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p" -url %1'
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
    createDirectory "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p"
    SetOutPath "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p"
    File profile\user.js
    File profile\prefs.js
    File profile\bookmarks.html
    File profile\storage-sync.sqlite

    # Install the extensions
    createDirectory "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions"
    SetOutPath "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions"
    File "profile\extensions\{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
    File profile\extensions\https-everywhere-eff@eff.org.xpi
    File profile\extensions\i2ppb@eyedeekay.github.io.xpi

    # Install the config profile
    createDirectory "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p"
    SetOutPath "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p"
    File app-profile\user.js
    File app-profile\prefs.js
    File app-profile\bookmarks.html
    File app-profile\storage-sync.sqlite

    # Install the config extensions
    createDirectory "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\extensions"
    SetOutPath "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\extensions"
    File profile\extensions\https-everywhere-eff@eff.org.xpi
    File profile\extensions\i2ppb@eyedeekay.github.io.xpi

    # Install the config userChrome
    createDirectory "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\chrome"
    SetOutPath "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\chrome"
    File app-profile\chrome\userChrome.css

    SetOutPath "$INSTDIR"
    createDirectory "$SMPROGRAMS\${APPNAME}"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser.bat$\" ${CONSOLE_URL}" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Private Browsing-${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser-private.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$DESKTOP\${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser.bat$\" ${CONSOLE_URL}" "$INSTDIR\ui2pbrowser_icon.ico"
    CreateShortCut "$DESKTOP\Private Browsing-${APPNAME}.lnk" "C:\Windows\system32\cmd.exe" "/c $\"$INSTDIR\i2pbrowser-private.bat$\"" "$INSTDIR\ui2pbrowser_icon.ico"


    SetShellVarContext current
    Var /Global I2PAPPDATA 

    IfFileExists "$I2PINSTEXE\clients.config" 0 +2
        StrCpy $I2PAPPDATA "$I2PINSTEXE"
    IfFileExists "$APPDATA\I2P\clients.config.d" 0 +2
        StrCpy $I2PAPPDATA "$APPDATA\I2P\"
    IfFileExists "$USERLOCALAPPDATA\I2P\clients.config.d" 0 +2
        StrCpy $I2PAPPDATA "$USERLOCALAPPDATA\I2P\"
    IfFileExists "$USERLOCALAPPDATA\I2P\clients.config" 0 +2
        StrCpy $I2PAPPDATA "$USERLOCALAPPDATA\I2P\"


    createDirectory "$I2PAPPDATA"
    SetOutPath "$I2PAPPDATA"
    
    ;# Point the browser config setting
    FileOpen $0 "$I2PAPPDATA\router.config" a
    FileSeek $0 0 END
    FileWriteByte $0 "13"
    FileWriteByte $0 "10"
    FileWrite $0 "routerconsole.browser=$\"$INSTDIR\i2pconfig.bat$\""
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
    Delete $INSTDIR\i2pconfig.bat
    Delete $INSTDIR\i2pbrowser-private.bat
    Delete $INSTDIR\ui2pbrowser_icon.ico

    # Uninstall the profile
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\prefs.js
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\user.js
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\bookmarks.html
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\storage-sync.sqlite

    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\prefs.js
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\user.js
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\bookmarks.html
    Delete $USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\storage-sync.sqlite

    # Uninstall the extensions
    Delete "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions\{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi"
    Delete "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions\https-everywhere-eff@eff.org.xpi"
    Delete "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions\i2ppb@eyedeekay.github.io.xpi"

    Delete "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\extensions\https-everywhere-eff@eff.org.xpi"
    Delete "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\extensions\i2ppb@eyedeekay.github.io.xpi"

    Delete "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.config.i2p\config\userChrome.css"

    # Remove shortcuts and folders
    Delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
    Delete "$SMPROGRAMS\${APPNAME}\Private Browsing-${APPNAME}.lnk"
    Delete "$SMPROGRAMS\Uninstall-${APPNAME}.lnk"
    Delete "$DESKTOP\${APPNAME}.lnk"
    Delete "$DESKTOP\Private Browsing-${APPNAME}.lnk"
    rmDir "$SMPROGRAMS\${APPNAME}"
    rmDir "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p\extensions"
    rmDir "$USERLOCALAPPDATA\${APPNAME}\firefox.profile.i2p"
    rmDir "$USERLOCALAPPDATA\${APPNAME}"
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
