@echo off
title Desinstalando Programar Apagado...

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  ERROR: Ejecuta como Administrador.
    echo.
    pause
    exit /b 1
)

reg delete "HKEY_CLASSES_ROOT\DesktopBackground\Shell\ProgramarApagado" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\Background\Shell\ProgramarApagado" /f >nul 2>&1

set "DESTINO=%ProgramFiles%\ProgramarApagado"
if exist "%DESTINO%" rmdir /s /q "%DESTINO%"

echo.
echo  Desinstalado correctamente.
echo.
pause
