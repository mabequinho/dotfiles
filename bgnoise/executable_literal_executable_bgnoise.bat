@echo off
setlocal

rem Define the ffplay command and the media file
set ffplay_cmd=ffplay -loop 0 -nodisp -af "volume=0.6" "C:\Users\lu\Music\xoxo.mp3"

rem Check if ffplay is running
tasklist /fi "imagename eq ffplay.exe" 2>NUL | find /I /N "ffplay.exe">NUL
if "%ERRORLEVEL%"=="0" (
    rem ffplay is running, so kill the process
    echo Stopping ffplay...
    taskkill /F /IM ffplay.exe
) else (
    rem ffplay is not running, so start it
    echo Starting ffplay...
    start "" %ffplay_cmd%
)

endlocal
