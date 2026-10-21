# DIAGNOSE + test publish. Run in BC Administration Shell AS ADMIN.
# Copy to Desktop\Erp with 921.app present.
$ErrorActionPreference = "Continue"
Set-Location "$env:USERPROFILE\Desktop\Erp"
$si = "BC240"
$name = "BC24_TA App"
$pub = "Technology Associates EA Ltd"

Write-Host "`n=== FILES ===" -ForegroundColor Cyan
Get-ChildItem *.app | Sort-Object LastWriteTime -Descending | Select-Object -First 8 Name, Length, LastWriteTime | Format-Table -AutoSize

Write-Host "`n=== INSTALLED / PUBLISHED (top 8) ===" -ForegroundColor Cyan
Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub |
  Sort-Object Version -Descending | Select-Object -First 8 Version, IsPublished, IsInstalled | Format-Table -AutoSize

Write-Host "`n=== TEST A: re-publish 921 unchanged ===" -ForegroundColor Yellow
try {
  Publish-NAVApp -Path ".\Technology Associates EA Ltd_BC24_TA App_1.0.2.921.app" -ServerInstance $si -SkipVerification
  Write-Host "921 Publish cmdlet completed" -ForegroundColor Green
} catch { Write-Host "921 Publish ERROR: $_" -ForegroundColor Red }

Write-Host "`n=== TEST B: build 930 on server (version bump ONLY, no AL change) ===" -ForegroundColor Yellow
$src = ".\Technology Associates EA Ltd_BC24_TA App_1.0.2.921.app"
$ver = "1.0.2.930"
$out = ".\Technology Associates EA Ltd_BC24_TA App_$ver.app"

if (Test-Path $src) {
  Add-Type -AssemblyName System.IO.Compression
  $bytes = [IO.File]::ReadAllBytes((Resolve-Path $src))
  $header = $bytes[0..39]
  $zipBytes = $bytes[40..($bytes.Length - 1)]
  $inMs = New-Object IO.MemoryStream(,$zipBytes)
  $outMs = New-Object IO.MemoryStream
  $inZip = New-Object IO.Compression.ZipArchive($inMs, [IO.Compression.ZipArchiveMode]::Read)
  $outZip = New-Object IO.Compression.ZipArchive($outMs, [IO.Compression.ZipArchiveMode]::Create, $true)
  foreach ($entry in $inZip.Entries) {
    $n = if ($entry.FullName -eq "perm/file1_%5BContent_Types%5D.xml") { "perm/file1_[Content_Types].xml" } else { $entry.FullName }
    $oe = $outZip.CreateEntry($n, [IO.Compression.CompressionLevel]::Optimal)
    $s = $entry.Open(); $d = $oe.Open()
    if ($n -eq "NavxManifest.xml") {
      $r = New-Object IO.StreamReader($s); $xml = $r.ReadToEnd(); $r.Close()
      $xml = [regex]::Replace($xml, 'Version="1\.0\.2\.\d+"', "Version=`"$ver`"", 1)
      $w = New-Object IO.StreamWriter($d); $w.Write($xml); $w.Close()
    } else { $s.CopyTo($d) }
    $d.Close(); $s.Close()
  }
  $inZip.Dispose(); $outZip.Dispose(); $inMs.Dispose()
  $nz = $outMs.ToArray(); $outMs.Dispose()
  $nb = [BitConverter]::GetBytes([int64]$nz.Length)
  for ($i = 0; $i -lt 8; $i++) { $header[28 + $i] = $nb[$i] }
  $final = New-Object byte[] ($header.Length + $nz.Length)
  [Array]::Copy($header, 0, $final, 0, $header.Length)
  [Array]::Copy($nz, 0, $final, $header.Length, $nz.Length)
  [IO.File]::WriteAllBytes((Join-Path (Get-Location) $out), $final)
  Write-Host "Built $out ($($final.Length) bytes)" -ForegroundColor Green

  try {
    Publish-NAVApp -Path $out -ServerInstance $si -SkipVerification
    Write-Host "930 Publish cmdlet completed" -ForegroundColor Green
  } catch { Write-Host "930 Publish ERROR: $_" -ForegroundColor Red }

  $p930 = Get-NAVAppInfo -ServerInstance $si -Name $name -Publisher $pub | Where-Object { $_.Version -eq [version]$ver }
  if ($p930) {
    Write-Host "930 FOUND in Get-NAVAppInfo:" -ForegroundColor Green
    $p930 | Format-List Name, Version, IsPublished, IsInstalled
    if ($p930.IsPublished) {
      Write-Host "Syncing 930..." -ForegroundColor Yellow
      Sync-NAVApp -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version $ver
      Start-NAVAppDataUpgrade -ServerInstance $si -Tenant default -Name $name -Publisher $pub -Version $ver
    }
  } else {
    Write-Host "930 NOT in Get-NAVAppInfo after Publish — repack publish is broken on this server" -ForegroundColor Red
  }
} else {
  Write-Host "Missing 921.app" -ForegroundColor Red
}

Write-Host "`n=== ALL versions matching 928/930/927 ===" -ForegroundColor Cyan
Get-NAVAppInfo -ServerInstance $si | Where-Object { $_.Name -eq $name -and $_.Version -ge [version]"1.0.2.920" } |
  Sort-Object Version -Descending | Format-Table Version, Publisher, IsPublished, IsInstalled -AutoSize

Write-Host "`n=== Recent NAV event log ===" -ForegroundColor Cyan
Get-WinEvent -FilterHashtable @{LogName='Application'; Level=2,3; StartTime=(Get-Date).AddHours(-2)} -MaxEvents 15 -ErrorAction SilentlyContinue |
  Where-Object { $_.ProviderName -match 'NAV|Business|Microsoft-Dynamics' } |
  Select-Object TimeCreated, ProviderName, Message | Format-List

Write-Host "`nDONE — paste ALL output back." -ForegroundColor Green
