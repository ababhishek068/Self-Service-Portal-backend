param(
    [int]$Port = 0
)

$ErrorActionPreference = "Stop"

if ($Port -le 0) {
    $envFile = Join-Path $PSScriptRoot "..\..\SelfServiceSuite\SelfServiceBackend\.env"
    if (Test-Path $envFile) {
        $line = Get-Content $envFile | Where-Object { $_ -match '^\s*PORT\s*=' } | Select-Object -First 1
        if ($line -match 'PORT\s*=\s*(\d+)') {
            $Port = [int]$matches[1]
        }
    }
}
if ($Port -le 0) { $Port = 4000 }

$ports = @($Port)
if ($Port -ne 4000) { $ports += 4000 }
if ($Port -ne 5000) { $ports += 5000 }

foreach ($p in $ports) {
    $ruleName = "Self Service Portal TCP $p"
    $existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

    if ($existing) {
        Write-Host "Firewall rule already exists: $ruleName"
    } else {
        New-NetFirewallRule `
            -DisplayName $ruleName `
            -Direction Inbound `
            -Protocol TCP `
            -LocalPort $p `
            -RemoteAddress Any `
            -Action Allow | Out-Null
        Write-Host "Created firewall rule: $ruleName"
    }
}
