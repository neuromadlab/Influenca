;Installation script for neuroMADLAB Influenca
; Written by Vanessa Teckentrup (07.11.2018)

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "FileFunc.nsh"

;--------------------------------
;General

  ;Properly display all languages (Installer will not work on Windows 95, 98 or ME!)
  Unicode true
  
  ; Activate LZMA compression for installer/uninstaller
  SetCompressor /FINAL lzma
   
  !define MUI_ICON "C:\Users\Vanessa Teckentrup\Documents\App_RC\bin\windows\bin\icon.ico"
  !define MUI_UNICON "C:\Users\Vanessa Teckentrup\Documents\App_RC\bin\windows\bin\icon.ico"
  !define MUI_COMPONENTSPAGE_NODESC
  
  !define LAB_NAME "neuroMADLAB"
  !define APP_NAME "Influenca"
  !define APP_VERSION "0.0.8"
  
  ;Name and file
  Name "${APP_NAME}"
  OutFile "${APP_NAME}-${APP_VERSION}-Setup.exe"
  
  ;Default installation folder
  InstallDir "$PROGRAMFILES\${LAB_NAME}\${APP_NAME}"
  ;InstallDir "$LOCALAPPDATA\${LAB_NAME}\${APP_NAME}"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\${APP_NAME}" ""

  ;Request application privileges for Windows Vista and up
  RequestExecutionLevel admin
  ;RequestExecutionLevel user
  
;--------------------------------
;Variables

  Var StartMenuFolder

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  
  
;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU" 
  !define MUI_LANGDLL_REGISTRY_KEY "Software\${APP_NAME}" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;--------------------------------
;Pages

  ;!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Docs\Modern UI\License.txt"
  ;!insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  
  !insertmacro MUI_PAGE_STARTMENU 0 $StartMenuFolder
  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${APP_NAME}" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  ;!insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "English"
  
  ; Set file properties information
  VIProductVersion "0.${APP_VERSION}"
  ;VIAddVersionKey /LANG=${LANG_GERMAN} "ProductName" "${APP_NAME}"
  ;VIAddVersionKey /LANG=${LANG_GERMAN} "CompanyName" "${LAB_NAME}"
  ;VIAddVersionKey /LANG=${LANG_GERMAN} "ProductVersion" "${APP_VERSION}"
  VIAddVersionKey "ProductName" "${APP_NAME}"
  VIAddVersionKey "CompanyName" "${LAB_NAME}"
  VIAddVersionKey "ProductVersion" "${APP_VERSION}"
  
;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
;Installer Sections

Section "Setup" SecDummy
  
  ; If files are already present, overwrite them if they are older
  SetOverwrite ifnewer
  
  ; Install for all users
  ;SetShellVarContext all
  
  SetOutPath "$INSTDIR"
  
  ;Add Influenca files to installer
  File /r "C:\Users\Vanessa Teckentrup\Documents\App_RC\bin\windows\bin\*"
  
  ;Store installation folder
  WriteRegStr HKCU "Software\${APP_NAME}" "" $INSTDIR
  
  ;Store information for uninstall
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "DisplayName" "${LAB_NAME} - ${APP_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "UninstallString" "$\"$INSTDIR\${APP_NAME}-Uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "QuietUninstallString" "$\"$INSTDIR\${APP_NAME}-Uninstall.exe$\" /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "InstallLocation" "$\"$INSTDIR$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "DisplayIcon" "$\"$INSTDIR\icon.ico$\""
  # There is no option for modifying or repairing the install
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "NoRepair" 1
  # Set the INSTALLSIZE constant so Add/Remove Programs can accurately report the size
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}" "EstimatedSize" "$0"
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\${APP_NAME}-Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN 0
    
    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
	CreateShortcut "$SMPROGRAMS\$StartMenuFolder\${APP_NAME} starten.lnk" "$INSTDIR\${APP_NAME}.exe"
    ;CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall ${APP_NAME}.lnk" "$INSTDIR\${APP_NAME}-Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

;--------------------------------
;Installer Functions

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

;--------------------------------
;Descriptions

  ;Language strings
  ;LangString DESC_SecDummy ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
  ;!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  ;  !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  ;!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;Remove Influenca files
  ; Don't use recursive option for INSTDIR as it may be set to an unconvenient path by the user

  Delete "$INSTDIR\${APP_NAME}-Uninstall.exe"
  Delete "$INSTDIR\${APP_NAME}.exe"
  Delete "$INSTDIR\icon.ico"
  Delete "$INSTDIR\lime.ndll"

  RMDir /r /REBOOTOK "$INSTDIR\fonts"
  RMDir /r /REBOOTOK "$INSTDIR\manifest"
  RMDir /r /REBOOTOK "$INSTDIR\styles"
  RMDir /r /REBOOTOK "$INSTDIR\img"
  RMDir /r /REBOOTOK "$INSTDIR\lang"
  RMDir /r /REBOOTOK "$INSTDIR\crashdumper"
  RMDir "$INSTDIR"
  
  ;Remove start menu entry
  !insertmacro MUI_STARTMENU_GETFOLDER 0 $StartMenuFolder
  Delete "$SMPROGRAMS\$StartMenuFolder\${APP_NAME} starten.lnk"
  ;Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall ${APP_NAME}.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"

  DeleteRegKey /ifempty HKCU "Software\${APP_NAME}"
  # Remove uninstaller information from the registry
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${LAB_NAME} ${APP_NAME}"

SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE
  
FunctionEnd