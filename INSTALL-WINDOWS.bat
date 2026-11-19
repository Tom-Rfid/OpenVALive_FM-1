@echo off
rem OpenVALive - full Windows installation: WSL, build, Python, FM-1 flash
rem Double-click this file. Details: docs\_EN\04-install.md
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\windows\install.ps1" %*
pause
