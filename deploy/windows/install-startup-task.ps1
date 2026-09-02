$ErrorActionPreference = "Stop"

$taskName = "Self Service Portal"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$packagedBackend = Join-Path $projectRoot "SelfServiceSuite\SelfServiceBackend"
$backendRoot = if (Test-Path (Join-Path $packagedBackend "dist\server.js")) {
    $packagedBackend
} else {
    $projectRoot
}
$batchPath = Join-Path $backendRoot "deploy\windows\start-self-service.bat"
$envPath = Join-Path $backendRoot ".env"
$nodeCommand = Get-Command node.exe -ErrorAction Stop
$runnerPath = Join-Path $backendRoot "deploy\windows\start-self-service-task.cmd"

if (-not (Test-Path $batchPath)) {
    throw "Portal startup script was not found: $batchPath"
}
if (-not (Test-Path $envPath)) {
    throw "Portal .env was not found: $envPath. Copy the working .env before installing autostart."
}

$runnerContents = @"
@echo off
cd /d "$backendRoot"
set NODE_ENV=production
if not exist "logs" mkdir "logs"
"$($nodeCommand.Source)" dist\server.js >> logs\server-console.log 2>&1
"@
Set-Content -LiteralPath $runnerPath -Value $runnerContents -Encoding ASCII

$action = New-ScheduledTaskAction `
    -Execute "$env:SystemRoot\System32\cmd.exe" `
    -Argument "/d /c `"`"$runnerPath`"`"" `
    -WorkingDirectory $backendRoot

$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 5 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero)

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -User "SYSTEM" `
    -RunLevel Highest `
    -Force

Start-ScheduledTask -TaskName $taskName
Write-Host "Installed and started scheduled task: $taskName" -ForegroundColor Green
Write-Host "Backend: $backendRoot"
Write-Host "Node.js: $($nodeCommand.Source)"
