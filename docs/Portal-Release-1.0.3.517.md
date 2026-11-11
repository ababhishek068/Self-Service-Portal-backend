# Portal 1.0.3.517 (v356) — fixes on top of 1.0.3.516, BC 1.0.3.636/637

No BC change. Same SOAP as 516 (Nitish's published 636 APIs). Replaces `ABH-Portal-COMPLETE-1.0.3.516.zip`.

## What was wrong in 516

| Area | Problem |
|------|---------|
| OT Stage 1 | The portal threw away BC's Stage 1 number: BC created `OTR-…`, the Overtime Request page stored `OTW-…` with a local Supervisor → HR → Authorized Manager chain. The Superior got the request twice. The "Request overtime payment" button sent `OTW-…`, which BC rejects. Edit, Withdraw and Delete never reached BC. |
| OT Stage 2 approvals | BC Stage 2 approval entries (table 53655) also came through the OData queue as a second row typed "Local Purchase". The Stage 2 approval screen had no lines, hours or steps, so a Superior without the generic approver role could not approve. Decided Stage 2 requests never showed under Approved/Rejected Documents. |
| OT Stage 2 form | "Work completed on" was taken from the first overtime date, and "remarks" were the Stage 1 reasons. There was no input for either. The picker raced against the Stage 1 list and fell back to old local `OTW-…` requests, which BC cannot pay. Editing a draft payment lost its Stage 1 link. Submit was blocked by the Stage 1 FAD setup, not by Stage 2 routing. Text still said LM → FD → HR → Finance. |
| Advance Settlement | `/advance-settlement/*` accepted any settlement number and a caller-supplied employee no., so another employee's draft could be changed. Edit on a settlement draft makes BC re-copy the advance lines, which wiped the expense lines. The detail screen showed no reconciliation and gave no way to complete refund, claim or declaration fields before Request Approval. |
| Staff Claim | No change needed: Medical is filtered from Staff Claims, and Medical Claim still uses `FetchMedicalClaimAmountPolicy`. |

## What changed

- Stage 1: BC is the source of truth. The portal row takes the BC number, status, Superior → FAD steps and `canRequestPayment`. Withdraw and Delete call `PortalOvertimeWithdraw` / `PortalOvertimeDelete`. The local copy is never queued for approval.
- Stage 2: approval entries on table 53655 are kept out of the OData queue. Queue item, detail (Stage 1 lines, hours, work date, Superior step) and decided history come from `PortalOTPayment*`. The detail route is limited to the employee and their Superior. The form gets "Work completed on" and "Employee remarks" inputs, the picker lists only BC `canRequestPayment` requests, and routing comes from `PortalOTPaymentContext`.
- Advance Settlement: owner check on context, save and expenses; the employee no. always comes from the session; `declarationConfirmed` is parsed strictly. Header Edit is hidden on settlements. The detail screen has a BC reconciliation panel, and on drafts a form to complete refund date and reference, claim justification and the declaration (`PortalAdvanceSettlementSave`).

## Test notes

- Backend: 297 tests, 296 pass (the 1 failure is the known `staffClaim saveLine params`). 6 new tests in `overtimeRequests.test.ts` cover the two-stage behaviour.
- API smoke against a stub BC: 20/20 on 517; 9/20 on the shipped 516 code.
- Not run on UAT (no working BC credentials on the Mac). On UAT, check: (1) WSDL lists `PortalAdvanceSettlement*` and `PortalOTPayment*`; (2) an unpaid advance is not offered for settlement; (3) Stage 1 submit shows an `OTR-…` number and appears once in the Superior's queue; (4) Stage 2 approve without a justification is refused.

## After deploying

If 516 was used, Stage 1 requests saved on 516 have `OTW-…` numbers in `data/overtime-work-requests.json` while BC holds the matching `OTR-…`. Cancel those BC requests (or let the employees resubmit on 517).
