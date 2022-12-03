@echo off

       if "%~1"=="-toggle"  (	
	goto toggleMode
) else (
	if "%~1"=="-install" (
		goto check_Permissions
	) else (
		if  "%~1"=="" (
			goto noarg
		) else ( 
			goto noarg 
		)
		
	)
)


:toggleMode
for /f "tokens=3" %%i in ('REG QUERY HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme') do set DarkTheme=%%i
if "%DarkTheme%"=="0x1" (
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /t REG_DWORD /d 0x0 /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0x0 /f
) else (if "%DarkTheme%"=="0x0" (
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /t REG_DWORD /d 0x1 /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0x1 /f
))
goto :eof

:setup
SETLOCAL ENABLEDELAYEDEXPANSION
SET Esc_LinkDest=%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\Dark Mode Toggler.lnk
SET Esc_LinkTarget=%~f0
SET cSctVBS=CreateShortcut.vbs
SET LOG=".\%~N0_runtime.log"
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.Arguments = "-toggle"
  echo oLink.Hotkey = "CTRL+SHIFT+Z"
  echo oLink.WindowStyle = "7"
  echo oLink.IconLocation = "%SystemRoot%\SystemResources\shell32.dll.mun, 265"
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!

)1>>!LOG! 2>>&1

 copy "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Dark Mode Toggler.lnk" "%USERPROFILE%\Desktop\Dark Mode Toggler.lnk"
cls
echo Dark Mode Toggler has installed, please do not move or remove the Dark Mode Engine file.
echo The shortcut of the Dark Mode Toggler is CTRL+SHIFT+Z. To close this window, press any key.
pause >nul
goto :eof


:noarg
@echo To run Dark Mode Toggler directly, you need to use -install or -toggle arguments.
set toggle=toggle
set t=t
set i=i
set install=install
set /p aim=What is your purpose? [I]nstall,[T]oggle:
if %aim%==%install% or %aim%==%i% (
	goto check_Permissions
) else (
	if %aim%==%toggle% or %aim%==%t% (
		goto toggleMode
	) else (
		echo Something went wrong...
		goto pause
	)
)

:check_Permissions
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
	goto setup
    ) else (
	echo . 
        echo Failure: You need run this file as Administrator.
    )
    
    pause >nul

:pause
pause 
goto :eof