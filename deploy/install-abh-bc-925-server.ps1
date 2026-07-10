# BUILD on the BC server (fixes Mac-repack publish failure) then Publish + Sync + Upgrade.
# Copy to C:\Users\Administrator\Desktop\Erp\:
#   install-abh-bc-925-server.ps1
#   StaffPortalCodeunit.Codeunit.al
#   Technology Associates EA Ltd_BC24_TA App_1.0.2.922.app  (base — already on server)
#
# Run in Business Central Administration Shell AS ADMINISTRATOR:
#   cd $env:USERPROFILE\Desktop\Erp
#   Set-ExecutionPolicy -Scope Process Bypass -Force
#   .\install-abh-bc-925-server.ps1

param(
    [string]$ErpFolder = "$env:USERPROFILE\Desktop\Erp",
    [string]$ServerInstance = "BC240",
    [string]$TargetVersion = "1.0.2.925",
    [string]$Publisher = "Technology Associates EA Ltd",
    [string]$AppName = "BC24_TA App"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression

function Show-Apps([string]$Label) {
    Write-Host "`n=== $Label ===" -ForegroundColor Cyan
    Get-NAVAppInfo -ServerInstance $ServerInstance -Name $AppName -Publisher $Publisher |
        Sort-Object Version -Descending |
        Select-Object -First 6 Name, Version, IsPublished, IsInstalled |
        Format-Table -AutoSize
}

function Build-AppOnServer {
    param([string]$SourceApp, [string]$AlFile, [string]$OutApp, [string]$Version)

    $targetAl = "src/src/src/src/src/src/src/src/src/src/NEWCHANGES/StaffPortalCodeunit.Codeunit.al"
    $newAl = [IO.File]::ReadAllText($AlFile)
    if ($newAl -notmatch "action = 'delete'") { throw "StaffPortalCodeunit.Codeunit.al missing leave cancel fix" }

    $bytes = [IO.File]::ReadAllBytes($SourceApp)
    if ([Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne "NAVX") { throw "Not NAVX: $SourceApp" }
    $header = $bytes[0..39]
    $zipBytes = $bytes[40..($bytes.Length - 1)]

    $inMs = New-Object IO.MemoryStream(,$zipBytes)
    $outMs = New-Object IO.MemoryStream
    $inZip = New-Object IO.Compression.ZipArchive($inMs, [IO.Compression.ZipArchiveMode]::Read)
    $outZip = New-Object IO.Compression.ZipArchive($outMs, [IO.Compression.ZipArchiveMode]::Create, $true)

    $replaced = $false
    foreach ($entry in $inZip.Entries) {
        $name = $entry.FullName
        if ($name -eq "perm/file1_%5BContent_Types%5D.xml") { $name = "perm/file1_[Content_Types].xml" }

        $level = [IO.Compression.CompressionLevel]::Optimal
        $outEntry = $outZip.CreateEntry($name, $level)
        $src = $entry.Open()
        $dst = $outEntry.Open()

        if ($name -eq $targetAl) {
            $replaced = $true
            $writer = New-Object IO.StreamWriter($dst)
            $writer.Write($newAl)
            $writer.Close()
        }
        elseif ($name -eq "NavxManifest.xml") {
            $reader = New-Object IO.StreamReader($src)
            $xml = $reader.ReadToEnd()
            $reader.Close()
            $xml = [regex]::Replace($xml, 'Version="1\.0\.2\.\d+"', "Version=`"$Version`"", 1)
            $writer = New-Object IO.StreamWriter($dst)
            $writer.Write($xml)
            $writer.Close()
        }
        else {
            $src.CopyTo($dst)
        }
        $dst.Close(); $src.Close()
    }

    $inZip.Dispose(); $outZip.Dispose(); $inMs.Dispose()
    if (-not $replaced) { throw "StaffPortalCodeunit not found in $SourceApp" }

    $newZip = $outMs.ToArray(); $outMs.Dispose()
    $sizeBytes = [BitConverter]::GetBytes([int64]$newZip.Length)
    for ($i = 0; $i -lt 8; $i++) { $header[28 + $i] = $sizeBytes[$i] }

    $final = New-Object byte[] ($header.Length + $newZip.Length)
    [Array]::Copy($header, 0, $final, 0, $header.Length)
    [Array]::Copy($newZip, 0, $final, $header.Length, $newZip.Length)
    [IO.File]::WriteAllBytes($OutApp, $final)
    Write-Host "Built on server: $OutApp ($($final.Length) bytes)" -ForegroundColor Green
}

Set-Location $ErpFolder
Write-Host "ABH BC install $TargetVersion (server-built package)" -ForegroundColor Cyan

$alPath = Join-Path $ErpFolder "StaffPortalCodeunit.Codeunit.al"
$outPath = Join-Path $ErpFolder ("Technology Associates EA Ltd_BC24_TA App_{0}.app" -f $TargetVersion)

if (-not (Test-Path $alPath)) {
    throw "Copy StaffPortalCodeunit.Codeunit.al to $ErpFolder from Mac Desktop\Erp"
}

$base = @(
    (Join-Path $ErpFolder "Technology Associates EA Ltd_BC24_TA App_1.0.2.922.app"),
    (Join-Path $ErpFolder "Technology Associates EA Ltd_BC24_TA App_1.0.2.921.app"),
    (Join-Path $ErpFolder "Technology Associates EA Ltd_BC24_TA App_1.0.2.920.app")
) | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $base) { throw "Need base .app (922 or 921) in $ErpFolder" }

Build-AppOnServer -SourceApp $base -AlFile $alPath -OutApp $outPath -Version $TargetVersion

Show-Apps "Before publish"

Write-Host "Publishing $TargetVersion ..." -ForegroundColor Yellow
$fullPath = (Resolve-Path $outPath).Path
Publish-NAVApp -Path $fullPath -ServerInstance $ServerInstance -SkipVerification

# Check with and without IsPublished filter
$pub = Get-NAVAppInfo -ServerInstance $ServerInstance -Name $AppName -Publisher $Publisher |
    Where-Object { $_.Version -eq [version]$TargetVersion }

if (-not $pub) {
    Write-Host "Event log (last NAV errors):" -ForegroundColor Red
    Get-EventLog -LogName Application -Newest 15 -ErrorAction SilentlyContinue |
        Where-Object { $_.Source -match 'NAV|Business' } |
        Select-Object TimeGenerated, EntryType, Message |
        Format-List
    throw "Publish did not register $TargetVersion. Base was $base"
}

if (-not $pub.IsPublished) {
    throw "Version $TargetVersion exists but IsPublished=False — check BC event log"
}

Write-Host "Published OK" -ForegroundColor Green

Sync-NAVApp -ServerInstance $ServerInstance -Tenant default -Name $AppName -Publisher $Publisher -Version $TargetVersion
Start-NAVAppDataUpgrade -ServerInstance $ServerInstance -Tenant default -Name $AppName -Publisher $Publisher -Version $TargetVersion

$installed = Get-NAVAppInfo -ServerInstance $ServerInstance -Tenant default -TenantSpecificProperties -Name $AppName |
    Where-Object { $_.Version -eq [version]$TargetVersion -and $_.IsInstalled }

if (-not $installed) { throw "Upgrade failed — $TargetVersion not installed" }

Show-Apps "DONE"
Write-Host "Republish CuStaffPortal (50049) in Web Services." -ForegroundColor Green
