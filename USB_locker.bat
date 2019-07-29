:: USB Locker v1.0
:: Author: g4xyk00
:: Tested on Windows 7, 10

echo off
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")

:MAIN_ACTIVITY
cls

echo         __    ___   _               _               
echo  /\ /\ / _\  / __\ ^| ^|  ___    ___ ^| ^| __ ___  _ __ 
echo / / \ \\ \  /__\// ^| ^| / _ \  / __^|^| ^|/ // _ \^| '__^|
echo \ \_/ /_\ \/ \/  \ ^| ^|^| (_) ^|^| (__ ^|   ^<^|  __/^| ^|   
echo  \___/ \__/\_____/ ^|_^| \___/  \___^|^|_^|\_\\___^|^|_^|   
@echo:
echo Created by: Gary Kong (g4xyk00)
echo Version: 1.0
echo Homepage: www.axcelsec.com                                               
													
@echo:
pushd %~dp0

:: Local Computer Policy > Computer Configuration > Administrative Templates > System > Removable Storage Access
:: All Removable Storage classes
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_All" > 1.txt
set /p AllClassesDeny=<1.txt
:: Disabled
IF "%AllClassesDeny:~-1%"=="0" ( set AllClassesDenyStatus=0 ) 
:: Enabled
IF "%AllClassesDeny:~-1%"=="1" ( set AllClassesDenyStatus=1 ) 
:: Not configured
IF "%AllClassesDeny:~-1%"=="~-1" ( set AllClassesDenyStatus=0 )  

:: Removable Disks
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p RemovableDenyRead=<1.txt
:: Disabled
IF "%RemovableDenyRead:~-1%"=="0" ( set RemovableDenyReadStatus=0 )  
:: Enabled
IF "%RemovableDenyRead:~-1%"=="1" ( set RemovableDenyReadStatus=1 )  
:: Not configured
IF "%RemovableDenyRead:~-1%"=="~-1" ( set RemovableDenyReadStatus=0 )  

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p RemovableDenyWrite=<1.txt
:: Disabled
IF "%RemovableDenyWrite:~-1%"=="0" ( set RemovableDenyWriteStatus=0 ) 
:: Enabled 
IF "%RemovableDenyWrite:~-1%"=="1" ( set RemovableDenyWriteStatus=1 )  
:: Not configured
IF "%RemovableDenyWrite:~-1%"=="~-1" ( set RemovableDenyWriteStatus=0 )  

:: WPD Devices
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} > 0.txt 2>nul
type 0.txt | findstr /C:"Deny_Read" > 1.txt
set /p WPDDenyRead=<1.txt
:: Disabled
IF "%WPDDenyRead:~-1%"=="0" ( set WPDDenyReadStatus=0 )  
:: Enabled
IF "%WPDDenyRead:~-1%"=="1" ( set WPDDenyReadStatus=1 )  
:: Not configured
IF "%WPDDenyRead:~-1%"=="~-1" ( set WPDDenyReadStatus=0 ) 
 

type 0.txt | findstr /C:"Deny_Write" > 1.txt
set /p WPDDenyWrite=<1.txt
:: Disabled
IF "%WPDDenyWrite:~-1%"=="0" ( set WPDDenyWriteStatus=0 )  
:: Enabled
IF "%WPDDenyWrite:~-1%"=="1" ( set WPDDenyWriteStatus=1 )  
:: Not configured
IF "%WPDDenyWrite:~-1%"=="~-1" ( set WPDDenyWriteStatus=0 )  

set /A AccessStatus = %AllClassesDenyStatus% + %RemovableDenyReadStatus% + %RemovableDenyWriteStatus% + %WPDDenyReadStatus% + %WPDDenyWriteStatus%
echo Existing removable storage access is:
IF "%AccessStatus%" NEQ "0" ( call :PainText 02 "DENIED" )
IF "%AccessStatus%" EQU "0" ( call :PainText 04 "ALLOWED" )

del 0.txt
del 1.txt

@echo:
@echo:

echo ***** Action ***** 
echo [1] Allow removable storage access
echo [2] Deny removable storage access 
echo [0] Exit Program
@echo:
SET /P A=Please select an action (e.g. 2) and press ENTER: 

IF %A%==0 GOTO END
IF %A%==1 GOTO ACCESS_ALLOW
IF %A%==2 GOTO ACCESS_DENY

:ACCESS_ALLOW
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /t REG_DWORD /v Deny_All /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Read /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Write /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Read /d 0 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Write /d 0 /f > nul 2>&1
echo Removable storage access is now ALLOWED!
@echo:
GOTO MAIN_ACTIVITY

:ACCESS_DENY
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices /t REG_DWORD /v Deny_All /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Read /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{53f5630d-b6bf-11d0-94f2-00a0c91efb8b} /t REG_DWORD /v Deny_Write /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Read /d 1 /f > nul 2>&1
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices\{F33FDC04-D1AC-4E8E-9A30-19BBD4B108AE} /t REG_DWORD /v Deny_Write /d 1 /f > nul 2>&1
echo Removable storage access is now DENIED!
@echo:
GOTO MAIN_ACTIVITY

:PainText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
echo.
goto :eof

PAUSE
:END