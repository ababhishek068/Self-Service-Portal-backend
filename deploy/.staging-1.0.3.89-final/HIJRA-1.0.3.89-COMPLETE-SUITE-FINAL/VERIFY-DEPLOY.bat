@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo VERIFY DEPLOY - HIJRA v1.0.3.89 COMPLETE SUITE FINAL
if exist "dist\server.js" (echo [OK] dist\server.js) else (echo [FAIL] dist\server.js)
findstr /M /C:"1.0.3.89" dist\portalApi.js >nul 2>&1 && echo [OK] backend v1.0.3.89 || echo [FAIL] backend version
findstr /M /C:"preferPageOriginWhenRemote" public\assets\*.js >nul 2>&1 && echo [OK] login network fix || echo [WARN] portal build
findstr /M /C:"leave-request?application=" public\assets\*.js >nul 2>&1 && echo [OK] leave View action || echo [WARN] leave View
findstr /M /C:"cannot apply a new leave while another" dist\staff.js >nul 2>&1 && echo [FAIL] duplicate block present || echo [OK] duplicate block removed
findstr /M /C:"countResolvedPendingLeaveApplications" dist\staff.js >nul 2>&1 && echo [OK] HR leave pending fix || echo [WARN] HR leave pending fix
findstr /M /C:"resolvePettyCashDefaultsFromEmployee" dist\portalApi.js >nul 2>&1 && echo [OK] Finance petty cash profile dims || echo [WARN] petty cash dims
findstr /M /C:"dailyRate" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest daily rate || echo [WARN] imprest daily rate
findstr /M /C:"surrender-preview" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest surrender preview || echo [WARN] surrender preview
findstr /M /C:"enrichImprestSurrenderFromSourceImprest" dist\portalApi.js >nul 2>&1 && echo [OK] Finance surrender enrichment || echo [WARN] surrender enrichment
findstr /M /C:"enrichApprovalStepsWithCommentLines" dist\leaveApprovalSteps.js >nul 2>&1 && echo [OK] Approval rejection notes || echo [WARN] rejection notes
findstr /M /C:"profile/trainings" dist\portalApi.js >nul 2>&1 && echo [OK] HR profile trainings tab || echo [WARN] profile trainings
findstr /M /C:"yearsOfService" dist\portalApi.js >nul 2>&1 && echo [OK] HR profile important dates || echo [WARN] profile dates
findstr /M /C:"listStatusFilter" public\assets\*.js >nul 2>&1 && echo [OK] Finance list status filter || echo [WARN] list status filter
findstr /M /C:"Requisition_Type" public\assets\*.js >nul 2>&1 && echo [OK] Facility fuel BC field aliases || echo [WARN] fuel field aliases
findstr /M /C:"travel-destinations" dist\portalApi.js >nul 2>&1 && echo [OK] Finance travel destinations lookup || echo [WARN] travel destinations
findstr /M /C:"Search table records" public\assets\*.js >nul 2>&1 && echo [OK] shared list search || echo [WARN] shared list search
if exist "public\index.html" (echo [OK] public) else (echo [FAIL] public)
if exist ".env" (echo [OK] .env) else (echo [FAIL] .env MISSING)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt)
echo Check: http://10.30.4.23:4000/api/health
pause
