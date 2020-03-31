@echo off

title Arduino-AVR Setup Installation :: by Alauddin Ansari

SETLOCAL EnableDelayedExpansion

SET cwd=%~dp0

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


:SIGNATURE
CLS
echo ################################################
echo ########## Created by Alauddin Ansari ##########
echo ################ Software Setup ################
echo ################ Dec, 2019 #####################
echo ################################################
echo.
echo.


:CHECK_SETUUP
IF EXIST "%ProgramPath%\%compilerFile%" (
	IF EXIST "%ProgramPath%\%uploaderFile%" (
		IF EXIST "%ProgramPath%\%launcherFile%" (
			REM -- Software is already installed, uninstall it...
			echo Software is already installed
			echo.
			
			GOTO UNINSTALL
		)
	)
)
REM -- Software is not installed, install it...
GOTO INSTALL

:UNINSTALL
SET confirm=
SET /p confirm="Do you want to uninstall the software? (yes/no): "
IF "%confirm%"=="no" goto EXIT

IF "%confirm%" neq "yes" (
	echo Enter only "yes" or "no"
	echo.
	goto UNINSTALL
)

cmd.exe /K CALL "%cwd%\uninstall.bat"
GOTO EXIT


:INSTALL
cmd.exe /K CALL "%cwd%\install.bat"
GOTO EXIT

:EXIT
timeout /T 2 /NOBREAK>nul
