# Run once as Administrator. After that, a server restart starts the portal on port 4000.
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$backendFromHere = Join-Path $here 'SelfServiceSuite\SelfServiceBackend\dist\server.js'
if (Test-Path $backendFromHere) {
    $root = $here
} else {
    $root = (Resolve-Path (Join-Path $here '..\..')).Path
}

$backend = Join-Path $root 'SelfServiceSuite\SelfServiceBackend'
$serverJs = Join-Path $backend 'dist\server.js'
$onboot = Join-Path $root 'deploy\windows\START-ABH-PORTAL-ONBOOT.bat'
$envFile = Join-Path $backend '.env'

if (-not (Test-Path $serverJs)) {
    throw "Portal files were not found at $serverJs. Extract the full suite, then run this from that folder."
}
if (-not (Test-Path $onboot)) {
    throw "Missing $onboot"
}
if (-not (Test-Path $envFile)) {
    throw "Copy the existing .env into $backend before turning on autostart."
}

$node = (Get-Command node -ErrorAction Stop).Source
Set-Content -Path (Join-Path $root 'deploy\windows\ABH-PORTAL-NODE.txt') -Value $node -Encoding ASCII

$taskName = 'ABH Smart ESSP'
$action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/c `"$onboot`"" -WorkingDirectory $backend
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Delay = 'PT45S'
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
Start-ScheduledTask -TaskName $taskName

Write-Host ""
Write-Host "Autostart is on."
Write-Host "Task:    $taskName"
Write-Host "Portal:  $backend"
Write-Host "Node:    $node"
Write-Host "After this server restarts, the portal starts on http://127.0.0.1:4000"
Write-Host "Log:     $(Join-Path $root 'portal-autostart.log')"
Write-Host ""
