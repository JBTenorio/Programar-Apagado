@echo off
title Compilando Programar Apagado...
echo.
echo ===================================================
echo   Compilando apagado.ps1 a ProgramarApagado.exe
echo   Autor: Jose Biojo Tenorio
echo ===================================================
echo.

powershell.exe -ExecutionPolicy Bypass -Command "Invoke-PS2EXE -InputFile 'apagado.ps1' -OutputFile 'ProgramarApagado.exe' -Icon 'icono.ico' -Title 'Programar Apagado' -Description 'Herramienta para programar el apagado de Windows' -Company 'Jose Biojo Tenorio' -Copyright 'Copyright 2026 Jose Biojo Tenorio' -Version '1.0.0' -NoConsole -RequireAdmin"

echo.
echo [COMPLETADO] Revisa tu carpeta, el .exe esta listo.
echo.
pause
