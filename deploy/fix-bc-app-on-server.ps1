# Fix Mac-built BC .app on the SERVER. Run in Business Central Administration Shell.
param(
    [string]$SourceApp = "$env:USERPROFILE\Desktop\Erp\Technology Associates EA Ltd_BC24_TA App_1.0.2.917.app",
    [string]$TargetVersion = "1.0.2.917"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$bytes = [IO.File]::ReadAllBytes($SourceApp)
if ([Text.Encoding]::ASCII.GetString($bytes, 0, 4) -ne "NAVX") { throw "Not a NAVX app file" }

$header = $bytes[0..39]
$zipBytes = $bytes[40..($bytes.Length - 1)]
$inMs = New-Object IO.MemoryStream(,$zipBytes)
$outMs = New-Object IO.MemoryStream
$inZip = New-Object IO.Compression.ZipArchive($inMs, [IO.Compression.ZipArchiveMode]::Read)
$outZip = New-Object IO.Compression.ZipArchive($outMs, [IO.Compression.ZipArchiveMode]::Create, $true)

$bad = "perm/file1_%5BContent_Types%5D.xml"
$good = "perm/file1_[Content_Types].xml"

foreach ($entry in $inZip.Entries) {
    $name = if ($entry.FullName -eq $bad) { $good } else { $entry.FullName }
    $outEntry = $outZip.CreateEntry($name, [IO.Compression.CompressionLevel]::Optimal)
    $src = $entry.Open()
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
$newZip = $outMs.ToArray(); $outMs.Dispose()

$newSize = [BitConverter]::GetBytes([int64]$newZip.Length)
for ($i = 0; $i -lt 8; $i++) { $header[28 + $i] = $newSize[$i] }

$target = Join-Path (Split-Path $SourceApp -Parent) ("Technology Associates EA Ltd_BC24_TA App_{0}.app" -f $TargetVersion)
$final = New-Object byte[] ($header.Length + $newZip.Length)
[Array]::Copy($header, 0, $final, 0, $header.Length)
[Array]::Copy($newZip, 0, $final, $header.Length, $newZip.Length)
[IO.File]::WriteAllBytes($target, $final)

Write-Host "Fixed: $target ($($final.Length) bytes)"
Write-Host 'Publish-NAVApp -Path ".\Technology Associates EA Ltd_BC24_TA App_'$TargetVersion'.app" -ServerInstance BC240 -SkipVerification'
