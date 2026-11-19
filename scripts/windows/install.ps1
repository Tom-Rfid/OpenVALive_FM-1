# OpenVALive - automatic installation on Windows (WSL + build + Python + flash)
#
# Run: double-click INSTALL-WINDOWS.bat at the root of the project,
# or: powershell -ExecutionPolicy Bypass -File scripts\windows\install.ps1
#
# Steps (each one is skipped when already done):
#   1. finds the project (the script's folder, or asks for the zip's path)
#   2. WSL + Ubuntu 24.04 (installed, then a reboot the first time)
#   3. in Ubuntu: packages, fm1-base, JieLi toolchain, SDK, tests, firmware
#   4. Windows Python 3.12 + mido/python-rtmidi (to talk to the FM-1 over USB-MIDI)
#   5. offers to install the firmware on the FM-1
param(
    [string]$Zip = "",
    [string]$Distro = "",
    [switch]$NoFlash
)
$ErrorActionPreference = "Stop"

function Step($t) { Write-Host ""; Write-Host "==> $t" -ForegroundColor Cyan }
function Ok($t)   { Write-Host "    OK $t" -ForegroundColor Green }
function Stop-Here($t) { Write-Host ""; Write-Host $t -ForegroundColor Yellow; Read-Host "Press Enter to close" | Out-Null; exit 1 }

Write-Host "OpenVALive - Windows installation" -ForegroundColor White

# ------------------------------------------------------------ 1. le projet
Step "1/5 OpenVALive project"
$project = $null
$fromScript = Resolve-Path (Join-Path $PSScriptRoot "..\..") -ErrorAction SilentlyContinue
if ($fromScript -and (Test-Path (Join-Path $fromScript "targets\fm1\fm1.toml"))) {
    $project = $fromScript.Path
} else {
    if (-not $Zip) {
        Write-Host "    Where is the OpenVALive zip? (e.g. C:\Users\me\Downloads\OpenVALive_FM-1-main.zip)"
        Write-Host "    Leave empty to download it from GitHub."
        $Zip = (Read-Host "    Path of the zip").Trim('"', ' ')
    }
    if ($Zip) {
        if (-not (Test-Path $Zip)) { Stop-Here "File not found: $Zip" }
        $dest = Join-Path $env:LOCALAPPDATA "OpenVALive\src"
        if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        Expand-Archive -Path $Zip -DestinationPath $dest -Force
        $toml = Get-ChildItem $dest -Recurse -Filter fm1.toml | Where-Object { $_.FullName -like "*targets\fm1\fm1.toml" } | Select-Object -First 1
        if (-not $toml) { Stop-Here "This zip has no targets\fm1\fm1.toml: is it really OpenVALive?" }
        $project = $toml.Directory.Parent.Parent.FullName
    }
}
if ($project) { Ok $project } else { Ok "will be cloned from GitHub inside Ubuntu" }

# ------------------------------------------------------------ 2. WSL + Ubuntu
Step "2/5 WSL and Ubuntu"
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) { Stop-Here "wsl.exe not found: Windows 10 2004+ or Windows 11 is required." }
$list = @((wsl.exe --list --quiet 2>$null) | ForEach-Object { ($_ -replace "`0", "").Trim() } | Where-Object { $_ })
if (-not $Distro) {
    $Distro = ($list | Where-Object { $_ -eq "Ubuntu-24.04" } | Select-Object -First 1)
    if (-not $Distro) { $Distro = ($list | Where-Object { $_ -like "Ubuntu*" } | Select-Object -First 1) }
}
if (-not $Distro) {
    Write-Host "    Ubuntu is not installed. Installing Ubuntu 24.04 (a permission window may open)."
    wsl.exe --install -d Ubuntu-24.04
    Stop-Here ("Next:`n" +
        "  1. Restart the PC if Windows asks for it.`n" +
        "  2. Open 'Ubuntu' from the Start menu and create your Linux user (name + password).`n" +
        "  3. Run INSTALL-WINDOWS.bat again.")
}
$probe = wsl.exe -d $Distro -e bash -c "echo ready" 2>$null
if ($probe -notmatch "ready") {
    Stop-Here ("Ubuntu ($Distro) does not start yet.`n" +
        "Open 'Ubuntu' once from the Start menu to create your user, then run this script again.")
}
Ok $Distro

# ------------------------------------------------------------ 3. build dans Ubuntu
Step "3/5 Build in Ubuntu (first time: a few minutes; sudo asks for your Ubuntu password)"
$desktop = [Environment]::GetFolderPath("Desktop")
$outWin = Join-Path $desktop "OpenVALive-FM1"
New-Item -ItemType Directory -Force -Path $outWin | Out-Null
$outWsl = (wsl.exe -d $Distro -e wslpath -a "$outWin").Trim()
$args3 = "--out '$outWsl'"
$setupWsl = ""
if ($project) {
    $projWsl = (wsl.exe -d $Distro -e wslpath -a "$project").Trim()
    $args3 = "--project '$projWsl' " + $args3
    $setupWsl = "$projWsl/scripts/wsl/setup.sh"
    $cmd = "tr -d '\r' < '$setupWsl' > /tmp/ols_setup.sh && bash /tmp/ols_setup.sh $args3"
} else {
    $cmd = "curl -fsSL https://raw.githubusercontent.com/Tom-Rfid/OpenVALive_FM-1/main/scripts/wsl/setup.sh | tr -d '\r' > /tmp/ols_setup.sh && bash /tmp/ols_setup.sh $args3"
}
wsl.exe -d $Distro -e bash -c $cmd
if ($LASTEXITCODE -ne 0) { Stop-Here "The build failed (see the messages above). docs\_EN\10-troubleshooting.md lists the known errors." }
$fwsc = Get-ChildItem $outWin -Filter *.fwsc | Select-Object -First 1
if (-not $fwsc) { Stop-Here "No firmware in $outWin." }
Ok $fwsc.FullName

# ------------------------------------------------------------ 4-5. Python + flash
Step "4/5 Windows Python (for USB-MIDI)"
& (Join-Path $outWin "flash.ps1") -PrepareOnly
if ($LASTEXITCODE -ne 0) { Stop-Here "Python could not be prepared (see above)." }

Step "5/5 Install on the FM-1"
if ($NoFlash) { Write-Host "    Skipped (-NoFlash). Later: double-click $outWin\FLASH-FM1.bat"; exit 0 }
$r = Read-Host "    Install on the FM-1 now? (y/N)"
if ($r -match '^[oOyY]') {
    & (Join-Path $outWin "flash.ps1")
} else {
    Write-Host "    Later: double-click $outWin\FLASH-FM1.bat"
}
