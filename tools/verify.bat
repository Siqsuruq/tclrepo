@echo off
setlocal

:: Get the filename and signature file from the command-line arguments
set FILENAME=%~1
set SIGNATURE_FILE=%~2

:: Set the name of your public key file here
set PUBLIC_KEY=public.pem

:: Check if both filename and signature file were provided
if "%FILENAME%"=="" (
    echo Usage: %~nx0 filename signature_file
    exit /b 1
)

if "%SIGNATURE_FILE%"=="" (
    echo Usage: %~nx0 filename signature_file
    exit /b 1
)

:: Verify the signature
echo Verifying signature with %PUBLIC_KEY%...
openssl dgst -sha256 -verify %PUBLIC_KEY% -signature %SIGNATURE_FILE% %FILENAME%

endlocal
