# Install script for Windows
# Place in: windows/installer/install.nsi

; CMG System Windows Installer
; Created with NSIS 3.08

!include "MUI2.nsh"
!include "x64.nsh"

; Basic Configuration
Name "CMG System v1.0.0"
OutFile "CMG_System_Installer.exe"
InstallDir "$PROGRAMFILES64\CMG System"
InstallDirRegKey HKLM "Software\CMG System" "Install_Dir"

; MUI Settings
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

; Installer sections
Section "Install"
  SetOutPath "$INSTDIR"
  File /r "..\..\build\windows\runner\Release\*.*"
  
  ; Create shortcuts
  CreateDirectory "$SMPROGRAMS\CMG System"
  CreateShortcut "$SMPROGRAMS\CMG System\CMG System.lnk" "$INSTDIR\cmg_system.exe"
  CreateShortcut "$SMPROGRAMS\CMG System\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortcut "$DESKTOP\CMG System.lnk" "$INSTDIR\cmg_system.exe"
  
  ; Write registry
  WriteRegStr HKLM "Software\CMG System" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CMG System" "DisplayName" "CMG System"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CMG System" "UninstallString" "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
  RMDir /r "$INSTDIR"
  RMDir /r "$SMPROGRAMS\CMG System"
  Delete "$DESKTOP\CMG System.lnk"
  DeleteRegKey HKLM "Software\CMG System"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CMG System"
SectionEnd
