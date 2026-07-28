HIJRA SELF SERVICE — COMPLETE SUITE FINAL v1.0.3.52
==================================================
26 July 2026 — Deploy ONCE. All fixes included.

WHAT IS IN THIS ZIP
-------------------
  SelfServiceSuite/SelfServiceBackend   dist + public + deploy scripts
  SelfServiceSuite/SelfServicePortal    portal source + dist
  BC-AL/                                AL files for Felix (Business Central)

ALL FIXES IN THIS BUILD
-----------------------
  [LOGIN]     No localhost baked in — works on 10.30.4.23:4000 (Network Error fixed)
  [LEAVE]     Balance uses BC formula: (Allocated + Reimbursed) - Taken
  [LEAVE]     Create does NOT auto-request approval (no ghost LV numbers)
  [LEAVE]     Removed portal block on "pending leave of same type" (BC decides)
  [DASHBOARD] Annual leave balance reads from BC GetLeaveBalance (not 0)

READ FIRST: INSTALL.txt
