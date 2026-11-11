# Advance Payment rename — Nitish review

**BC app:** `1.0.3.625`  
**Portal package:** `1.0.3.509` (`v348`)

## Intent

ABH no longer uses the word **Imprest** in the employee / finance UI.

| Portal menu | BC objects (unchanged names) | UI caption now |
|---|---|---|
| HR → Salary Advance Request | `Staff Advance Header` (50880) | Salary Advance (existing) |
| Finance → Advance Payment | `Imprest Header` (50891) + SOAP imprest methods | **Advance Payment** |
| Finance → Advance Settlement | `Imprest Surrender Header` | **Advance Settlement** (was Advance Surrender) |

## What changed in BC

- **Captions / ToolTips only** on role centers, list/card pages, and portal OData queries.
- Object names, table IDs, OptionMembers, SOAP method names, and data stay **Imprest\*** for compatibility.
- Queries used by the portal (`Imprest Header`, `Imprest Lines`, surrender queries) show Advance Payment / Advance Settlement captions.

## What changed in the portal

- Nav/routes: `/finance/advance-payment`, `/finance/advance-settlement` (old imprest / advance-surrender URLs redirect).
- Module API keys remain `imprest` / `imprestSurrender` so existing BC documents keep working.
- Salary Advance Request aligned to ESSP Advance Request DOCX (purpose by division, justification, activity dates, ETB via % of salary).

## Please verify

1. Funds Management RC: menus say Advance Payment / Advance Settlement.
2. Open an Advance Payment card/list — caption is Advance Payment; post/approve still works.
3. Open Advance Settlement — link to posted advance still works.
4. Portal Salary Advance Request create/submit; amount from % of basic salary.
5. Portal Advance Payment create lines (destination rates) + Advance Settlement.
6. Approvals list filters show Advance Payment / Advance Settlement labels.

## Do not

- Rename table/page **object** names without a data migration plan.
- Change OptionMembers that still store `Imprest` in the database.
