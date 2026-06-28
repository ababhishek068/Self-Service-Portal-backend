# Installs the attendance MAC helper to start automatically on this PC.
# Run once per employee PC (IT admin or end user).
param(
  [ValidateSet('Machine', 'User')]
  [string]$Scope = 'Machine'
)

$ErrorActionPreference = "Stop"

$taskName = "Self Service Attendance MAC Helper"
$shortcutName = "Self Service MAC Helper.lnk"
$scriptPath = (Resolve-Path (Join-Path $PSScriptRoot "client-mac-helper.ps1")).Path
$powershellArgs = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scriptPath`""

function Install-UserStartupShortcut {
  $startupFolder = [Environment]::GetFolderPath('Startup')
  $shortcutPath = Join-Path $startupFolder $shortcutName
  $wsh = New-Object -ComObject WScript.Shell
  $shortcut = $wsh.CreateShortcut($shortcutPath)
  $shortcut.TargetPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
  $shortcut.Arguments = $powershellArgs
  $shortcut.WorkingDirectory = $PSScriptRoot
  $shortcut.WindowStyle = 7
  $shortcut.Description = "Self Service Portal attendance MAC helper"
  $shortcut.Save()
  Write-Host "Installed startup shortcut for current user:"
  Write-Host "  $shortcutPath"
}

function Install-MachineScheduledTask {
  $action = New-ScheduledTaskAction `
    -Execute "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -Argument $powershellArgs `
    -WorkingDirectory $PSScriptRoot

  $trigger = New-ScheduledTaskTrigger -AtStartup
  $settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -RestartCount 5 `
    -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -StartWhenAvailable

  Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -User "SYSTEM" `
    -RunLevel Highest `
    -Force | Out-Null

  Write-Host "Installed scheduled task for all users on this PC:"
  Write-Host "  $taskName"
}

function Start-HelperNow {
  Start-Process `
    -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" `
    -ArgumentList $powershellArgs `
    -WorkingDirectory $PSScriptRoot `
    -WindowStyle Hidden
  Write-Host "Started MAC helper in the background."
}

if ($Scope -eq 'User') {
  Install-UserStartupShortcut
} else {
  Install-MachineScheduledTask
}

Start-HelperNow
Write-Host ""
Write-Host "Done. Attendance sign-in can now read this PC MAC address."
Write-Host "Log file: $env:ProgramData\SelfServiceSuite\logs\client-mac-helper.log"
