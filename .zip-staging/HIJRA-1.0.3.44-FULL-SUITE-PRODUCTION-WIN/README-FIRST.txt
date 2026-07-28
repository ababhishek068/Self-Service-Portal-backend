HIJRA SELF SERVICE PORTAL - v1.0.3.44 (25 July 2026) — RESTORED WORKING BUILD
================================================================================

CONTAINS: SelfServiceBackend + SelfServicePortal  (Business Central NOT included)

*** IMPORTANT — WHERE THE UI LIVES ***
The backend SERVES the portal UI from:
    SelfServiceSuite\SelfServiceBackend\public\
Copying files into SelfServicePortal\self-service-portal\dist has NO effect.
This package already contains the correct UI in \public.

DEPLOY (Windows server 10.30.4.23)
----------------------------------
1. STOP the running portal (close its console window).
2. Copy your existing .env into:
       SelfServiceSuite\SelfServiceBackend\.env
   (.env is intentionally NOT shipped — it holds your BC credentials)
3. Double-click START-HIJRA-PORTAL.bat
   (first run installs backend node_modules — needs internet)
4. Browser: CTRL+SHIFT+R (hard refresh)
5. Double-click VERIFY-DEPLOY.bat  -> must show index-k6-MjTel.js
6. Profile page -> Portal build must contain "training + employment type"

WHAT THIS BUILD INCLUDES
------------------------
  - Full Training Need Assessment form (Others option for custom course names)
  - SaveTrainingAssessment companion store (BC AL required)
  - Imprest Surrender amount labels + backend enrichment
  - Employment type label fix on Profile

TRAINING — HOW TO AVOID BC ERRORS
---------------------------------
  - Pick a course from the ERP dropdown, OR
  - Select "Others (not in the ERP list)" and type the name below
  - Do NOT type a custom name without selecting Others — BC will reject it

BUSINESS CENTRAL (separate — give to Felix)
-------------------------------------------
Use HIJRA-AL-FIXES-2026-07-25.zip on your Desktop.
