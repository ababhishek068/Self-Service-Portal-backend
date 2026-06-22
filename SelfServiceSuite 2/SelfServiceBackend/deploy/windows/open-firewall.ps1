$ErrorActionPreference = "Stop"

$ruleName = "Self Service Portal TCP 4000"
$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

if ($existing) {
    Write-Host "Firewall rule already exists: $ruleName"
    exit 0
}

New-NetFirewallRule `
    -DisplayName $ruleName `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort 4000 `
    -RemoteAddress LocalSubnet `
    -Action Allow

Write-Host "Created firewall rule: $ruleName"
