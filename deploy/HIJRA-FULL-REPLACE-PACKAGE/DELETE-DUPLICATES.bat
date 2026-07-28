@echo off
echo HIJRA - removing duplicate portal AL files...
cd /d "%~dp0"
for /r %%F in (QyAssetTransfer.Query.al QyWorkTicketFlight.Query.al QyPortalFuelMaintExtra.Query.al QyProcurementPlanHeader.Query.al QyProcurementPlanLines.Query.al QyGatePassTransferShipments.Query.al QyGatePassAssetTransfers.Query.al) do (
  echo %%F | findstr /i "\\staffPortal\\query\\" >nul || (if exist "%%F" del /f "%%F" && echo Deleted: %%F)
)
for /r %%F in (PortalWorkTicketFlight.Table.al PortalFuelMaintExtra.Table.al PortalProcurementPlanHeader.Table.al PortalProcurementPlanLine.Table.al) do (
  echo %%F | findstr /i "\\staffPortal\\facilityUat\\" >nul || (if exist "%%F" del /f "%%F" && echo Deleted: %%F)
)
for /r %%F in (*.Query.al) do (
  echo %%F | findstr /i "\\staffPortal\\facilityUat\\" >nul && (del /f "%%F" && echo Deleted from facilityUat: %%F)
)
echo Done. Now paste PASTE-INTO-Hijra-src folders.
pause
