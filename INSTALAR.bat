@echo off
title Instalando Programar Apagado...

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  ERROR: Ejecuta este archivo como Administrador.
    echo  Clic derecho - Ejecutar como administrador.
    echo.
    pause
    exit /b 1
)

set "DESTINO=%ProgramFiles%\ProgramarApagado"
set "SCRIPT=%DESTINO%\apagado.ps1"

if not exist "%DESTINO%" mkdir "%DESTINO%"

copy /Y "%~dp0apagado.ps1" "%SCRIPT%" >nul

if not exist "%SCRIPT%" (
    echo.
    echo  ERROR: No se pudo copiar apagado.ps1
    echo  Asegurate de que ambos archivos esten en la misma carpeta.
    echo.
    pause
    exit /b 1
)

set "CMD=powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File \"%SCRIPT%\""

reg add "HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado" /ve /d "Programar Apagado" /f >nul
reg add "HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado" /v "Icon" /d "shell32.dll,27" /f >nul
reg add "HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado\command" /ve /d "%CMD%" /f >nul

reg add "HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado" /ve /d "Programar Apagado" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado" /v "Icon" /d "shell32.dll,27" /f >nul
reg add "HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado\command" /ve /d "%CMD%" /f >nul

echo.
echo  Instalacion completada.
echo  Haz clic derecho en el escritorio y selecciona:
echo  Programar Apagado
echo.
pause
