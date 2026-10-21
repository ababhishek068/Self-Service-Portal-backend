# Run once as Administrator. Registers "ABH Smart ESSP" to start at Windows boot.
$ErrorActionPreference = 'Stop'

function Resolve-SuiteRoot {
    param([string]$StartDir)

    $candidates = @(
        $StartDir,
        (Join-Path $StartDir '..\..'),
        (Join-Path $StartDir 'deploy\windows\..\..')
    )

    foreach ($candidate in $candidates) {
        try {
            $resolved = (Resolve-Path -LiteralPath $candidate -ErrorAction Stop).Path
        } catch {
            continue
        }
        $serverJs = Join-Path $resolved 'SelfServiceSuite\SelfServiceBackend\dist\server.js'
        $onboot = Join-Path $resolved 'deploy\windows\START-ABH-PORTAL-ONBOOT.bat'
        if ((Test-Path -LiteralPath $serverJs) -and (Test-Path -LiteralPath $onboot)) {
            return $resolved
        }
    }

    throw @"
Portal suite was not found from $StartDir.

Expected:
  <suite>\SelfServiceSuite\SelfServiceBackend\dist\server.js
  <suite>\deploy\windows\START-ABH-PORTAL-ONBOOT.bat

Run INSTALL-AUTOSTART.bat from the extracted ABH-Portal-COMPLETE folder.
"@
}

function Read-EnvPort {
    param([string]$EnvPath, [int]$Default = 4000)
    if (-not (Test-Path -LiteralPath $EnvPath)) { return $Default }
    $line = Get-Content -LiteralPath $EnvPath | Where-Object { $_ -match '^\s*PORT\s*=' } | Select-Object -First 1
    if (-not $line) { return $Default }
    $value = ($line -split '=', 2)[1].Trim().Trim("'`"" )
    $parsed = 0
    if ([int]::TryParse($value, [ref]$parsed) -and $parsed -gt 0) { return $parsed }
    return $Default
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# Support both: suite-root copy and deploy\windows copy of this script.
$root = Resolve-SuiteRoot -StartDir $here
$backend = Join-Path $root 'SelfServiceSuite\SelfServiceBackend'
$serverJs = Join-Path $backend 'dist\server.js'
$onboot = Join-Path $root 'deploy\windows\START-ABH-PORTAL-ONBOOT.bat'
$envFile = Join-Path $backend '.env'
$deployWindows = Join-Path $root 'deploy\windows'
$nodeFile = Join-Path $deployWindows 'ABH-PORTAL-NODE.txt'
$runCmd = Join-Path $deployWindows 'ABH-PORTAL-RUN.cmd'
$logFile = Join-Path $root 'portal-autostart.log'

if (-not (Test-Path -LiteralPath $serverJs)) {
    throw "Portal files were not found at $serverJs"
}
if (-not (Test-Path -LiteralPath $onboot)) {
    throw "Missing $onboot"
}
if (-not (Test-Path -LiteralPath $envFile)) {
    throw "Copy the working .env into $backend before turning on autostart."
}

$nodeCmd = Get-Command node.exe -ErrorAction SilentlyContinue
if (-not $nodeCmd) {
    throw "node.exe was not found on PATH. Install Node.js LTS, open a new Admin cmd, then re-run INSTALL-AUTOSTART.bat."
}
$node = $nodeCmd.Source
Set-Content -LiteralPath $nodeFile -Value $node -Encoding ASCII

$port = Read-EnvPort -EnvPath $envFile -Default 4000

# Absolute-path runner so SYSTEM does not depend on user PATH or fragile cwd.
$runContents = @"
@echo off
setlocal EnableExtensions
cd /d "$backend"
call "$onboot"
exit /b %ERRORLEVEL%
"@
Set-Content -LiteralPath $runCmd -Value $runContents -Encoding ASCII

$taskName = 'ABH Smart ESSP'
# Remove older conflicting task names from previous installs.
foreach ($oldName in @('Self Service Portal', 'ABH Portal', $taskName)) {
    Unregister-ScheduledTask -TaskName $oldName -Confirm:$false -ErrorAction SilentlyContinue
}

$action = New-ScheduledTaskAction `
    -Execute "$env:SystemRoot\System32\cmd.exe" `
    -Argument "/d /c `"$runCmd`"" `
    -WorkingDirectory $backend

# Delay so NIC / Tailscale can come up before BC calls.
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Delay = 'PT90S'

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 5 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -MultipleInstances IgnoreNew

$principal = New-ScheduledTaskPrincipal `
    -UserId 'SYSTEM' `
    -LogonType ServiceAccount `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Principal $principal `
    -Force | Out-Null

Start-ScheduledTask -TaskName $taskName

# Brief readiness check (autostart may still be booting BC connectivity).
Start-Sleep -Seconds 3
$health = $null
try {
    $health = Invoke-WebRequest -Uri "http://127.0.0.1:$port/api/health" -UseBasicParsing -TimeoutSec 5
} catch {
    $health = $null
}

Write-Host ""
Write-Host "Autostart installed."
Write-Host "Task:     $taskName"
Write-Host "Suite:    $root"
Write-Host "Backend:  $backend"
Write-Host "Node:     $node"
Write-Host "Port:     $port  (from .env)"
Write-Host "Runner:   $runCmd"
Write-Host "Log:      $logFile"
Write-Host "URL:      http://127.0.0.1:$port/login"
if ($health -and $health.StatusCode -eq 200) {
    Write-Host "Health:   OK (portal already responding)"
} else {
    Write-Host "Health:   not ready yet — check Task Scheduler + $logFile"
    Write-Host "          After reboot the task waits 90s, then starts the portal."
}
Write-Host ""
Write-Host "Verify:   schtasks /Query /TN `"$taskName`" /V /FO LIST"
Write-Host "Manual:   schtasks /Run /TN `"$taskName`""
Write-Host ""
