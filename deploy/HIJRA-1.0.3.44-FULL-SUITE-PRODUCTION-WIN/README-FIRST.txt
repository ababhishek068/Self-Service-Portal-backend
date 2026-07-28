HIJRA SELF SERVICE PORTAL - v1.0.3.44 (25 July 2026) — UAT SYNC BUILD
=======================================================================

WHAT'S FIXED IN THIS BUILD
--------------------------
PROFILE
  - Date of Birth, Years of Service, Job Grade, Employment Type
HR / TRAINING
  - Training period dates saved and shown on detail
  - Department merged from CuPortalTraining assessment
  - Training Taken tab loads from /api/profile/trainings
EMPLOYEE EXIT + HR LETTERS
  - /api/hr/employee-exit wired to BC CuPortalEmployeeExit
  - /api/hr/service-letters wired to BC CuPortalHrLetters
  - Transfer type removed from Employee Exit transfer form (UAT)
FINANCE
  - Imprest job title on detail, staff-claim approval filter + approver fields
  - Petty Cash Settlement title fix

TRAINING TIP
------------
For custom course names: select "Others (not in the ERP list)" — do not pick
a name from the dropdown if BC rejects it.

DEPLOY
------
1. STOP portal
2. Copy your .env into SelfServiceSuite\SelfServiceBackend\.env
3. START-HIJRA-PORTAL.bat
4. VERIFY-DEPLOY.bat
5. Ctrl+Shift+R in browser
6. Profile -> build must contain "UAT sync"
