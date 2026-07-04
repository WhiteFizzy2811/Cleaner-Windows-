:: =============================================
:: Cleaner System V2
:: =============================================
:CLEANER
@echo off
title Cleaner V2 - By WhiteFizzy
color 0B
setlocal EnableDelayedExpansion
cls

fsutil dirty query %systemdrive% >nul 2>&1
if %errorLevel% NEQ 0 (
    color 0C
    echo =====================================================
    echo  [ERRORE] NON SEI IN MODALITA' AMMINISTRATORE!
    echo =====================================================
    echo.
    echo  Per farlo funzionare correttamente:
    echo  1. Fai clic con il TASTO DESTRO sul file .bat
    echo  2. Scegli "ESEGUI COME AMMINISTRATORE"
    echo  3. Clicca su "SI" nella finestra di Windows
    echo.
    pause
    exit /b
)

echo ========================================================================================
echo   Cleaner V2 - By WhiteFizzy
echo ========================================================================================
echo.
echo   [1]  ABILITA TUTTI I TWEAKS  (Esegue TUTTE le pulizie e sblocca i file protetti)
echo   ---------------------------------------------------------------------------------------
echo   [2] Svuota File Temporanei     (C:\Windows\Temp e %%temp%%)
echo   [3] Pialla Prefetch ^& Log     (Rimuove tracciamenti e registri di sistema)
echo   [4] Svuota Cache Driver Video  (DirectX, NVIDIA, AMD Shader Cache - Anti-Stutter)
echo   [5] Pulisce Windows Update     (Svuota la cartella SoftwareDistribution)
echo   [6] Svuota Cestino ^& Dumps    (Elimina file eliminati e crash dump pesanti)
echo   [7] Esegui Cleanmgr Deep       (Forza la pulizia di sistema nativa automatica)
echo   ---------------------------------------------------------------------------------------
echo   [B] Torna al Menu Principale
echo   [X] Esci
echo.
echo ========================================================================================
set /p clean_choice=   Scegli l'opzione da attivare: 

if "%clean_choice%"=="1" goto CLEAN_ALL
if "%clean_choice%"=="2" goto CLEAN_TEMP
if "%clean_choice%"=="3" goto CLEAN_PREFETCH
if "%clean_choice%"=="4" goto CLEAN_SHADERS
if "%clean_choice%"=="5" goto CLEAN_UPDATE
if "%clean_choice%"=="6" goto CLEAN_DUMPS
if "%clean_choice%"=="7" goto CLEAN_MGR
if /i "%clean_choice%"=="B" goto MENU
if "%clean_choice%"=="X" goto EXIT_CLEAN
goto CLEANER

:CLEAN_ALL
@echo off
cls
echo ========================================================================================
echo   STATUS: ESECUZIONE PURGE GLOBALE IN CORSO...
echo ========================================================================================
echo  [SYSTEM] Chiusura processi in background per sbloccare i file protetti...
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im edge.exe >nul 2>&1
taskkill /f /im chrome.exe >nul 2>&1
taskkill /f /im msedgewebview2.exe >nul 2>&1
timeout /t 1 >nul
echo.

:CLEAN_TEMP
@echo off
echo  [▓▓░░░░░░░░] [1/7] Svuotamento Cartelle TEMP (Sistema e Utente)...
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p" >nul 2>&1
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*") do rmdir /s /q "%%p" >nul 2>&1
if "%clean_choice%" NEQ "1" goto CLEAN_END

:CLEAN_PREFETCH
@echo off
echo  [▓▓▓▓░░░░░░] [2/7] Piallatura Prefetch e file Log di sistema...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Prefetch\*") do rmdir /s /q "%%p" >nul 2>&1
del /f /s /q "C:\Windows\Logs\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Logs\*") do rmdir /s /q "%%p" >nul 2>&1
del /f /s /q "C:\Windows\System32\LogFiles\*.*" >nul 2>&1
del /f /s /q "C:\Windows\CbsTemp\*.*" >nul 2>&1
if "%clean_choice%" NEQ "1" goto CLEAN_END

:CLEAN_SHADERS
@echo off
echo  [▓▓▓▓▓▓░░░░] [3/7] Svuotamento DirectX, NVIDIA e AMD Shader Cache...
del /f /s /q "%localappdata%\D3DSCache\*.*" >nul 2>&1
for /d %%p in ("%localappdata%\D3DSCache\*") do rmdir /s /q "%%p" >nul 2>&1
del /f /s /q "%localappdata%\NVIDIA\DXCache\*.*" >nul 2>&1
del /f /s /q "%localappdata%\AMD\DxCache\*.*" >nul 2>&1
if "%clean_choice%" NEQ "1" goto CLEAN_END

:CLEAN_UPDATE
@echo off
echo  [▓▓▓▓▓▓▓░░░] [4/7] Svuotamento Cache di Windows Update (SoftwareDistribution)...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\SoftwareDistribution\Download\*") do rmdir /s /q "%%p" >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
del /f /s /q "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache\*.*" >nul 2>&1
if "%clean_choice%" NEQ "1" goto CLEAN_END

:CLEAN_DUMPS
@echo off
echo  [▓▓▓▓▓▓▓▓░░] [5/7] Svuotamento Cestino e rimozione Crash Dumps...
rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1
del /f /s /q "C:\CrashDumps\*.*" >nul 2>&1
del /f /s /q "%localappdata%\CrashDumps\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Minidump\*.*" >nul 2>&1
if "%clean_choice%" NEQ "1" goto CLEAN_END

:CLEAN_MGR
@echo off
echo  [▓▓▓▓▓▓▓▓▓░] [6/7] Inizializzazione automatica Cleanmgr Deep Target...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0099 /t REG_DWORD /d 2 /f >nul
cleanmgr /sagerun:99 >nul 2>&1

:CLEAN_END
@echo off
echo  [▓▓▓▓▓▓▓▓▓▓] [7/7] Reset DNS Cache ^& Svuotamento Stack IP...
ipconfig /flushdns >nul 2>&1

:EXIT_CLEAN
cls
exit /b 0

:: Riavvia explorer solo se era stato terminato
tasklist /fi "imagename eq explorer.exe" 2>&1 | findstring /i "explorer.exe" >nul
if %errorlevel% NEQ 0 (
    echo.
    echo  [SYSTEM] Ripristino dell'interfaccia grafica di Windows...
    start explorer.exe
)

echo.
echo ========================================================================================
echo   [OK] PURGE COMPLETATO CON SUCCESSO! IL SISTEMA È STATO RIPULITO CON SUCCESSO.
echo ========================================================================================
pause
goto CLEANER