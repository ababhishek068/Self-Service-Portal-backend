# Advance Settlement — Portal (BC 1.0.3.636+)

ESSP **Advance Settlement** = BC **Advance Surrender** (`imprest-surrender` / table 50884).

**Requirement:** `docs/ESSP-BC-Service-Requirement-Advance-Settlement.docx`  
**BC handoff:** `docs/Advance-Settlement-BC-Portal-Handoff.md` / `docs/Portal-Handoff-1.0.3.636.md`

## Portal UI

- Route: `/finance/advance-settlement` (old surrender URLs redirect)
- Create form matches ESSP Petty Cash style (brand header + ESSP badge)
- Advance lookup uses **`PortalAdvanceSettlementContext` → `settleableAdvances`** only (approved + paid)

## SOAP used on create

1. `ImprestSurrenderHeader` — create against selected advance  
2. `PortalAdvanceSettlementAddExpense` — each expense line (category + description + amount)  
3. `PortalAdvanceSettlementSave` — refund date/reference, claim justification, declaration, remarks  
4. Attachments — existing upload (table 50884)  
5. `RequestImprestSurrenderApproval` — after draft review (stricter settlement validation)

## Outcomes

| Outcome | Portal collects |
|---------|-----------------|
| `fullySettled` | Declaration |
| `refundDue` | Refund date, payment reference, proof attachment |
| `additionalClaim` | Justification (≥3), supporting docs |

## API routes

- `GET /api/advance-settlement/context?surrenderNo=`  
- `POST /api/advance-settlement/save`  
- `POST /api/advance-settlement/expenses`
