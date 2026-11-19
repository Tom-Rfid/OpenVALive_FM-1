# OpenVALive - installs the firmware on an FM-1 plugged in over USB (Windows)
#
# Double-click FLASH-FM1.bat, or: powershell -ExecutionPolicy Bypass -File flash.ps1
# The folder must hold: a .fwsc, fm1_install.py and fm1ports.py (copied by build-fm1.sh).
#   -PrepareOnly: only prepare Python 3.12 + mido + python-rtmidi
param([switch]$PrepareOnly, [string]$Package = "")
$ErrorActionPreference = "Stop"
function Ok($t) { Write-Host "    OK $t" -ForegroundColor Green }

# Python 3.12: python-rtmidi has no prebuilt package for very recent Pythons
# (3.14, 3.15) and building it needs Visual Studio. 3.12 has it ready.
if (-not (Get-Command py -ErrorAction SilentlyContinue)) {
    Write-Host "    The 'py' launcher is missing: installing the Python install manager (winget)."
    winget install --id Python.PythonInstallManager -e --accept-source-agreements --accept-package-agreements
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "User") + ";" + [Environment]::GetEnvironmentVariable("Path", "Machine")
}
& py -3.12 --version *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "    Installing Python 3.12..."
    & py install 3.12
    if ($LASTEXITCODE -ne 0) { winget install --id Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements }
}
& py -3.12 -c "import mido, rtmidi" *> $null
if ($LASTEXITCODE -ne 0) {
    & py -3.12 -m pip install --user --disable-pip-version-check -q mido python-rtmidi
    if ($LASTEXITCODE -ne 0) { Write-Host "pip install mido python-rtmidi failed" -ForegroundColor Red; exit 1 }
}
Ok "Python 3.12 + mido + python-rtmidi"
if ($PrepareOnly) { exit 0 }

Set-Location $PSScriptRoot
if (-not $Package) { $Package = (Get-ChildItem $PSScriptRoot -Filter *.fwsc | Select-Object -First 1).FullName }
if (-not $Package -or -not (Test-Path $Package)) { Write-Host "No .fwsc next to this script." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "Before installing:" -ForegroundColor Yellow
Write-Host "  - plug the FM-1 in over USB (a DATA cable, not a charge-only one) and switch it on"
Write-Host "  - close FL Studio and every MIDI program"
Write-Host "  - back up your presets; way back to the official firmware: https://hugelton.github.io/Felucca/"
Read-Host "Press Enter when ready" | Out-Null

& py -3.12 fm1_install.py --info
if ($LASTEXITCODE -ne 0) {
    Write-Host "FM-1 not found: check the cable (data), that it is on, and that no program uses its MIDI port." -ForegroundColor Red
    Read-Host "Press Enter to close" | Out-Null; exit 1
}
& py -3.12 fm1_install.py $Package
Read-Host "Press Enter to close" | Out-Null
