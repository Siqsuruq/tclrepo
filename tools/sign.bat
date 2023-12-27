@echo off
setlocal

:: Get the filename from the command-line arguments
set "FILENAME=%~1"

:: Set the name of your private key file here
set "PRIVATE_KEY=private.pem"

:: Check if a filename was provided
if "%FILENAME%"=="" (
    echo Usage: %~nx0 filename
    exit /b 1
)

:: Sign the file directly with your private key
echo Signing %FILENAME% with %PRIVATE_KEY%...
openssl dgst -sha256 -sign "%PRIVATE_KEY%" -out "%FILENAME%.sig" "%FILENAME%"

echo Done.
endlocal
