# Serves this PC's MAC at http://127.0.0.1:47211/mac for attendance sign-in.
param(
  [int]$Port = 47211
)

$ErrorActionPreference = "Stop"
$logDir = Join-Path $env:ProgramData "SelfServiceSuite\logs"
$logFile = Join-Path $logDir "client-mac-helper.log"

function Write-HelperLog([string]$Message) {
  try {
    if (-not (Test-Path $logDir)) {
      New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    $line = "{0} {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Add-Content -Path $logFile -Value $line
  } catch {
    # ignore logging failures
  }
}

function Test-PortListening([int]$ListenPort) {
  try {
    $client = New-Object System.Net.Sockets.TcpClient
    $client.Connect("127.0.0.1", $ListenPort)
    $client.Close()
    return $true
  } catch {
    return $false
  }
}

function Get-PrimaryMacAddress {
  $adapter = Get-NetAdapter -ErrorAction SilentlyContinue |
    Where-Object {
      $_.Status -eq 'Up' -and
      $_.HardwareInterface -eq $true -and
      $_.InterfaceDescription -notmatch 'Virtual|VPN|Hyper-V|Loopback|TAP|TUN'
    } |
    Sort-Object -Property InterfaceMetric |
    Select-Object -First 1
  if ($adapter) {
    return ($adapter.MacAddress -replace '-', ':').ToUpper()
  }
  return ''
}

if (Test-PortListening -ListenPort $Port) {
  Write-HelperLog "MAC helper already listening on port $Port"
  exit 0
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$Port/")

try {
  $listener.Start()
} catch {
  Write-HelperLog "Failed to start listener on port ${Port}: $($_.Exception.Message)"
  exit 1
}

Write-HelperLog "MAC helper listening on http://127.0.0.1:$Port/mac"

while ($listener.IsListening) {
  try {
    $context = $listener.GetContext()
    $response = $context.Response
    $mac = Get-PrimaryMacAddress
    $body = @{ mac = $mac } | ConvertTo-Json -Compress
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($body)
    $response.ContentType = 'application/json'
    $response.Headers.Add('Access-Control-Allow-Origin', '*')
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.Close()
  } catch {
    Write-HelperLog "Request handling error: $($_.Exception.Message)"
  }
}
