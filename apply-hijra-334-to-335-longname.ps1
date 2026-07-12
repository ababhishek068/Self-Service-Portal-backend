<#
    Guarded patch: HIJRA BC24_TA App 1.0.2.334 -> 1.0.2.335
    Scope: ONLY the long-name (Code[20]) overflow fixes on Imprest Surrender and Staff Claims.
           Wraps raw assignments in CopyStr(value, 1, MaxStrLen(field)). No payroll changes.

    Usage (run in the REAL project folder that built .334, e.g. ...\hijraERP\Hijra):
        powershell -ExecutionPolicy Bypass -File .\apply-hijra-334-to-335-longname.ps1 -ProjectRoot .

    It backs up every file it edits and ABORTS without changing anything if the expected
    code is not found (protects against running on the wrong / already-changed source).
#>
param([Parameter(Mandatory = $true)][string]$ProjectRoot)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path $ProjectRoot).Path
$appJson = Join-Path $root 'app.json'
if (-not (Test-Path $appJson)) { throw "app.json not found in $root - point -ProjectRoot at the AL project folder." }

function Find-One([string]$fileName) {
    $hits = @(Get-ChildItem -Path $root -Recurse -Filter $fileName -File -ErrorAction SilentlyContinue)
    if ($hits.Count -eq 0) { throw "Required file not found under project: $fileName" }
    if ($hits.Count -gt 1) { throw "Ambiguous: $($hits.Count) copies of $fileName found. Resolve before patching." }
    return $hits[0].FullName
}

# Each edit: the raw string that must exist, and its CopyStr replacement.
function New-Edit($from, $to) { [pscustomobject]@{ From = $from; To = $to } }
function Cs($field, $value) { "$field := CopyStr($value, 1, MaxStrLen($field));" }

$plan = @{
    'ImprestSurrenderHeader.Table.al' = @(
        New-Edit '"District Name" := departmentsRec."Department Name";'      (Cs '"District Name"'  'departmentsRec."Department Name"')
        New-Edit '"District Name" := Emp."District Name";'                   (Cs '"District Name"'  'Emp."District Name"')
        New-Edit '"Branch Name" := Emp."Branch- Name";'                      (Cs '"Branch Name"'    'Emp."Branch- Name"')
        New-Edit '"Division Name" := Emp."Division Name";'                   (Cs '"Division Name"'  'Emp."Division Name"')
        New-Edit '"Division Name" := branchesdivRec."Division/Branch Name";' (Cs '"Division Name"'  'branchesdivRec."Division/Branch Name"')
    )
    'StaffClaimsHeader.Table.al' = @(
        New-Edit '"Sector Name" := "HR-EMP"."Sector Name";'                  (Cs '"Sector Name"'   '"HR-EMP"."Sector Name"')
        New-Edit '"District Name" := "HR-EMP"."District Name";'              (Cs '"District Name"' '"HR-EMP"."District Name"')
        New-Edit '"Division Name" := "HR-EMP"."Division Name";'              (Cs '"Division Name"' '"HR-EMP"."Division Name"')
        New-Edit '"District Name" := departmentsRec."Department Name";'      (Cs '"District Name"' 'departmentsRec."Department Name"')
    )
}

$backupRoot = Join-Path $root ("_backup-before-335-" + (Get-Date -Format 'yyyyMMdd-HHmmss'))
$changes = @()

# ---- Phase 1: validate everything first, change nothing ----
foreach ($fileName in $plan.Keys) {
    $path = Find-One $fileName
    $text = Get-Content -Raw -LiteralPath $path
    foreach ($edit in $plan[$fileName]) {
        $hasRaw = $text.Contains($edit.From)
        $hasDone = $text.Contains($edit.To)
        if (-not $hasRaw -and -not $hasDone) {
            throw "In $fileName the expected code was not found (raw or already-fixed):`n  $($edit.From)`nNo files changed."
        }
    }
    $changes += [pscustomobject]@{ File = $fileName; Path = $path }
}

# ---- Phase 2: apply (with backups) ----
New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
foreach ($c in $changes) {
    $text = Get-Content -Raw -LiteralPath $c.Path
    Copy-Item -LiteralPath $c.Path -Destination (Join-Path $backupRoot $c.File) -Force
    $applied = 0
    foreach ($edit in $plan[$c.File]) {
        if ($text.Contains($edit.From)) {
            $text = $text.Replace($edit.From, $edit.To)  # replaces all occurrences
            $applied++
        }
    }
    Set-Content -LiteralPath $c.Path -Value $text -NoNewline
    Write-Host ("Patched {0}: {1} assignment(s) wrapped in CopyStr" -f $c.File, $applied) -ForegroundColor Green
}

# ---- Phase 3: bump version 1.0.2.334 -> 1.0.2.335 ----
$manifest = Get-Content -Raw -LiteralPath $appJson
$bumped = [regex]::Replace($manifest, '"version"\s*:\s*"[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"', '"version": "1.0.2.335"', 1)
Copy-Item -LiteralPath $appJson -Destination (Join-Path $backupRoot 'app.json') -Force
Set-Content -LiteralPath $appJson -Value $bumped -NoNewline

Write-Host ""
Write-Host "Done. Version set to 1.0.2.335. Backups: $backupRoot" -ForegroundColor Cyan
Write-Host "Next: open this folder in VS Code -> AL: Download Symbols -> AL: Package -> publish the .335 app." -ForegroundColor Cyan
