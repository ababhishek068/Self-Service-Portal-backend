param(
    [Parameter(Mandatory = $true)]
    [string]$HijraProject,
    [switch]$SkipVersionBump,
    [string]$MinimumVersion = '1.0.5.73'
)

$ErrorActionPreference = 'Stop'
$project = (Resolve-Path $HijraProject).Path
$src = Join-Path $project 'src'
$appJson = Join-Path $project 'app.json'
$files = Join-Path $PSScriptRoot 'FILES'

if (-not (Test-Path $src -PathType Container) -or -not (Test-Path $appJson -PathType Leaf)) {
    throw "This is not the Hijra AL project. Expected app.json and src under: $project"
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = Join-Path $project ".hijra-ssp-backup-$stamp"
New-Item -ItemType Directory -Path $backup | Out-Null

function Get-Project-RelativePath([string]$target) {
    $baseUri = New-Object System.Uri(($project.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar))
    $targetUri = New-Object System.Uri($target)
    return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString()).Replace('/', '\')
}

function Backup-Then-Remove([string]$target) {
    if (-not (Test-Path $target)) { return }
    $relative = Get-Project-RelativePath $target
    $saved = Join-Path $backup $relative
    New-Item -ItemType Directory -Force -Path (Split-Path $saved) | Out-Null
    Move-Item -Force -Path $target -Destination $saved
    Write-Host "Removed duplicate: $relative" -ForegroundColor Yellow
}

function Install-File([string]$relative) {
    $source = Join-Path $files $relative
    $target = Join-Path $src $relative
    if (-not (Test-Path $source -PathType Leaf)) {
        throw "Patch file is missing: $source"
    }
    if (Test-Path $target -PathType Leaf) {
        $saved = Join-Path $backup (Join-Path 'src' $relative)
        New-Item -ItemType Directory -Force -Path (Split-Path $saved) | Out-Null
        Copy-Item -Force -Path $target -Destination $saved
    }
    New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
    Copy-Item -Force -Path $source -Destination $target
    Write-Host "Installed: src\\$relative" -ForegroundColor Green
}

function Install-Unique-Hr-File([string]$fileName, [string]$patchRelative) {
    $matches = @(Get-ChildItem -Path $src -Recurse -File -Filter $fileName)
    if ($matches.Count -ne 1) {
        throw "Expected exactly one $fileName below src, found $($matches.Count). Do not guess the HR path."
    }
    $source = Join-Path $files $patchRelative
    $target = $matches[0].FullName
    $relative = Get-Project-RelativePath $target
    $saved = Join-Path $backup $relative
    New-Item -ItemType Directory -Force -Path (Split-Path $saved) | Out-Null
    Copy-Item -Force -Path $target -Destination $saved
    Copy-Item -Force -Path $source -Destination $target
    Write-Host "Installed: $relative" -ForegroundColor Green
}

Write-Host "Backing up changed files to $backup" -ForegroundColor Cyan
Copy-Item -Force -Path $appJson -Destination (Join-Path $backup 'app.json')

# Exact obsolete copies from the earlier full-folder patch. The real attachment
# controller is staffPortal\employeeExit\PortalAttachmentMgt.Codeunit.al (52106).
$obsolete = @(
    'src\staffPortal\facilityUat\PortalAttachmentsMgt.Codeunit.al',
    'src\staffPortal\facilityUat\QyAssetTransfer.Query.al',
    'src\staffPortal\facilityUat\QyFleetVehicles.Query.al',
    'src\staffPortal\facilityUat\QyPortalFuelMaint.Query.al',
    'src\staffPortal\facilityUat\QyProcurementPlan.Query.al',
    'src\staffPortal\facilityUat\QyProcurementPlanLines.Query.al',
    'src\staffPortal\facilityUat\QyWorkTicketFlight.Query.al',
    'src\Query\QyAssetTransfer.Query.al',
    'src\Query\QyPortalFuelMaintExtra.Query.al',
    'src\Query\QyProcurementPlanHeader.Query.al',
    'src\Query\QyProcurementPlanLines.Query.al',
    'src\Query\QyWorkTicketFlight.Query.al',
    'src\staffPortal\query\QyGatePassTransferShipments.Query.al',
    'src\staffPortal\query\QyGatePassAssetTransfers.Query.al'
)
foreach ($relative in $obsolete) {
    Backup-Then-Remove (Join-Path $project $relative)
}

$regularFiles = @(
    'Query\GatePassAssetTransfers.Query.al',
    'Query\GatePassTransferShipments.Query.al',
    'staffPortal\PortalHr.PermissionSet.al',
    'staffPortal\employeeExit\PortalAttachmentMgt.Codeunit.al',
    'staffPortal\employeeExit\PortalEmployeeDataMgt.Codeunit.al',
    'staffPortal\employeeExit\PortalEmployeeExit.PermissionSet.al',
    'staffPortal\employeeExit\PortalEmployeeExitCard.Page.al',
    'staffPortal\employeeExit\PortalEmployeeExitInstall.Codeunit.al',
    'staffPortal\employeeExit\PortalEmployeeExitMgt.Codeunit.al',
    'staffPortal\employeeExit\PortalEmployeeExitRequest.Table.al',
    'staffPortal\employeeExit\PortalEmployeeExitRequests.Page.al',
    'staffPortal\employeeExit\PortalEmployeeExitRoleCenter.PageExt.al',
    'staffPortal\employeeExit\PortalEmployeeExitUpgrade.Codeunit.al',
    'staffPortal\employeeExit\PortalEmployeeExitWorkflow.Codeunit.al',
    'staffPortal\employeeExit\PortalEmployeeTransferSetup.Page.al',
    'staffPortal\employeeExit\PortalEmployeeTransferSetup.Table.al',
    'staffPortal\employeeExit\PortalExitRequestStatus.Enum.al',
    'staffPortal\employeeExit\PortalExitRequestType.Enum.al',
    'staffPortal\hrLetter\PortalHrLetterRequest.Table.al',
    'staffPortal\hrLetter\PortalHrLetterRequestCard.Page.al',
    'staffPortal\hrLetter\PortalHrLetterRequests.Page.al',
    'staffPortal\hrLetter\PortalHrLetterStatus.Enum.al',
    'staffPortal\hrLetter\PortalHrLetterType.Enum.al',
    'staffPortal\hrLetter\PortalHrLetters.PermissionSet.al',
    'staffPortal\hrLetter\PortalHrLettersInstall.Codeunit.al',
    'staffPortal\hrLetter\PortalHrLettersMgt.Codeunit.al',
    'staffPortal\hrLetter\PortalHrLettersRoleCenter.PageExt.al',
    'staffPortal\hrLetter\PortalHrLettersUpgrade.Codeunit.al',
    'staffPortal\facilityUat\PortalAssetTransferMgt.Codeunit.al',
    'staffPortal\facilityUat\PortalFacility.PermissionSet.al',
    'staffPortal\facilityUat\PortalFacilityInstall.Codeunit.al',
    'staffPortal\facilityUat\PortalFacilityMgt.Codeunit.al',
    'staffPortal\facilityUat\PortalFacilityUpgrade.Codeunit.al',
    'staffPortal\facilityUat\PortalFuelMaintExt.TableExt.al',
    'staffPortal\facilityUat\PortalFuelMaintExtra.Table.al',
    'staffPortal\facilityUat\PortalProcurementPlanHeader.Table.al',
    'staffPortal\facilityUat\PortalProcurementPlanLine.Table.al',
    'staffPortal\facilityUat\PortalWorkTicketExt.TableExt.al',
    'staffPortal\facilityUat\PortalWorkTicketFlight.Table.al',
    'staffPortal\query\HrLeaveAllocationPortal.Query.al',
    'staffPortal\query\ApprovalCommentLine.Query.al',
    'staffPortal\query\PettyCashLimitDepartment.Query.al',
    'staffPortal\query\QyAssetTransfer.Query.al',
    'staffPortal\query\QyPortalFuelMaintExtra.Query.al',
    'staffPortal\query\QyProcurementPlanHeader.Query.al',
    'staffPortal\query\QyProcurementPlanLines.Query.al',
    'staffPortal\query\QyWorkTicketFlight.Query.al',
    'staffPortal\query\TrainingApplicationHeader.Query.al',
    'staffPortal\query\TrainingApplicationLInes.Query.al',
    'staffPortal\query\TrainingNeeds.Query.al',
    'staffPortal\training\PortalTrainingAssessment.Table.al',
    'staffPortal\training\PortalTrainingAssessments.Page.al',
    'staffPortal\training\PortalTrainingMgt.Codeunit.al'
)
foreach ($relative in $regularFiles) {
    Install-File $relative
}

Install-Unique-Hr-File 'HRLeaveApplication.Table.al' 'HR-DEEP\HRLeaveApplication.Table.al'
Install-Unique-Hr-File 'StaffPortalCodeunit.Codeunit.al' 'HR-DEEP\StaffPortalCodeunit.Codeunit.al'
Install-Unique-Hr-File 'GatePass.Table.al' 'BASE-DEEP\GatePass.Table.al'

if (-not $SkipVersionBump) {
    $raw = Get-Content -Raw -Path $appJson
    $match = [regex]::Match($raw, '"version"\s*:\s*"(\d+)\.(\d+)\.(\d+)\.(\d+)"')
    if (-not $match.Success) { throw 'Could not read the version in app.json' }
    $incremented = '{0}.{1}.{2}.{3}' -f $match.Groups[1].Value, $match.Groups[2].Value,
        $match.Groups[3].Value, ([int]$match.Groups[4].Value + 1)
    $next = if ([version]$incremented -lt [version]$MinimumVersion) {
        ([version]$MinimumVersion).ToString()
    } else {
        $incremented
    }
    $updated = $raw.Substring(0, $match.Groups[0].Index) +
        ($match.Groups[0].Value -replace [regex]::Escape($match.Groups[1].Value + '.' + $match.Groups[2].Value + '.' + $match.Groups[3].Value + '.' + $match.Groups[4].Value), $next) +
        $raw.Substring($match.Groups[0].Index + $match.Groups[0].Length)
    [IO.File]::WriteAllText($appJson, $updated, (New-Object Text.UTF8Encoding($false)))
    Write-Host "app.json version: $next" -ForegroundColor Cyan
}

$allAl = @(Get-ChildItem -Path $src -Recurse -File -Filter '*.al')
$objectPattern = '(?im)^\s*(codeunit|query|table|tableextension|permissionset|enum|page|pageextension)\s+(\d+)\b'
$objects = foreach ($file in $allAl) {
    foreach ($match in [regex]::Matches((Get-Content -Raw $file.FullName), $objectPattern)) {
        [pscustomobject]@{
            Type = $match.Groups[1].Value.ToLowerInvariant()
            Id = [int]$match.Groups[2].Value
            File = Get-Project-RelativePath $file.FullName
        }
    }
}

function Assert-Object-Count([string]$type, [int]$id, [int]$expected) {
    $found = @($objects | Where-Object { $_.Type -eq $type -and $_.Id -eq $id })
    if ($found.Count -ne $expected) {
        $where = ($found.File -join ', ')
        throw "Validation failed: expected $expected $type object(s) with ID $id; found $($found.Count). $where"
    }
}

Assert-Object-Count 'codeunit' 52106 1
Assert-Object-Count 'table' 50296 1
# Employee Exit is an in-scope HR module. The patch must preserve the complete
# existing implementation instead of silently publishing a partial extension.
foreach ($id in 52100..52101) { Assert-Object-Count 'enum' $id 1 }
Assert-Object-Count 'permissionset' 52100 1
Assert-Object-Count 'table' 52100 1
Assert-Object-Count 'table' 52130 1
foreach ($id in 52100..52101) { Assert-Object-Count 'page' $id 1 }
Assert-Object-Count 'page' 52130 1
Assert-Object-Count 'pageextension' 52100 1
foreach ($id in 52100..52101) { Assert-Object-Count 'codeunit' $id 1 }
foreach ($id in 52103..52106) { Assert-Object-Count 'codeunit' $id 1 }

# Training Request is also in scope and must remain in the Felix project.
Assert-Object-Count 'table' 52120 1
Assert-Object-Count 'page' 52120 1
Assert-Object-Count 'codeunit' 52121 1
Assert-Object-Count 'permissionset' 52122 1
Assert-Object-Count 'query' 50091 1
foreach ($id in 50103..50105) { Assert-Object-Count 'query' $id 1 }
Assert-Object-Count 'query' 52132 1

Assert-Object-Count 'table' 52140 1
Assert-Object-Count 'page' 52140 1
foreach ($id in 52141..52143) { Assert-Object-Count 'codeunit' $id 1 }
foreach ($id in 52144..52145) { Assert-Object-Count 'enum' $id 1 }
Assert-Object-Count 'page' 52146 1
Assert-Object-Count 'pageextension' 52147 1
Assert-Object-Count 'permissionset' 52110 1
Assert-Object-Count 'query' 52133 0
Assert-Object-Count 'tableextension' 52133 1
Assert-Object-Count 'query' 52134 1
foreach ($id in 52160..52161) { Assert-Object-Count 'codeunit' $id 1 }
foreach ($id in 52162..52165) { Assert-Object-Count 'table' $id 1 }
foreach ($id in 52166..52170) { Assert-Object-Count 'query' $id 1 }

Write-Host ''
Write-Host 'PATCH APPLIED AND OBJECT IDS VALIDATED.' -ForegroundColor Green
Write-Host "Backup (recoverable): $backup" -ForegroundColor Cyan
Write-Host 'Next: open this Hijra folder in VS Code and run AL: Package.' -ForegroundColor Cyan
