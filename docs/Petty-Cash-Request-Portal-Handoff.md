# Petty Cash Request — ESSP form + BC (1.0.3.632)

Getachew: *“we looking for petty cash request not for payment”* + *“Approval also not yet configured”*.

## What was wrong

Portal Petty Cash line used **Payment Type** lookup showing **Supplier / Vendor WHT** codes.  
ESSP form needs **Expense Category** for a staff petty cash **request** (purpose, amount ETB, required date, attachments, declaration).

## BC changes (1.0.3.632)

1. `Receipts and Payment Types`.`Use for Petty Cash` — Finance marks real expense categories.
2. Petty Cash payment lines only look up types with **Use for Petty Cash = Yes**.
3. SOAP `PortalPettyCashExpenseCategories()` — JSON list for the Expense Category dropdown.
4. Query `Petty Cash Expense Types` (OData).
5. `FnPettyCashLine` rejects Supplier/Vendor payment codes.
6. Submit validates purpose, at least one line, attachment; clearer error if workflow not enabled.

## BC admin (Finance) — baby steps

1. Tell Me → **Receipts and Payment Types**
2. For each petty cash expense (stationery, transport, tea, etc.):
   - Type = **Payment**
   - Account Type = **G/L Account**
   - Set G/L Account
   - Tick **Use for Petty Cash**
3. Leave SUPPLIER / VEND* / WHT codes **unticked**
4. Tell Me → **Workflows**
   - Enable **Payment** approval workflow used by Petty Cash  
   - If Payment Voucher shares the same event, set **Event Condition**: `Payment Type = Petty Cash` on a dedicated copy named e.g. *Petty Cash Request approval*
5. **Approval User Setup** → Approver ID for portal users / cashiers

## Portal must do

1. Label field **Expense Category** (not Payment Type).
2. Call `PortalPettyCashExpenseCategories()` (or OData `Petty Cash Expense Types`) — do **not** list all Receipt & Payment Types.
3. Form fields (ESSP mockup):
   - Employee Name / Staff No / Department (auto)
   - Request Date, Required Date
   - Expense Category, Purpose, Amount, Currency **ETB**
   - Supporting documents
   - Declaration checkbox before Submit
4. Map Purpose → `Payment Narration` via `FnPettyCashHeader`
5. Map Expense Category + Amount → `FnPettyCashLine`
6. Submit → `RequestPettyCashApproval`

## Existing SOAP (unchanged names)

- `FnPettyCashHeader` / `FnPettyCashLine` / `RequestPettyCashApproval` / `CancelPettyCashRequest`
