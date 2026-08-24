@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo VERIFY DEPLOY - HIJRA v1.0.3.292 COMPLETE SUITE FINAL
if exist "dist\server.js" (echo [OK] dist\server.js) else (echo [FAIL] dist\server.js)
findstr /M /C:"1.0.3.292" dist\portalApi.js >nul 2>&1 && echo [OK] backend v1.0.3.292 || echo [FAIL] backend version
findstr /M /C:"preferPageOriginWhenRemote" public\assets\*.js >nul 2>&1 && echo [OK] login network fix || echo [WARN] portal build
findstr /M /C:"leave-request?application=" public\assets\*.js >nul 2>&1 && echo [OK] leave View action || echo [WARN] leave View
findstr /M /C:"cannot apply a new leave while another" dist\staff.js >nul 2>&1 && echo [FAIL] duplicate block present || echo [OK] duplicate block removed
findstr /M /C:"countResolvedPendingLeaveApplications" dist\staff.js >nul 2>&1 && echo [OK] HR leave pending fix || echo [WARN] HR leave pending fix
findstr /M /C:"leaveTypeDescriptionForDisplay" dist\portalApi.js >nul 2>&1 && echo [OK] Leave approval type description || echo [WARN] Leave type description
findstr /M /C:"Leave quantity" public\assets\*.js >nul 2>&1 && echo [OK] Leave approval quantity display || echo [WARN] Leave quantity display
findstr /M /C:"Business Central has marked this application as pending" public\assets\*.js >nul 2>&1 && echo [OK] Pending leave approval workflow fallback || echo [WARN] Leave approval workflow fallback
findstr /M /C:"Location / Coordinates" public\assets\*.js >nul 2>&1 && echo [FAIL] Attendance location column present || echo [OK] Attendance location column removed
findstr /M /C:"trainingCourseLookupOption" dist\portalApi.js >nul 2>&1 && echo [OK] Training course code/title relation || echo [WARN] Training course relation
findstr /M /C:"resolvePettyCashDefaultsFromEmployee" dist\portalApi.js >nul 2>&1 && echo [OK] Finance petty cash profile dims || echo [WARN] petty cash dims
findstr /M /C:"dailyRate" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest daily rate || echo [WARN] imprest daily rate
findstr /M /C:"ERP returned no daily rate" public\assets\*.js >nul 2>&1 && echo [OK] Fresh ERP rate calculation per draft || echo [WARN] ERP rate draft reset
findstr /M /C:"surrender-preview" dist\portalApi.js >nul 2>&1 && echo [OK] Finance imprest surrender preview || echo [WARN] surrender preview
findstr /M /C:"enrichImprestSurrenderFromSourceImprest" dist\portalApi.js >nul 2>&1 && echo [OK] Finance surrender enrichment || echo [WARN] surrender enrichment
findstr /M /C:"01 Jan 0001" public\assets\*.js >nul 2>&1 && echo [OK] Imprest surrender unavailable details hidden || echo [WARN] surrender empty-detail filter
findstr /M /C:"employeeFinanceSectorFromRecord" dist\employeeProfile.js >nul 2>&1 && echo [OK] Staff Claim employee sector fallback || echo [WARN] Staff Claim sector fallback
findstr /M /C:"Hospital Category" public\assets\*.js >nul 2>&1 && echo [OK] Staff Claim flow-aware line columns || echo [WARN] Staff Claim line columns
findstr /M /C:"enrichApprovalStepsWithCommentLines" dist\leaveApprovalSteps.js >nul 2>&1 && echo [OK] Approval rejection notes || echo [WARN] rejection notes
findstr /M /C:"profile/trainings" dist\portalApi.js >nul 2>&1 && echo [OK] HR profile trainings tab || echo [WARN] profile trainings
findstr /M /C:"yearsOfService" dist\portalApi.js >nul 2>&1 && echo [OK] HR profile important dates || echo [WARN] profile dates
findstr /M /C:"listStatusFilter" public\assets\*.js >nul 2>&1 && echo [OK] Finance list status filter || echo [WARN] list status filter
findstr /M /C:"Requisition_Type" public\assets\*.js >nul 2>&1 && echo [OK] Facility fuel BC field aliases || echo [WARN] fuel field aliases
findstr /M /C:"travel-destinations" dist\portalApi.js >nul 2>&1 && echo [OK] Finance travel destinations lookup || echo [WARN] travel destinations
findstr /M /C:"QyGatePassReturns" dist\portalApi.js >nul 2>&1 && echo [OK] Gate Pass actual return details || echo [WARN] Gate Pass return details
findstr /M /C:"Source document" public\assets\*.js >nul 2>&1 && echo [OK] Complete Gate Pass Log columns || echo [WARN] Gate Pass Log columns
findstr /M /C:"PURCHASE_ITEM_NOT_IN_FINALIZED_BUDGET" dist\staffModules.js >nul 2>&1 && echo [OK] Purchase finalized-budget correction || echo [WARN] Purchase budget correction
findstr /M /C:"Receipt confirmation" public\assets\*.js >nul 2>&1 && echo [OK] Complete Store Requisition flow || echo [WARN] Store Requisition flow
findstr /M /C:"Search table records" public\assets\*.js >nul 2>&1 && echo [OK] shared list search || echo [WARN] shared list search
if exist "public\index.html" (echo [OK] public) else (echo [FAIL] public)
if exist ".env" (echo [OK] .env) else (echo [FAIL] .env MISSING)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt)
echo Check: http://10.30.4.23:4000/api/health
pause
