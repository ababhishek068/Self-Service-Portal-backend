ABH PORTAL 1.0.3.378 - UPDATE FROM THE CURRENT 1.0.3.377 SUITE
Build v224 - BC employee profile sync

INCLUDED
Backend, React portal, locked production Node dependencies and Windows launchers.
BC profile AL SOURCE PATCH for Nitish is in:
  deploy\businesscentral\profile-source\READ-ME-NITISH.txt
No compiled BC app is included in this release.

PROFILE FIXES
- Correct BC field mapping: full name, job ID, marital status, contract type,
  employee type, actual contract dates, contact details and organisation.
- Displays only populated fields and sections; no dash cards or guessed values.
- Numeric options become captions; real zero balances remain visible.
- Complete kin names, qualifications, employment history and assigned assets.
- Employee identity comes from the signed-in session; BC child reads are scoped.
- Source failures show retry messages; missing data is not confused with failure.
- Additional data requires Nitish to build/publish the included AL source patch
  against the latest app. Until then the existing BC endpoints supply partial
  data, including Zerihun's job ID, marital status and contract information.
- The previously included leave, borrowing PDF and Store portal safeguards
  remain. Annual leave calculations are unchanged.

STORE APPROVAL STATUS
Installing this portal does not publish BC code. Preserve the previously
supplied Store guard fix in the BC app. The reported approval failure still
requires validation against the actual published app and BC workflow in UAT.
This profile package does not claim to resolve that server-side error.

VALIDATION
195 backend tests pass. Frontend production build and local browser checks
cover populated/empty fields, zero balances, contract dates, partial failures,
attachment failures and mobile layout. AL source compiles locally.
Expanded AL profile execution and Windows startup require UAT verification.

UPGRADE ON THE SAME SERVER
1. Keep the current 377 folder and configuration intact for rollback.
2. Extract the full ZIP to C:\ABH-Portal-COMPLETE-1.0.3.378.
3. Copy the existing SelfServiceSuite\SelfServiceBackend\.env from 377 into
   the same subfolder in 378. Preserve its BC URLs, company and credentials.
   If used, also copy data\attendance-mac-registry.json.
4. Run VERIFY-SUITE.bat from the new folder.
5. Stop the old "ABH Smart ESSP" task or manually started server.
6. Run INSTALL-AUTOSTART.bat from the NEW folder as Administrator. It updates
   the scheduled task and stops the process using port 4000 during the switch.
   For a manual start, disable the scheduled task and run START-ABH-PORTAL.bat.
7. Check http://127.0.0.1:4000/api/portal-build shows v224 and 1.0.3.378.
8. Hard-refresh the browser; verify My Profile using the AL handoff checklist.

NEW PRODUCTION SERVER
Install the supported Node.js version used by the current deployment.
Supply a .env for the production BC instance/company. Do not copy UAT settings
unchanged onto production. No server credentials or .env are bundled.

ROLLBACK
Stop the new portal task; run INSTALL-AUTOSTART.bat from the retained 377 folder.
This changes the portal only. BC upgrades follow your BC backup/rollback process.

CHECKSUM
A separate .sha256.txt validates the ZIP. SHA256SUMS.txt lists packaged files.
