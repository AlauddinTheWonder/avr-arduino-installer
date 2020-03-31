@echo off

title AVR Programmer Interface :: by Alauddin Ansari
REM --

SETLOCAL EnableDelayedExpansion

REM -- IC (Part Name)
SET p[1]=m328p
SET p[2]=m168
SET p[3]=t85
SET p[4]=t45
SET p[5]=t25
SET p[6]=t84
SET p[7]=t44
SET p[8]=t24

REM -- Programmer
SET c[1]=usbasp
SET c[2]=stk500v1

SET /A final=0
SET /A validFile=0

SET fileName=%1
SET partName=%2
SET progName=%3
SET port=%4
SET baudRate=%5
SET additionalComm=%6

SET noConfirm=%7
IF NOT DEFINED noConfirm SET noConfirm=0

SET errorLvl=0

:SIGNATURE
CLS
echo ################################################
echo ########## Created by Alauddin Ansari ##########
echo ######## Upload HEX files using AVRdude ########
echo ################ Nov, 2019 #####################
echo ################################################
echo.

:INPUT_FILE_NAME
IF DEFINED fileName (
	IF %validFile% EQU 0 GOTO VALIDATE_FILENAME
	IF %final% EQU 0 echo You selected file name: %fileName%
	GOTO LIST_PART_NAME
)
SET /p fileName="Enter hex file path (main.hex): "

IF NOT DEFINED fileName SET "fileName=main.hex"

:VALIDATE_FILENAME
SET tempFileName=%fileName:"=%
If "%tempFileName:~-4%" neq ".hex" (
	echo.
	echo File path must ends with .hex
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

:LIST_PART_NAME
IF DEFINED partName (
	IF %final% EQU 0 echo You selected IC: %partName%
	GOTO LIST_PROGRAMMER
)

SET partName=

echo.
echo List of available ICs:
echo ----------------------
echo   1. ATmega328p (%p[1]%)
echo   2. ATmega168 (%p[2]%)
echo      -
echo   3. ATtiny85 (%p[3]%)
echo   4. ATtiny45 (%p[4]%)
echo   5. ATtiny25 (%p[5]%)
echo      -
echo   6. ATtiny84 (%p[6]%)
echo   7. ATtiny44 (%p[7]%)
echo   8. ATtiny24 (%p[8]%)
echo      -
echo   9. Other
echo.

CHOICE /C 123456789 /M "Select IC to be programmed, options are "

IF ERRORLEVEL 9 GOTO INPUT_PART_NAME
SET partName=!p[%ERRORLEVEL%]!

GOTO SIGNATURE

:INPUT_PART_NAME
SET partName=
SET /p partName="Enter IC name manually: "

IF NOT DEFINED partName goto INPUT_PART_NAME
IF "%partName:~0,1%"==" " goto INPUT_PART_NAME

GOTO SIGNATURE


:LIST_PROGRAMMER
IF DEFINED progName (
	IF %final% EQU 0 echo You selected programmer: %progName%
	GOTO INPUT_PORT
)

SET progName=

echo.
echo List of available Programmers:
echo ----------------------
echo   1. USBasp (%c[1]%)
echo   2. Arduino UNO (%c[2]%)
echo      -
echo   3. Other
echo.

CHOICE /C 123 /M "Select Programmer, options are "

IF ERRORLEVEL 3 GOTO INPUT_PROGRAMMER
SET progName=!c[%ERRORLEVEL%]!

GOTO SIGNATURE

:INPUT_PROGRAMMER
echo.
SET progName=
SET /p progName="Enter programmer, for arg -c (usbasp): "

IF NOT DEFINED progName SET "progName=usbasp"
IF "%progName:~0,1%"==" " goto INPUT_PROGRAMMER

GOTO SIGNATURE

:INPUT_PORT
IF DEFINED port (
	IF %final% EQU 0 echo You selected port: %port%
	GOTO INPUT_BR
)
echo.
SET port=
SET /p port="Enter port, for arg -P (usb): "

IF NOT DEFINED port SET "port=usb"
IF "%port:~0,1%"==" " goto INPUT_PORT

GOTO SIGNATURE

:INPUT_BR
IF DEFINED baudRate (
	IF %final% EQU 0 echo You selected baud rate: %baudRate%
	GOTO SET_FINAL
)
echo.
SET baudRate=
SET /p baudRate="Enter baud rate, for arg -b (19200): "

IF NOT DEFINED baudRate SET "baudRate=19200"
IF "%baudRate:~0,1%"==" " goto INPUT_BR

:ADD_COMM
IF DEFINED additionalComm (
	GOTO SET_FINAL
)
echo.
SET additionalComm=
SET /p additionalComm="Enter additional params (leave empty for nothing): "


:SET_FINAL
IF %final% EQU 0 (
	SET /A final=1
	
	GOTO SIGNATURE
)

REM ----
:FINAL_INFO
echo Final details are:
echo.
echo   File Path		:  %fileName%
echo   Programmer (-c)	:  %progName%
echo   Part Name (-p)	:  %partName%
echo   Port (-P)		:  %port%
echo   Baud Rate (-b)	:  %baudRate%
IF DEFINED additionalComm echo   Additional		:  %additionalComm%
echo.
echo Confirm AVR command to be executed...
echo.

IF DEFINED additionalComm echo   avrdude -v -c %progName% -p %partName% -P %port% -b %baudRate% %additionalComm:"=% -U flash:w:%fileName%:i
IF NOT DEFINED additionalComm echo   avrdude -v -c %progName% -p %partName% -P %port% -b %baudRate% -U flash:w:%fileName%:i

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
IF DEFINED additionalComm avrdude -v -c %progName% -p %partName% -P %port% -b %baudRate% %additionalComm:"=% -U flash:w:%fileName%:i
IF NOT DEFINED additionalComm avrdude -v -c %progName% -p %partName% -P %port% -b %baudRate% -U flash:w:%fileName%:i

IF %errorlevel% neq 0 (
	echo.
	echo ############################################
	echo There is some error in uploading file.
	echo Error Level: %errorlevel%
	echo exiting...
	echo ############################################
	echo.
	SET errorLvl=%errorlevel%
	pause
	GOTO END
)

rem avrdude -v -c %progName% -p %partName% -P %port% -b %baudRate% -U flash:w:%fileName%:i
rem avrdude -v -p attiny84 -c stk500v1 -P COM3 -b 19200 -Uflash:w:main.hex:i 

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
