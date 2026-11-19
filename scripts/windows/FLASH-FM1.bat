@echo off
rem OpenVALive - installs the firmware on the FM-1 (double-click)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0flash.ps1" %*
