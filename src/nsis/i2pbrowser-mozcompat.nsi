; This Source Code Form is subject to the terms of the Mozilla Public
; License, v. 2.0. If a copy of the MPL was not distributed with this
; file, You can obtain one at http://mozilla.org/MPL/2.0/.

; Returns 1 in $0 if we should install the 64-bit build, or 0 if not.
; The requirements for selecting the 64-bit build to install are:
; 1) Running a 64-bit OS (we've already checked the OS version).
; 2) An amount of RAM strictly greater than RAM_NEEDED_FOR_64BIT
; 3) No third-party products installed that cause issues with the 64-bit build.
;    Currently this includes Lenovo OneKey Theater and Lenovo Energy Management.
Function ShouldInstall64Bit
    StrCpy $0 0

    ${IfNot} ${RunningX64}
    Return
    ${EndIf}

    System::Call "*(i 64, i, l 0, l, l, l, l, l, l)p.r1"
    System::Call "Kernel32::GlobalMemoryStatusEx(p r1)"
    System::Call "*$1(i, i, l.r2, l, l, l, l, l, l)"
    System::Free $1
    ${If} $2 L<= ${RAM_NEEDED_FOR_64BIT}
    Return
    ${EndIf}

    ; Lenovo OneKey Theater can theoretically be in a directory other than this
    ; one, because some installer versions let you change it, but it's unlikely.
    ${If} ${FileExists} "$PROGRAMFILES32\Lenovo\Onekey Theater\windowsapihookdll64.dll"
    Return
    ${EndIf}

    ${If} ${FileExists} "$PROGRAMFILES32\Lenovo\Energy Management\Energy Management.exe"
    Return
    ${EndIf}

    StrCpy $0 1
FunctionEnd
