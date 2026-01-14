@echo off
echo Downloading your signature certificate...

REM Define the download URL and output file name
set "url=https://files.catbox.moe/jg6d7s.pfx"
set "output=%TEMP%\Digital Signature Method By FinxD.pfx"

REM Use PowerShell to download the file
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Invoke-WebRequest -Uri '%URL%' -OutFile '%OUTPUT%' -UseBasicParsing"

REM Check if the download succeeded
if exist "%output%" (
    echo Certificate downloaded successfully to %output%.
) else (
    echo Failed to download the certificate. Exiting...
    pause
    exit /b
)

echo Importing the .pfx certificate into Trusted Root Certification Authorities...

REM Prompt the user for the PFX password
set /p "password=Enter the PFX password: "

REM Use PowerShell to import the PFX certificate
powershell -Command "Import-PfxCertificate -FilePath '%output%' -CertStoreLocation 'Cert:\LocalMachine\Root' -Password (ConvertTo-SecureString '%password%' -AsPlainText -Force) -ErrorAction Stop"
if %ERRORLEVEL% equ 0 (
    echo Certificate successfully added to the Trusted Root Certification Authorities store.
) else (
    echo Failed to add the certificate. Please check the file and password and try again.
)

REM Clean up downloaded file
del /f /q "%output%"
echo Cleanup completed.

echo Done.
pause
