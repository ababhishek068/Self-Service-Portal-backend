# Publish BC24_TA App 1.0.2.923 with leave-cancel fix.
# Run in Business Central Administration Shell AS ADMINISTRATOR.
# Copy to server: this .ps1 + StaffPortalCodeunit.Codeunit.al + a base .app (922 or 923).
param(
    [string]$ErpFolder = "$env:USERPROFILE\Desktop\Erp",
    [string]$ServerInstance = "BC240",
    [string]$TargetVersion = "1.0.2.923",
    [string]$Publisher = "Technology Associates EA Ltd",
    [string]$AppName = "BC24_TA App"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression

function Show-Apps {
    param([string]$Label)
    Write-Host "`n=== $Label ===" -ForegroundColor Cyan
    Get-NAVAppInfo -ServerInstance $ServerInstance -Name $AppName -Publisher $Publisher |
        Sort-Object Version -Descending |
        Select-Object -First 8 Name, Publisher, Version, IsPublished, IsInstalled |
        Format-Table -AutoSize
}

function Read-NavxZip([byte[]]$bytes) {
    if ([Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne "NAVX") { throw "Not a NAVX .app file" }
    $zipOff = 40
    return @{
        Header = $bytes[0..39]
        Zip    = $bytes[$zipOff..($bytes.Length - 1)]
    }
}

function Write-NavxApp([string]$Path, [byte[]]$header, [byte[]]$zipBytes) {
    $hdr = [byte[]]$header.Clone()
    $sizeBytes = [BitConverter]::GetBytes([int64]$zipBytes.Length)
    for ($i = 0; $i -lt 8; $i++) { $hdr[28 + $i] = $sizeBytes[$i] }
    $final = New-Object byte[] ($hdr.Length + $zipBytes.Length)
    [Array]::Copy($hdr, 0, $final, 0, $hdr.Length)
    [Array]::Copy($zipBytes, 0, $final, $hdr.Length, $zipBytes.Length)
    [IO.File]::WriteAllBytes($Path, $final)
}

function Build-923App {
    param(
        [string]$SourceApp,
        [string]$AlFile,
        [string]$OutApp
    )
    $targetAl = "src/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al"
    $newAl = [IO.File]::ReadAllText($AlFile)
    if ($newAl -notmatch "action = 'delete'") { throw "AL file missing leave delete/cancel branch" }

    $navx = Read-NavxZip ([IO.File]::ReadAllBytes($SourceApp))
    $inMs = New-Object IO.MemoryStream(,$navx.Zip)
    $outMs = New-Object IO.MemoryStream
    $inZip = New-Object IO.Compression.ZipArchive($inMs, [IO.Compression.ZipArchiveMode]::Read)
    $outZip = New-Object IO.Compression.ZipArchive($outMs, [IO.Compression.ZipArchiveMode]::Create, $true)

    $replaced = $false
    foreach ($entry in $inZip.Entries) {
        $name = $entry.FullName
        if ($name -eq "perm/file1_%5BContent_Types%5D.xml") { $name = "perm/file1_[Content_Types].xml" }

        $src = $entry.Open()
        if ($name -eq $targetAl) {
            $replaced = $true
            $outEntry = $outZip.CreateEntry($name, [IO.Compression.CompressionLevel]::Optimal)
            $dst = $outEntry.Open()
            $writer = New-Object IO.StreamWriter($dst)
            $writer.Write($newAl)
            $writer.Close(); $dst.Close(); $src.Close()
            continue
        }

        $outEntry = $outZip.CreateEntry($name, [IO.Compression.CompressionLevel]::Optimal)
        $dst = $outEntry.Open()
        if ($name -eq "NavxManifest.xml") {
            $reader = New-Object IO.StreamReader($src)
            $xml = $reader.ReadToEnd()
            $reader.Close()
            $xml = [regex]::Replace($xml, 'Version="1\.0\.2\.\d+"', "Version=`"$TargetVersion`"", 1)
            $writer = New-Object IO.StreamWriter($dst)
            $writer.Write($xml)
            $writer.Close()
        } else {
            $src.CopyTo($dst)
        }
        $dst.Close(); $src.Close()
    }

    $inZip.Dispose(); $outZip.Dispose(); $inMs.Dispose()
    if (-not $replaced) { throw "StaffPortalCodeunit not found inside $SourceApp" }

    $newZip = $outMs.ToArray(); $outMs.Dispose()
    Write-NavxApp -Path $OutApp -header $navx.Header -zipBytes $newZip
    Write-Host "Built $OutApp ($((Get-Item $OutApp).Length) bytes)" -ForegroundColor Green
}

Set-Location $ErpFolder
Write-Host "Working folder: $ErpFolder"

$outName = "Technology Associates EA Ltd_BC24_TA App_$TargetVersion.app"
$outPath = Join-Path $ErpFolder $outName
$alPath = Join-Path $ErpFolder "StaffPortalCodeunit.Codeunit.al"

# Prefer already-copied 923; else build from 922 + AL on the server.
if (-not (Test-Path $outPath)) {
    $base = @(
        (Join-Path $ErpFolder "Technology Associates EA Ltd_BC24_TA App_1.0.2.923.app"),
        (Join-Path $ErpFolder "Technology Associates EA Ltd_BC24_TA App_1.0.2.922.app"),
        (Join-Path $ErpFolder "Technology Associates EA Ltd_BC24_TA App_1.0.2.921.app")
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $base) { throw "No .app in $ErpFolder — copy 922 or 923 from Mac Desktop\Erp" }
    if (-not (Test-Path $alPath)) { throw "Missing $alPath — copy StaffPortalCodeunit.Codeunit.al to Erp folder" }
    Build-923App -SourceApp $base -AlFile $alPath -OutApp $outPath
}

if (-not (Test-Path $outPath)) { throw "App file missing: $outPath" }
Write-Host "Using: $outPath ($((Get-Item $outPath).Length) bytes)"

Show-Apps "Before publish"

Write-Host "`nPublishing..." -ForegroundColor Yellow
Publish-NAVApp -Path $outPath -ServerInstance $ServerInstance -SkipVerification

Show-Apps "After publish (must show $TargetVersion IsPublished=True)"

$published = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $AppName -Publisher $Publisher |
    Where-Object { $_.Version -eq [version]$TargetVersion -and $_.IsPublished }

if (-not $published) {
    throw @"
Publish did not register $TargetVersion.
Check:
  1) File size on server matches Mac (~7,613,474 bytes for 923)
  2) Re-copy $outName via AnyDesk (no rename/spaces)
  3) Run: Get-EventLog -LogName Application -Newest 20 | Where-Object Source -like '*NAV*'
"@
}

Write-Host "`nSyncing tenant default..." -ForegroundColor Yellow
Sync-NAVApp -ServerInstance $ServerInstance -Tenant default -Name $AppName -Publisher $Publisher -Version $TargetVersion

Write-Host "`nRunning data upgrade..." -ForegroundColor Yellow
Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant default -Name $AppName -Publisher $Publisher -Version $TargetVersion

Show-Apps "After upgrade (923 IsInstalled=True)"

$installed = Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant default -TenantSpecificProperties -Name $AppName |
    Where-Object { $_.Version -eq [version]$TargetVersion -and $_.IsInstalled }

if (-not $installed) { throw "Upgrade finished but $TargetVersion is not installed on tenant default" }

Write-Host "`nDONE. Republish CuStaffPortal (Codeunit 50049) in BC Web Services, then test leave cancel." -ForegroundColor Green
