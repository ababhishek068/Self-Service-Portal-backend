# ABH — test BC OData (run in PowerShell on the BC server)
param(
    [string]$BcUser = 'Admin',
    [string]$BcPassword = '',
    [string]$Url = "http://localhost:7048/BC240/ODataV4/Company('ABH_UAT_LIVE')/QyHREmployee?`$top=1"
)

if (-not $BcPassword) {
    $secure = Read-Host 'BC Admin password' -AsSecureString
    $BcPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    )
}

$pair = "${BcUser}:$BcPassword"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$headers = @{ Authorization = "Basic $base64" }

try {
    $r = Invoke-WebRequest -Uri $Url -Headers $headers -UseBasicParsing -TimeoutSec 30
    Write-Host "OK — StatusCode $($r.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "FAILED — $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "HTTP $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    }
}
