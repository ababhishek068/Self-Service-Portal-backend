HIJRA SELF SERVICE PORTAL - v1.0.3.50 (26 July 2026) — LEAVE FIX BUILD
========================================================================

WHAT'S FIXED IN THIS BUILD
--------------------------
LEAVE BALANCE
  - All leave types show BC remaining balance (not setup entitlement)
  - Formula: (Allocated Days + Reimbursed Days) − Current Total Leave Taken

LEAVE CREATE
  - No auto-approval on create (fixes "Application does not exist" ghost LV errors)
  - Backend verifies record exists in BC before success response
  - Request Approval is a separate step

BC / FELIX (publish before portal deploy)
-----------------------------------------
  BC-AL/ folder — see INSTALL.txt for file list
  Query HrLeaveAllocationPortal must use ID 52133 (not 50095)

DEPLOY
------
1. STOP portal
2. Backup existing SelfServiceSuite folder
3. Copy dist\ + public\ into SelfServiceBackend (keep .env)
4. START-HIJRA-PORTAL.bat
5. VERIFY-DEPLOY.bat
6. Ctrl+F5 in browser
7. /api/health must show v1.0.3.50
