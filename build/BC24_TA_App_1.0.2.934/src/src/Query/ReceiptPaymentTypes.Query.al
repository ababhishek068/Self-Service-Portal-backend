query 50074 "Receipt & Payment Types"
{
    Caption = 'Receipt & Payment Types';
    QueryType = Normal;

    elements
    {
        dataitem(ReceiptsandPaymentTypes; "Receipts and Payment Types")
        {
            column(AccountType; "Account Type") { }
            column(AllowReceiptDisbursment; "Allow Receipt Disbursment") { }
            column(BankAccount; "Bank Account") { }
            column(Blocked; Blocked) { }
            column(CalculateRetention; "Calculate Retention") { }
            column("Code"; "Code") { }
            column(CouncilClaim; "Council Claim?") { }
            column(CustomerPaymentOnAccount; "Customer Payment On Account") { }
            column(DefaultAmount; "Default Amount") { }
            column(DefaultDimension; "Default Dimension") { }
            column(DefaultGrouping; "Default Grouping") { }
            column(Description; Description) { }
            column(DirectExpense; "Direct Expense") { }
            column(GLAccount; "G/L Account") { }
            column(LecturerClaim; "Lecturer Claim?") { }
            column(ManualAmount; "Manual Amount") { }
            column(PAYETaxChargeable; "PAYE Tax Chargeable") { }
            column(PAYETaxCode; "PAYE Tax Code") { }
            column(PaymentReference; "Payment Reference") { }
            column(PendingVoucher; "Pending Voucher") { }
            column(PumpAttendance; "Pump Attendance") { }
            column(RequireAdmissionNo; "Require Admission No") { }
            column(RetentionCode; "Retention Code") { }
            column(RetentionFeeApplicable; "Retention Fee Applicable") { }
            column(RetentionFeeCode; "Retention Fee Code") { }
            column(Subsistence; "Subsistence?") { }
            column(SystemCreatedAt; SystemCreatedAt) { }
            column(SystemCreatedBy; SystemCreatedBy) { }
            column(SystemId; SystemId) { }
            column(SystemModifiedAt; SystemModifiedAt) { }
            column(SystemModifiedBy; SystemModifiedBy) { }
            column(TelephoneAllowance; "Telephone Allowance?") { }
            column(TransationRemarks; "Transation Remarks") { }
            column("Type"; "Type") { }
            column(UsePAYETable; "Use PAYE Table") { }
            column(VATChargeable; "VAT Chargeable") { }
            column(VATCode; "VAT Code") { }
            column(VATWithheldCode; "VAT Withheld Code") { }
            column(WithholdingTaxChargeable; "Withholding Tax Chargeable") { }
            column(WithholdingTaxCode; "Withholding Tax Code") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
