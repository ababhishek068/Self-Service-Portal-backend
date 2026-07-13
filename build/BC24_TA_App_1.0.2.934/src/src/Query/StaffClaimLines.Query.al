query 50073 "Staff Claim Lines"
{
    Caption = 'Staff Claim Lines';
    QueryType = Normal;

    elements
    {
        dataitem(StaffClaimLines; "Staff Claim Lines")
        {
            column(AccountName; "Account Name") { }
            column(AccountNo; "Account No:") { }
            column(ActualExpenditure; "Actual Expenditure") { }
            column(ActualSpent; "Actual Spent") { }
            column(AdvanceType; "Advance Type") { }
            column(Amount; Amount) { }
            column(AmountLCY; "Amount LCY") { }
            column(Applyto; "Apply to") { }
            column(ApplytoID; "Apply to ID") { }
            column(AttendeeOrganizationNames; "Attendee/Organization Names") { }
            column(BankPettyCash; "Bank/Petty Cash") { }
            column(BudgetaryControlAC; "Budgetary Control A/C") { }
            column(CampusCode; "Campus Code") { }
            column(CashSurrenderAmt; "Cash Surrender Amt") { }
            column(ClaimFromImprest; "Claim From Imprest") { }
            column(ClaimReceiptNo; "Claim Receipt No") { }
            column(Committed; Committed) { }
            column(CurrencyCode; "Currency Code") { }
            column(CurrencyFactor; "Currency Factor") { }
            column(DateIssued; "Date Issued") { }
            column(DateTaken; "Date Taken") { }
            column(DeptVchNo; "Dept. Vch. No.") { }
            column(DueDate; "Due Date") { }
            column(ExpenditureDate; "Expenditure Date") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(ImprestHolder; "Imprest Holder") { }
            column(LecturerNo; "Lecturer No") { }
            column(LineNo; "Line No.") { }
            column(MRNo; "M.R. No") { }
            column(MedicalAmount; "Medical Amount") { }
            column(No; No) { }
            column(NoofHours; "No. of Hours") { }
            column(Purpose; Purpose) { }
            column(SemesterCode; "Semester Code") { }
            column(SettlementType; "Settlement Type") { }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code") { }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code") { }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code") { }
            column(StaffNo; "Staff No") { }
            column(SurrenderDate; "Surrender Date") { }
            column(SurrenderDocNo; "Surrender Doc No.") { }
            column(Surrendered; Surrendered) { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TypeofSurrender; "Type of Surrender") { }
            column(UnitCode; "Unit Code") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
