$ErrorActionPreference = "Stop"

$taskName = "Self Service Portal"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$batchPath = Join-Path $projectRoot "deploy\windows\start-self-service.bat"

$action = New-ScheduledTaskAction `
    -Execute "$env:SystemRoot\System32\cmd.exe" `
    -Argument "/c `"`"$batchPath`"`"" `
    -WorkingDirectory $projectRoot

$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
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
Write-Host "Installed and started scheduled task: $taskName"
