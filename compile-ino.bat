@echo off

title Arduino Compiler Interface :: by Alauddin Ansari
REM --


SETLOCAL EnableDelayedExpansion

REM -- IC Family (Part Name)
SET f[1]=ATmega
SET f[2]=ATtinyX5
SET f[3]=ATtinyX4

REM -- CPU
SET tx5cpu[1]=attiny85
SET tx5cpu[2]=attiny45
SET tx5cpu[3]=attiny25

SET tx4cpu[1]=attiny84
SET tx4cpu[2]=attiny44
SET tx4cpu[3]=attiny24

REM -- Clock
SET c[1]=internal1
SET c[2]=internal8
SET c[3]=external8
SET c[4]=external16
SET c[5]=external20

REM -- General Variables
SET cwd=%~dp0
SET /A final=0
SET /A validFile=0
SET fqbn=

SET fileName=%1
SET famName=%2
SET cpu=%3
SET clock=%4

SET noConfirm=%5
IF NOT DEFINED noConfirm SET noConfirm=0

SET errorLvl=0


:SIGNATURE
CLS
echo ################################################
echo ########## Created by Alauddin Ansari ##########
echo ##### Compile INO files using Arduino-CLI ######
echo ################ Dec, 2019 #####################
echo ################################################
echo.

:INPUT_FILE_NAME
IF DEFINED fileName (
	IF %validFile% EQU 0 GOTO VALIDATE_FILENAME
	IF %final% EQU 0 echo You selected file name: %fileName%
	GOTO LIST_IC_FAMILY
)

SET /p fileName="Enter ino file path (ex. main.ino): "

IF NOT DEFINED fileName GOTO INPUT_FILE_NAME

:VALIDATE_FILENAME
SET tempFileName=%fileName:"=%

If "%tempFileName:~-4%" neq ".ino" (
	echo.
	echo File path must ends with .ino
	echo entered: %fileName%
	echo Please try again
	SET fileName=
	goto INPUT_FILE_NAME
)

:FILE_EXIST
IF NOT EXIST %fileName% (
	echo.
	echo File does not exist
	echo Please enter a valid filename
	SET fileName=
	goto INPUT_FILE_NAME
)

SET /A validFile=1

GOTO SIGNATURE

:LIST_IC_FAMILY
IF DEFINED famName (
	IF %final% EQU 0 echo You selected IC Family: %famName%
	
	IF "%famName%"=="ATmega" GOTO SET_FINAL
	IF "%famName%"=="ATtinyX5" GOTO LIST_CPUx5
	IF "%famName%"=="ATtinyX4" GOTO LIST_CPUx4
)

SET famName=

echo.
echo List of available ICs:
echo ----------------------
echo   1. ATmega (%f[1]%)
echo   2. ATtinyX5 (%f[2]%)
echo   3. ATtinyX4 (%f[3]%)
echo.

CHOICE /C 123 /M "Select IC Family, options are "

SET famName=!f[%ERRORLEVEL%]!

GOTO SIGNATURE

:LIST_CPUx5
IF DEFINED cpu (
	IF %final% EQU 0 echo You selected IC CPU: %cpu%
	GOTO LIST_CLOCK
)

SET cpu=

echo.
echo List of available IC CPUs:
echo ----------------------
echo   1. ATtiny85 (%tx5cpu[1]%)
echo   2. ATtiny45 (%tx5cpu[2]%)
echo   3. ATtiny25 (%tx5cpu[3]%)
echo.

CHOICE /C 123 /M "Select IC CPU, options are "

SET cpu=!tx5cpu[%ERRORLEVEL%]!

GOTO SIGNATURE

:LIST_CPUx4
IF DEFINED cpu (
	IF %final% EQU 0 echo You selected IC CPU: %cpu%
	GOTO LIST_CLOCK
)

SET cpu=

echo.
echo List of available IC CPUs:
echo ----------------------
echo   1. ATtiny84 (%tx4cpu[1]%)
echo   2. ATtiny44 (%tx4cpu[2]%)
echo   3. ATtiny24 (%tx4cpu[3]%)
echo.

CHOICE /C 123 /M "Select IC CPU, options are "

SET cpu=!tx4cpu[%ERRORLEVEL%]!

GOTO SIGNATURE

:LIST_CLOCK
IF DEFINED clock (
	IF %final% EQU 0 echo You selected CPU Clock: %clock%
	GOTO SET_FINAL
)

SET clock=

echo.
echo List of available IC CPUs:
echo ----------------------
echo   1. Internal 1 Mhz (%c[1]%)
echo   2. Internal 8 Mhz (%c[2]%)
echo   3. External 8 Mhz (%c[3]%)
echo   4. External 16 Mhz (%c[4]%)
echo   5. External 20 Mhz (%c[5]%)
echo.

CHOICE /C 12345 /M "Select IC CPU, options are "

SET clock=!c[%ERRORLEVEL%]!

GOTO SIGNATURE


:SET_FINAL
IF %final% EQU 0 (
	SET /A final=1
	
	IF "%famName%"=="ATmega" SET fqbn=arduino:avr:uno
	IF "%famName%"=="ATtinyX5" SET fqbn=attiny:avr:ATtinyX5:cpu=%cpu%,clock=%clock%
	IF "%famName%"=="ATtinyX4" SET fqbn=attiny:avr:ATtinyX4:cpu=%cpu%,clock=%clock%
	
	GOTO SIGNATURE
)

REM ----
:FINAL_INFO
SET fileNameOnly=%fileName%
SET dirOnly=%cwd%

FOR %%F IN (%fileName%) DO SET fileNameOnly=%%~nxF
FOR %%F IN (%fileName%) DO SET dirOnly=%%~dpF

echo Final details are:
echo.
echo   File Path	:  %fileName%
echo   IC Family	:  %famName%
echo   IC CPU	:  %cpu%
echo   CPU Clock	:  %clock%
echo.
echo Confirm compiler command to be executed...
echo.
echo   arduino-cli compile --fqbn=%fqbn% --output "%dirOnly%build\%fileNameOnly%.%cpu%" %fileName%
echo.


IF "%noConfirm%"=="1" GOTO START_PROCESS

:IS_CONFIRM
SET confirm=
SET /p confirm="Is above information correct? (yes/no): "

IF "%confirm%"=="no" goto END

IF "%confirm%" neq "yes" (
	echo Enter only "yes" or "no"
	echo.
	goto IS_CONFIRM
)

:START_PROCESS
IF NOT EXIST "%dirOnly%\build" MKDIR "%dirOnly%\build"

echo.

arduino-cli compile --verbose --fqbn=%fqbn% --output "%dirOnly%build\%fileNameOnly%.%cpu%" %fileName%

IF %errorlevel% neq 0 (
	echo.
	echo ############################################
	echo There is some error in compiling file.
	echo Error Level: %errorlevel%
	echo exiting...
	echo ############################################
	echo.
	SET errorLvl=%errorlevel%
	pause
	GOTO END
)

echo.
echo It's done!

:END
echo.
echo Thank you...

timeout /T 1 /NOBREAK>nul

IF "%noConfirm%"=="1" GOTO EOD

pause

:EOD
EXIT %errorLvl%
