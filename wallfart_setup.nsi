;-----------------------------------------------------------------------------
;  NSIS script to create WallFArt's setup/install program
;     
;  NSIS == Nullsoft Scriptable Install System
;    http://nsis.sourceforge.net
;
Name "WallFArt for Windows"
Caption "WallFArt ~ it's 'pseudo-random' baby ~"
SilentInstall normal
BGGradient 000000 800000 FFFFFF
;InstallColors FF8080 000030
InstallColors F08080 000030
XPStyle on

; The setup executable file to write
;OutFile "wfsetup.exe"
OutFile "setupWallFArt.exe"

; The default installation directory
InstallDir $PROGRAMFILES\WallFArt

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\MWHW_WallFArt" "Install_Dir"

; Request application privileges for Windows Vista and on
RequestExecutionLevel admin

;-------------------------------------------------------------------------------
; Pages
Page license 
Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

LicenseText "License page"
LicenseData "wallfart_winBin\wallfart_license.txt"

AutoCloseWindow true
;ShowInstDetails show
;******************************************************************************
;------------------------------------------------------------------------------
; The stuff to install
Section "WallFArt for Windows"
  SectionIn RO
;
; destination directory
  SetOutPath $INSTDIR
;
; source directory
  File "wallfart_winbin\*.*"
; 
; let's start mucking about with that ol' registry, shall we...  
  WriteRegStr HKLM SOFTWARE\MWHW_WallFArt "Install_Dir" "$INSTDIR"
;
; registry keys for uninstall
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\WallFArt" "DisplayName" "WallFArt for Windows"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\WallFArt" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\WallFArt" "NoModify" 0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\WallFArt" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
;
; 
  MessageBox MB_YESNO|MB_ICONQUESTION "Yipee!! Installation complete: Would you like to run WallFArt now?" IDNO NOPE

  Exec "$INSTDIR\wallfart.exe"

NOPE:
SectionEnd

;******************************************************************************
;------------------------------------------------------------------------------
; Optional installation items (can be disabled by the user)
Section "Start Menu Shortcuts"
  setShellVarContext all 
  CreateDirectory "$SMPROGRAMS\WallFArt"
  CreateShortcut "$SMPROGRAMS\WallFArt\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortcut "$SMPROGRAMS\WallFArt\WallFArt.lnk" "$INSTDIR\WallFArt.exe" "" "$INSTDIR\wallfart_icon_256.ico"

SectionEnd

;******************************************************************************
;------------------------------------------------------------------------------
; shortcut syntax:
;  CreateShortcut (linkName, targetName, [parameters [icon.fileName [icon_idx_number 
;    [start_options [keyboard_shortcut [description]]]]]])
Section "Desktop Shortcut"
  setShellVarContext all 
  CreateShortcut "$DESKTOP\WallFArt.lnk" "$INSTDIR\WallFArt.exe"  "" "$INSTDIR\wallfart_icon_256.ico"

SectionEnd

;******************************************************************************
;------------------------------------------------------------------------------
; Uninstaller
;
Section "Uninstall"
  
  setShellVarContext all 
; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\WallFArt"
  DeleteRegKey HKLM SOFTWARE\MWHW_WallFArt

; Remove files and uninstaller
  Delete $INSTDIR\*.txt
  Delete $INSTDIR\*.dll
  Delete $INSTDIR\*.ico
  Delete $INSTDIR\WallFArt.exe
  Delete $INSTDIR\uninstall.exe

; Remove shortcuts, if any
  Delete "$SMPROGRAMS\WallFArt\*.*"
; remove desktop shortcut
  Delete "$DESKTOP\WallFArt.lnk"

; make absolutely, positively sure install directory is empty...
; 	orphaned directories && orphaned registry keys == (bad&BAD))
  Delete $INSTDIR\*.*
; Remove start menu entries 
  RMDir "$SMPROGRAMS\WallFArt"
; delete installation directory
  RMDir "$INSTDIR"

SectionEnd
