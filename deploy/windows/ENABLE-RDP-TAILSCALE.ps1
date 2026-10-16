# ONE-TIME permanent RDP enable for abh-erp-m1 (Tailscale + LAN).
# Run once as Administrator. Do NOT run this every time you connect.
#
# After this succeeds, from Mac use Windows App → 100.124.82.121 forever
# (as long as Tailscale is connected and Windows is on).

#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

Write-Host "=== Permanent RDP setup (one-time) ===" -ForegroundColor Cyan

# 1) Allow RDP connections (persists in registry across reboot)
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
  -Name 'fDenyTSConnections' -Value 0 -Type DWord
# Keep NLA on for security (Mac Windows App supports it)
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' `
  -Name 'UserAuthentication' -Value 1 -Type DWord

# 2) TermService always starts at boot
Set-Service -Name TermService -StartupType Automatic
if ((Get-Service TermService).Status -ne 'Running') {
  Start-Service -Name TermService
}

# 3) Built-in Remote Desktop firewall group (all profiles)
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'

# 4) Explicit persistent rule for Tailscale / any adapter
$ruleName = 'ABH Tailscale RDP TCP 3389'
Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue | Remove-NetFirewallRule
New-NetFirewallRule `
  -DisplayName $ruleName `
  -Name 'ABH-Tailscale-RDP-3389' `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 3389 `
  -Action Allow `
  -Profile Any `
  -Enabled True | Out-Null

# 5) Boot re-assert (only if something else disables RDP later — runs at startup, silent)
$taskName = 'ABH-Ensure-RDP-Enabled'
$scriptDir = 'C:\TA\scripts'
New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null
$ensureScript = Join-Path $scriptDir 'ensure-rdp.ps1'
@'
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0 -Type DWord
Set-Service -Name TermService -StartupType Automatic
if ((Get-Service TermService).Status -ne "Running") { Start-Service TermService }
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
'@ | Set-Content -Path $ensureScript -Encoding UTF8

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
$action = New-ScheduledTaskAction -Execute 'powershell.exe' `
  -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$ensureScript`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null

# Verify
$deny = (Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections
$svc  = Get-Service TermService
$listen = @(Get-NetTCPConnection -LocalPort 3389 -State Listen -ErrorAction SilentlyContinue)
$fw = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Registry RDP allowed : $(if ($deny -eq 0) { 'YES (permanent)' } else { 'NO' })" -ForegroundColor $(if ($deny -eq 0) { 'Green' } else { 'Red' })
Write-Host "TermService          : $($svc.Status) / $($svc.StartType)"
Write-Host "Listening on 3389    : $(if ($listen.Count) { 'YES' } else { 'NO' })" -ForegroundColor $(if ($listen.Count) { 'Green' } else { 'Yellow' })
Write-Host "Firewall rule        : $(if ($fw) { $fw.Enabled } else { 'missing' })"
Write-Host "Startup task         : $taskName registered"
Write-Host ""
Write-Host "DONE. You will not need the enable commands again." -ForegroundColor Green
Write-Host "From Mac (Tailscale on): Windows App → 100.124.82.121" -ForegroundColor Green
Write-Host "If Mac still gets 0x204, check Tailscale ACL allows TCP 3389 to abh-erp-m1." -ForegroundColor Yellow
