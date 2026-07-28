@echo off
setlocal EnableDelayedExpansion
echo ============================================
echo HIJRA - FIX ALL DUPLICATE AL FILES
echo Run this from: hijraERP\Hijra folder
echo ============================================
echo.

set "ROOT=%~dp0"
if exist "%ROOT%src\Query" set "SEARCH=%ROOT%src"
if exist "%ROOT%..\src\Query" set "SEARCH=%ROOT%..\src"
if not defined SEARCH set "SEARCH=%ROOT%src"

echo Searching under: %SEARCH%
echo.

set COUNT=0

REM --- Delete portal queries from src\Query (keep only staffPortal\query) ---
for %%F in (
  QyAssetTransfer.Query.al
  QyWorkTicketFlight.Query.al
  QyPortalFuelMaintExtra.Query.al
  QyProcurementPlanHeader.Query.al
  QyProcurementPlanLines.Query.al
  QyGatePassTransferShipments.Query.al
  QyGatePassAssetTransfers.Query.al
  HrLeaveAllocationPortal.Query.al
) do (
  if exist "%SEARCH%\Query\%%F" (
    del /f "%SEARCH%\Query\%%F"
    echo DELETED: Query\%%F
    set /a COUNT+=1
  )
)

REM --- Delete portal tables from src\Table ---
for %%F in (
  PortalWorkTicketFlight.Table.al
  PortalFuelMaintExtra.Table.al
  PortalProcurementPlanHeader.Table.al
  PortalProcurementPlanLine.Table.al
) do (
  if exist "%SEARCH%\Table\%%F" (
    del /f "%SEARCH%\Table\%%F"
    echo DELETED: Table\%%F
    set /a COUNT+=1
  )
)

REM --- Delete portal codeunits from src\codeunit if wrongly copied ---
for %%F in (
  PortalAttachmentsMgt.Codeunit.al
  PortalFacilityMgt.Codeunit.al
  PortalAssetTransferMgt.Codeunit.al
) do (
  if exist "%SEARCH%\codeunit\%%F" (
    del /f "%SEARCH%\codeunit\%%F"
    echo DELETED: codeunit\%%F
    set /a COUNT+=1
  )
)

REM --- Delete ANY query files inside staffPortal\facilityUat ---
if exist "%SEARCH%\staffPortal\facilityUat" (
  for %%F in ("%SEARCH%\staffPortal\facilityUat\*.Query.al") do (
    del /f "%%F"
    echo DELETED from facilityUat: %%~nxF
    set /a COUNT+=1
  )
)

REM --- Delete wrong files in employeeExit ---
if exist "%SEARCH%\staffPortal\employeeExit\PortalAttachmentsMgt.Codeunit.al" (
  del /f "%SEARCH%\staffPortal\employeeExit\PortalAttachmentsMgt.Codeunit.al"
  echo DELETED: employeeExit\PortalAttachmentsMgt.Codeunit.al
  set /a COUNT+=1
)

REM --- Delete HR3 NewChanges duplicate subfolders if exist ---
if exist "%SEARCH%\HR3\NewChanges\Codeunit" (
  rmdir /s /q "%SEARCH%\HR3\NewChanges\Codeunit"
  echo DELETED folder: HR3\NewChanges\Codeunit
  set /a COUNT+=1
)
if exist "%SEARCH%\HR3\NewChanges\Table" (
  rmdir /s /q "%SEARCH%\HR3\NewChanges\Table"
  echo DELETED folder: HR3\NewChanges\Table
  set /a COUNT+=1
)
if exist "%SEARCH%\HR3\NewChanges\Query" (
  rmdir /s /q "%SEARCH%\HR3\NewChanges\Query"
  echo DELETED folder: HR3\NewChanges\Query
  set /a COUNT+=1
)

REM --- Also check nested src\src paths ---
for /d %%D in ("%SEARCH%\src") do (
  if exist "%%D\Query\QyAssetTransfer.Query.al" (
    del /f "%%D\Query\QyAssetTransfer.Query.al"
    echo DELETED nested: %%D\Query\QyAssetTransfer.Query.al
    set /a COUNT+=1
  )
)

echo.
echo Done. Deleted !COUNT! duplicate items.
echo.
echo NOW:
echo  1. Replace staffPortal folder from PASTE-INTO-Hijra-src\staffPortal
echo  2. Copy HR3 files (StaffPortalCodeunit + HRLeaveApplication)
echo  3. AL Package again
echo.
pause
