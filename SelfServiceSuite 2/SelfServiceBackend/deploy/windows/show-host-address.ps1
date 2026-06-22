$addresses = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -notlike "127.*" -and
        $_.IPAddress -notlike "169.254.*"
    } |
    Select-Object -ExpandProperty IPAddress

Write-Host "Open one of these addresses from another device:"
$addresses | ForEach-Object { Write-Host "  http://$($_):4000" }
