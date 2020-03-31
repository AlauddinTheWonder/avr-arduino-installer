@echo off

title Arduino Compiler Installation :: by Alauddin Ansari

SET compiler=%1
SET compiler=%compiler:"=%
SET compiler=%compiler:\=\\%

SET uploader=%2
SET uploader=%uploader:"=%
SET uploader=%uploader:\=\\%

SET launcher=%3
SET launcher=%launcher:"=%
SET launcher=%launcher:\=\\%

SET commonCommand=usbasp usb 19200

echo Windows Registry Editor Version 5.00
echo.
echo [HKEY_CLASSES_ROOT\SystemFileAssociations]
echo.
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.ino]
echo.
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.ino\Shell]
echo.
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.hex]
echo.
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.hex\Shell]
echo.

REM -- Compile and Upload using USBasp
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.ino\Shell\AVR USBasp Upload]
echo "MUIVerb"="AVR USBasp Upload"
echo "SubCommands"="AVR.launch.m328p;AVR.launch.t85;AVR.launch.t45;AVR.launch.t84;AVR.launch.t44"
echo.

REM -- Compile with Arduino
REM echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.ino\Shell\Compile with Arduino]
REM echo "MUIVerb"="Compile with Arduino"
REM echo "SubCommands"="Arduino.compile;Arduino.m328p;Arduino.t85;Arduino.t45;Arduino.t84;Arduino.t44"
REM echo.

REM -- Upload using USBasp
echo [HKEY_CLASSES_ROOT\SystemFileAssociations\.hex\Shell\AVR USBasp Upload]
echo "MUIVerb"="AVR USBasp Upload"
echo "SubCommands"="AVR.upload.do;AVR.upload.m328p;AVR.upload.t85;AVR.upload.t45;AVR.upload.t84;AVR.upload.t44"
echo.

echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell]


REM -- Compile and Upload
REM -- ATmega328p
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.m328p]
echo @="ATmega328p"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.m328p\Command]
echo @="\"%launcher%\" \"%%1\" ATmega \"\" \"\" m328p %commonCommand%"

REM -- ATtiny85
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t85]
echo @="ATtiny85"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t85\Command]
echo @="\"%launcher%\" \"%%1\" ATtinyX5 attiny85 internal8 t85 %commonCommand%"

REM -- ATtiny45
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t45]
echo @="ATtiny45"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t45\Command]
echo @="\"%launcher%\" \"%%1\" ATtinyX5 attiny45 internal8 t45 %commonCommand%"

REM -- ATtiny84
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t84]
echo @="ATtiny84"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t84\Command]
echo @="\"%launcher%\" \"%%1\" ATtinyX4 attiny84 internal8 t84 %commonCommand%"

REM -- ATtiny44
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t44]
echo @="ATtiny44"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.launch.t44\Command]
echo @="\"%launcher%\" \"%%1\" ATtinyX4 attiny44 internal8 t44 %commonCommand%"


REM -- Compiler
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.compile]
REM echo @="Compile"
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.compile\Command]
REM echo @="\"%compiler%\" \"%%1\""

REM -- ATmega328p
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.m328p]
REM echo @="ATmega328p"
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.m328p\Command]
REM echo @="\"%compiler%\" \"%%1\" ATmega"

REM -- ATtiny85
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t85]
REM echo @="ATtiny85"
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t85\Command]
REM echo @="\"%compiler%\" \"%%1\" ATtinyX5 attiny85 internal8"

REM -- ATtiny45
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t45]
REM echo @="ATtiny45"
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t45\Command]
REM echo @="\"%compiler%\" \"%%1\" ATtinyX5 attiny45 internal8"

REM -- ATtiny84
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t84]
REM echo @="ATtiny84"
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t84\Command]
REM echo @="\"%compiler%\" \"%%1\" ATtinyX4 attiny84 internal8"

REM -- ATtiny44
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t44]
REM echo @="ATtiny44"
REM echo.
REM echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Arduino.t44\Command]
REM echo @="\"%compiler%\" \"%%1\" ATtinyX4 attiny44 internal8"


REM -- Uploader
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.do]
echo @="Upload"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.do\Command]
echo @="\"%uploader%\" \"%%1\""

REM -- ATmega328p
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.m328p]
echo @="ATmega328p"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.m328p\Command]
echo @="\"%uploader%\" \"%%1\" m328p %commonCommand%"

REM -- ATtiny85
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t85]
echo @="ATtiny85"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t85\Command]
echo @="\"%uploader%\" \"%%1\" t85 %commonCommand%"

REM -- ATtiny45
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t45]
echo @="ATtiny45"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t45\Command]
echo @="\"%uploader%\" \"%%1\" t45 %commonCommand%"

REM -- ATtiny84
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t84]
echo @="ATtiny84"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t84\Command]
echo @="\"%uploader%\" \"%%1\" t84 %commonCommand%"

REM -- ATtiny44
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t44]
echo @="ATtiny44"
echo.
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\AVR.upload.t44\Command]
echo @="\"%uploader%\" \"%%1\" t44 %commonCommand%"


echo.
