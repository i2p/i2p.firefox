# This now requires v3
UniCode true

!define APPNAME "I2PBrowser-Launcher"
!define COMPANYNAME "I2P"
!define DESCRIPTION "This launches Firefox with a browser profile pre-configured to use i2p"
!define LAUNCH_TEXT "Start I2P?"
!define LICENSE_TITLE "Many Licenses"
!define CONSOLE_URL "http://127.0.0.1:7657/home"

!include i2pbrowser-version.nsi
!include i2pbrowser-jpackage.nsi
!include FindProcess.nsh

var I2PINSTEXE
Var PARENTOPTIONS

SetOverwrite on
!define I2PINSTEXE
!define I2PINSTEXE32 "$PROGRAMFILES32\i2p"
!define I2PINSTEXE64 "$PROGRAMFILES64\i2p"
!define I2PINSTEXE_USERMODE "$LOCALAPPDATA\i2p"

InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "licenses\LICENSE.index"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
Icon ui2pbrowser_icon.ico
OutFile "I2P-Profile-Installer-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.exe"

RequestExecutionLevel user

!include LogicLib.nsh
!include x64.nsh
!include FileFunc.nsh

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
Page instfiles

!include i2pbrowser-mozcompat.nsi

Function .onInit
    StrCpy $INSTDIR "$LOCALAPPDATA\${COMPANYNAME}\${APPNAME}"
    StrCpy $I2PINSTEXE "${I2PINSTEXE_USERMODE}"
    ${If} ${FileExists} "${I2PINSTEXE32}\i2p.exe"
        StrCpy $I2PINSTEXE "${I2PINSTEXE32}"
    ${EndIf}
    ${If} ${FileExists} "${I2PINSTEXE64}\i2p.exe"
        StrCpy $I2PINSTEXE "${I2PINSTEXE64}"
    ${EndIf}
        
    !insertmacro MUI_LANGDLL_DISPLAY
    # look for user installs
FunctionEnd

# start default section
Section Install

    ${If} ${Silent}
        ${Do}
            ${FindProcess} "I2P.exe" $0
            Sleep 500
        ${LoopWhile} $0 <> 0
    ${EndIf}
    ${GetOptions} $CMDLINE "/p" $PARENTOPTIONS

    # set the installation directory as the destination for the following actions
    createDirectory $INSTDIR
    SetOutPath $INSTDIR
    File "I2P-Profile-Installer-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}-wrapped.exe"
    UserInfo::GetAccountType
    pop $0
    ${If} $I2PINSTEXE != "${I2PINSTEXE_USERMODE}"
        ExecShell open "powershell -Command Start-Process cmd -Verb RunAs -ArgumentList 'I2P-Profile-Installer-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}-wrapped.exe $PARENTOPTIONS'"
    ${Else}
        ExecShell open "I2P-Profile-Installer-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}-wrapped.exe $PARENTOPTIONS"
    ${EndIf}

    # create the uninstaller
    WriteUninstaller "$INSTDIR\uninstall-i2pbrowser-wrapper.exe"

    # create a shortcut to the uninstaller
    CreateShortCut "$SMPROGRAMS\${APPNAME}\Uninstall-${APPNAME}.lnk" "$INSTDIR\uninstall-i2pbrowser-wrapper.exe"

SectionEnd

# uninstaller section start
Section "uninstall"

    # Remove the licenses
    rmDir /r "$INSTDIR\"
    ExecShell runas "$INSTDIR\uninstall-i2pbrowser.exe"

    # uninstaller section end

SectionEnd
