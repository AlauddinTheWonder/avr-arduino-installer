@echo off

title Arduino-AVRdude Compile and Upload Interface :: by Alauddin Ansari
REM --

SETLOCAL EnableDelayedExpansion

:SIGNATURE
CLS
echo ################################################
echo ########## Created by Alauddin Ansari ##########
echo ######### Compile and Upload INO file ##########
echo ##### using Arduino-CLI and AVRdude USBasp #####
echo ################ Dec, 2019 #####################
echo ################################################
echo.
echo.

REM -- Params

REM -- %1 = file path

REM -- for compiler
REM -- 
REM -- %2 = IC family		Ex: ATtinyX5
REM -- %3 = IC CPU			Ex: attiny85
REM -- %4 = IC Clock		Ex: internal8

REM -- For uploader
REM -- 
REM -- %5 = Chip short name	Ex: t85
REM -- %6 = Programmer		Ex: usbasp
REM -- %7 = Port			Ex: usb
REM -- %8 = baud rate		Ex: 19200


SET cwd=%~dp0

SET filePath=%1
SET familyName=%2
SET cpu=%3
SET clock=%4

SET chipShortName=%5
SET progName=%6
SET port=%7
SET baudRate=%8

SET fileNameOnly=%filePath%
SET dirOnly=%cwd%

FOR %%F IN (%filePath%) DO SET fileNameOnly=%%~nxF
FOR %%F IN (%filePath%) DO SET dirOnly=%%~dpF

SET buildPath=%dirOnly%build


:COMPILE
echo Starting compile process using Arduino-CLI...
echo %filePath%
echo.

timeout /T 1 /NOBREAK>nul

START /WAIT cmd.exe /K CALL "%cwd%\compile-ino.bat" %filePath% %familyName% %cpu% %clock% 1

IF %errorlevel% neq 0 (
	echo.
	echo ############################################
	echo There is some error in compiling file.
	echo Error level: %errorlevel%
	echo exiting...
	echo ############################################
	echo.
	GOTO END
)
echo Compilation completed successfully.
echo.
echo.

timeout /T 1 /NOBREAK>nul

:UPLOAD
echo Starting upload process using AVR USBasp...

SET hexFile="%buildPath%\%fileNameOnly%.%cpu%.hex"

IF NOT EXIST %hexFile% (
	echo.
	echo ############################################
	echo Target hex file not exist.
	echo %hexFile%
	echo exiting...
	echo ############################################
	echo.
	GOTO END
)

echo %hexFile%

START /WAIT cmd.exe /K CALL "%cwd%\upload-hex.bat" %hexFile% %chipShortName% %progName% %port% %baudRate% "" 1

IF %errorlevel% neq 0 (
	echo.
	echo ############################################
	echo There is some error in uploading file.
	echo Error level: %errorlevel%
	echo exiting...
	echo ############################################
	echo.
	GOTO END
)

echo.
echo Upload completed successfully.
echo.
echo.
echo All done!

:END

echo Removing build files...
IF EXIST %buildPath% RMDIR /S /Q %buildPath%

echo.
echo Thank you!
pause
timeout /T 1 /NOBREAK>nul
