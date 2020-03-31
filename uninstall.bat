@echo off

title Arduino-AVR Setup Installation :: by Alauddin Ansari

SETLOCAL EnableDelayedExpansion

SET cwd=%~dp0
SET isError=0

REM -- load variables
SET ConfigFile=config.cmd
IF NOT EXIST "%cwd%\%ConfigFile%" (
	echo config file does not exists: "%cwd%\%ConfigFile%"
	echo existing...
	SET isError=1
	echo.
	GOTO END
)
CALL "%cwd%\%ConfigFile%"

SET Files[0]=%cwd%\%CompilerFile%
SET Files[1]=%cwd%\%UploaderFile%
SET Files[2]=%cwd%\%LauncherFile%


:SIGNATURE
CLS
echo ################################################
echo ########## Created by Alauddin Ansari ##########
echo ############## Un-Installer Setup ##############
echo ################ Dec, 2019 #####################
echo ################################################
echo.
echo.

REM -- Execution starts here
:CHECK_SETUP_FILES
IF NOT EXIST "%cwd%\%UninstallerRegFile%" (
	echo uninstaller registry file does not exists: "%cwd%\%UninstallerRegFile%"
	echo existing...
	SET isError=1
	echo.
	GOTO END
)

REM -- Removing software files
SET "x=0"
:REMOVE_FILES
IF NOT DEFINED Files[%x%] GOTO EXEC_REGISTRY
IF EXIST "!Files[%x%]!" (
	echo removing "!Files[%x%]!"
	DEL /F "!Files[%x%]!"
	echo.
	timeout /T 1 /NOBREAK>nul
)
SET /a "x+=1"
GOTO REMOVE_FILES

:EXEC_REGISTRY
REM -- execute registry file to remove context menu
echo executing registry script to remove context menu...
echo from "%cwd%\%UninstallerRegFile%"
regedit.exe /s "%cwd%\%UninstallerRegFile%"
timeout /T 1 /NOBREAK>nul
echo registry file executed successfully.
echo.

REM -- remove registry file
IF EXIST "%cwd%\%UninstallerRegFile%" (
	echo removing "%cwd%\%UninstallerRegFile%"
	DEL /F "%cwd%\%UninstallerRegFile%"
	echo.
	timeout /T 1 /NOBREAK>nul
)

REM -- TODO : do something here to remove self file

:REMOVE_INSTALL_DIR
IF EXIST "%ProgramPath%" (
	echo deleting program folder "%ProgramPath%"
	RMDIR /S /Q "%ProgramPath%"
	echo.
	timeout /T 1 /NOBREAK>nul
)

IF NOT EXIST "%ProgramPath%" (
	echo program folder deleted successfully
	echo.
	timeout /T 1 /NOBREAK>nul
	GOTO DONE
)

echo some files or direcotries not deleted.

:DONE
echo.
echo It's all done successfully!!!
echo.

:END
echo Thank you...
echo.

IF "%isError%" equ "1" (
	pause
	GOTO EOD
)
timeout /T 1 /NOBREAK>nul

:EOD
exit
