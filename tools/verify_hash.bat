@echo off
setlocal

:: Get the filename from the command-line arguments
set FILENAME=%~1

:: Set the name of your public key file here
set PUBLIC_KEY=public.pem

:: Check if a filename was provided
if "%FILENAME%"=="" (
    echo Usage: %~nx0 filename
    exit /b 1
)

:: Create a SHA-256 hash of the received file
echo Creating SHA-256 hash of %FILENAME%...
openssl dgst -sha256 -binary -out %FILENAME%.sha256 %FILENAME%

:: Verify the signature
echo Verifying signature with %PUBLIC_KEY%...
openssl dgst -sha256 -verify %PUBLIC_KEY% -signature %FILENAME%.sig %FILENAME%.sha256

endlocal
