# Leave Flow — Production Checklist (v1.0.3.46 / 25 Jul 2026)

## Felix — Business Central (publish first)

1. Open `HIJRA-BC-AL-FILES` (or `hijraERP/Hijra`) in VS Code.
2. Publish these objects (F5 to UAT, then Production when signed off):

| File | Object | Why |
|------|--------|-----|
| `HR3/HR/HRLeaveApplication.Table.al` | Table 50532 | Calendar-scoped balance + employee-card earned days (fixes LV00125) |
| `NEWCHANGES/StaffPortalCodeunit.Codeunit.al` | Codeunit 50049 | Half Day = Normal, Validate Days Applied on create, LV00001 numbering |
| `staffPortal/query/HrEmployee.Query.al` | Query 50090 | Employment type column (if not yet published) |

3. After publish, cancel bad test records (LV00117, LV00125, etc.) and re-test fresh.

## IT — Portal suite deploy

1. Deploy `HIJRA-1.0.3.46-COMPLETE-SUITE.zip` (or rebuild from repo).
2. Copy existing `.env` — do **not** overwrite BC credentials.
3. Run `START-HIJRA-PORTAL.bat` (or `start-suite.bat`).
4. Hard refresh browser (Ctrl+F5).
5. Confirm build stamp: `GET /api/health` → `v1.0.3.46`.

## Production smoke test (15 min)

### A. Balance display
- [ ] Login as employee with known annual leave balance (e.g. E0083).
- [ ] HR → Leave Request → select **Annual Leave (0001)**.
- [ ] Available balance matches BC employee card **Annual Leave balance**.

### B. Create full-day leave (2 days)
- [ ] Apply 2 days, Half Day = **Normal**, valid reliever, reason filled.
- [ ] Submit → draft created with **Days Applied = 2**, start/end/return dates populated.
- [ ] BC card LV00xxx shows balance fields populated (not all 0.00).
- [ ] Request Approval → status **Pending Approval**.

### C. Approval deduction
- [ ] Approver approves in BC or portal.
- [ ] Employee annual balance **−2** (not −0.5).
- [ ] HR Leave Allocation shows negative adjustment of **2** days.

### D. Half-day leave
- [ ] Apply 0.5 day (Morning) on annual leave only.
- [ ] Approve → balance **−0.5**.

### E. Validation guards
- [ ] Apply more days than balance → blocked (portal + BC).
- [ ] Second pending leave of same type → blocked.
- [ ] Sick/medical leave without attachment → blocked.

### F. Cancel
- [ ] Cancel open/pending leave → status Cancelled, no balance deduction.

## Root causes fixed

| Issue | Fix location |
|-------|----------------|
| Days Applied blank / dates 0001-01-01 | StaffPortalCodeunit: Validate Days Applied on create |
| 0.5 deduction for 2-day leave | StaffPortalCodeunit: Select Whether Half Day = Normal |
| Earned days −0.328… error | HRLeaveApplication.Table: card balance + calendar filter |
| Portal balance ≠ BC card | Backend resolveBcLeaveBalance (unchanged, now validated server-side) |
| Sick attachment only for code SICK | Portal + API: requiresMedicalAttachment by type name |

## Rollback

- BC: republish previous extension `.app` from backup.
- Portal: redeploy previous COMPLETE-SUITE zip + `.env`.
