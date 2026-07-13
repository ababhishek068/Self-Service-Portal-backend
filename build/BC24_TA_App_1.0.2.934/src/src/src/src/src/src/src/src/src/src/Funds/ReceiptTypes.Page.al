Page 50869 "Receipt Types"
{
    PageType = Worksheet;
    SourceTable = "Receipts and Payment Types";
    SourceTableView = where(Type = const(Receipt));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(VATChargeable; Rec."VAT Chargeable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Chargeable field.';
                }
                field(WithholdingTaxChargeable; Rec."Withholding Tax Chargeable")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Chargeable field.';
                }
                field(VATCode; Rec."VAT Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Code field.';
                }
                field(WithholdingTaxCode; Rec."Withholding Tax Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Code field.';
                }
                field(DefaultGrouping; Rec."Default Grouping")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Grouping field.';
                }
                field(GLAccount; Rec."G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
                field(PendingVoucher; Rec."Pending Voucher")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pending Voucher field.';
                }
                field(BankAccount; Rec."Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Account field.';
                }
                field("Default Amount"; Rec."Default Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Amount field.';
                }
                field("Default Dimension"; Rec."Default Dimension")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Default Dimension field.';
                }
                field(TransationRemarks; Rec."Transation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transation Remarks field.';
                }
                field(PaymentReference; Rec."Payment Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Reference field.';
                }
                field(CustomerPaymentOnAccount; Rec."Customer Payment On Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Payment On Account field.';
                }
                field(DirectExpense; Rec."Direct Expense")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Direct Expense field.';
                }
                field(CalculateRetention; Rec."Calculate Retention")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calculate Retention field.';
                }
                field(RetentionCode; Rec."Retention Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retention Code field.';
                }
                field("Pump Attendance"; Rec."Pump Attendance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pump Attendance field.';
                }
                field(AllowReceiptDisbursment; Rec."Allow Receipt Disbursment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Receipt Disbursment field.';
                }
                field(RequireAdmissionNo; Rec."Require Admission No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Require Admission No field.';
                }
            }
        }
    }

    actions { }
}

