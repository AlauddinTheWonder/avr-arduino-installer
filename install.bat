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

SET Files[0]=%ConfigFile%
SET Files[1]=%LauncherFile%
SET Files[2]=%CompilerFile%
SET Files[3]=%UploaderFile%
SET Files[4]=%UninstallerFile%
SET Files[5]=%UninstallerRegFile%


:SIGNATURE
CLS
echo ################################################
echo ########## Created by Alauddin Ansari ##########
echo ################ Installer Setup ###############
echo ################ Dec, 2019 #####################
echo ################################################
echo.
echo.

REM -- Execution starts here
IF NOT EXIST "%cwd%\%MakeRegFile%" (
	echo file does not exists: "%cwd%\%MakeRegFile%"
	echo existing...
	SET isError=1
	echo.
	GOTO END
)

SET "x=0"
:CHECK_SETUP_FILES
IF NOT DEFINED Files[%x%] GOTO CREATE_INSTALL_DIR
IF NOT EXIST "%cwd%\!Files[%x%]!" (
	echo file does not exists: "%cwd%\!Files[%x%]!"
	echo existing...
	SET isError=1
	echo.
	GOTO END
)
SET /a "x+=1"
GOTO CHECK_SETUP_FILES

REM -- create setup installation directory
:CREATE_INSTALL_DIR
IF NOT EXIST "%ProgramPath%" (
	echo creating program directory: "%ProgramPath%"
	echo.
	MKDIR "%ProgramPath%"
)

:CHECK_INSTALL_DIR
IF NOT EXIST "%ProgramPath%" (
	echo program directory could not be created.
	echo exiting...
	SET isError=1
	echo.
	GOTO END
)
echo program directory created successfully: "%ProgramPath%"
echo.

REM -- copy file from temp to installation path
SET "x=0"
:COPY_PROGRAM_FILE
IF NOT DEFINED Files[%x%] GOTO CHECK_PROGRAME_FILE_COPIED
IF NOT EXIST "%ProgramPath%\!Files[%x%]!" (
	echo copying file to installation path:
	echo from "%cwd%\!Files[%x%]!" to "%ProgramPath%\!Files[%x%]!"
	echo.
	COPY /Y "%cwd%\!Files[%x%]!" "%ProgramPath%\!Files[%x%]!"

	timeout /T 1 /NOBREAK>nul
)
SET /a "x+=1"
GOTO COPY_PROGRAM_FILE

REM -- check file copied successfully
SET "x=0"
:CHECK_PROGRAME_FILE_COPIED
IF NOT DEFINED Files[%x%] GOTO FILES_COPIED
IF NOT EXIST "%ProgramPath%\!Files[%x%]!" (
	echo error in copying files...
	echo exiting...
	SET isError=1
	echo.
	GOTO END
)
SET /a "x+=1"
GOTO CHECK_PROGRAME_FILE_COPIED

:FILES_COPIED
echo software files copied successfully.
echo.

:GEN_REGISTRY
REM -- generate registry file
echo generating registry file with software path to "%cwd%\%InstallerRegFile%"
CALL "%cwd%\%MakeRegFile%" "%ProgramPath%\%CompilerFile%" "%ProgramPath%\%UploaderFile%" "%ProgramPath%\%LauncherFile%" > "%cwd%\%InstallerRegFile%"
timeout /T 1 /NOBREAK>nul

:CHECK_REGISTRY
REM -- check registry file generated
IF NOT EXIST "%cwd%\%InstallerRegFile%" (
	echo error in generating registry file.
	echo exiting...
	SET isError=1
	echo.
	GOTO END
)
echo registry file generated successfully.
echo.

:EXEC_REGISTRY
REM -- make registry entry for context menu
echo executing registry script for context menu...
echo from "%cwd%\%InstallerRegFile%"
regedit.exe /s "%cwd%\%InstallerRegFile%"
timeout /T 1 /NOBREAK>nul
echo registry file executed successfully.
echo.

REM -- delete generated registry file
echo deleting registry file after execution: "%cwd%\%InstallerRegFile%"
DEL "%cwd%\%InstallerRegFile%"
echo.
timeout /T 1 /NOBREAK>nul

REM -- It's all done
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
