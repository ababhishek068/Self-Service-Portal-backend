Page 50907 "Payment List"
{

    Caption = 'Payment List';
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Payments Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Payee; Rec.Payee)
                {
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(OnBehalfOf; Rec."On Behalf Of")
                {
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(Posted; Rec.Posted)
                {
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(DatePosted; Rec."Date Posted")
                {
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(TimePosted; Rec."Time Posted")
                {
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(PostedBy; Rec."Posted By")
                {
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field(TotalPaymentAmount; Rec."Total Payment Amount")
                {
                    ToolTip = 'Specifies the value of the Total Payment Amount field.';
                }
                field(PayingBankAccount; Rec."Paying Bank Account")
                {
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PaymentType; Rec."Payment Type")
                {
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field(BankName; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Select; Rec.Select)
                {
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field(TotalVATAmount; Rec."Total VAT Amount")
                {
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
                field(TotalWitholdingTaxAmount; Rec."Total Witholding Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Total Witholding Tax Amount field.';
                }
                field(TotalNetAmount; Rec."Total Net Amount")
                {
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field(CurrentStatus; Rec."Current Status")
                {
                    ToolTip = 'Specifies the value of the Current Status field.';
                }
                field(ChequeNo; Rec."Cheque No.")
                {
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field(PayMode; Rec."Pay Mode")
                {
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(PaymentReleaseDate; Rec."Payment Release Date")
                {
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field(NoPrinted; Rec."No. Printed")
                {
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field(VATBaseAmount; Rec."VAT Base Amount")
                {
                    ToolTip = 'Specifies the value of the VAT Base Amount field.';
                }
                field(ExchangeRate; Rec."Exchange Rate")
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field(CurrencyReciprical; Rec."Currency Reciprical")
                {
                    ToolTip = 'Specifies the value of the Currency Reciprical field.';
                }
                field(CurrentSourceACBal; Rec."Current Source A/C Bal.")
                {
                    ToolTip = 'Specifies the value of the Current Source A/C Bal. field.';
                }
                field(CancellationRemarks; Rec."Cancellation Remarks")
                {
                    ToolTip = 'Specifies the value of the Cancellation Remarks field.';
                }
                field(RegisterNumber; Rec."Register Number")
                {
                    ToolTip = 'Specifies the value of the Register Number field.';
                }
                field(FromEntryNo; Rec."From Entry No.")
                {
                    ToolTip = 'Specifies the value of the From Entry No. field.';
                }
                field(ToEntryNo; Rec."To Entry No.")
                {
                    ToolTip = 'Specifies the value of the To Entry No. field.';
                }
                field(InvoiceCurrencyCode; Rec."Invoice Currency Code")
                {
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                }
                field(TotalPaymentAmountLCY; Rec."Total Payment Amount LCY")
                {
                    ToolTip = 'Specifies the value of the Total Payment Amount LCY field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(ChequeType; Rec."Cheque Type")
                {
                    ToolTip = 'Specifies the value of the Cheque Type field.';
                }
                field(TotalRetentionAmount; Rec."Total Retention Amount")
                {
                    ToolTip = 'Specifies the value of the Total Retention Amount field.';
                }
                field(PaymentNarration; Rec."Payment Narration")
                {
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                }
                field(TotalPAYEAmount; Rec."Total PAYE Amount")
                {
                    ToolTip = 'Specifies the value of the Total PAYE Amount field.';
                }
                field(ReferenceNo; Rec."Reference No.")
                {
                    ToolTip = 'Specifies the value of the Reference No. field.';
                }
                field(ChequePrinted; Rec."Cheque Printed")
                {
                    ToolTip = 'Specifies the value of the Cheque Printed field.';
                }
                field(ApplytoDocumentType; Rec."Apply to Document Type")
                {
                    ToolTip = 'Specifies the value of the Apply to Document Type field.';
                }
                field(ApplytoDocumentNo; Rec."Apply to Document No")
                {
                    ToolTip = 'Specifies the value of the Apply to Document No field.';
                }
                field(ImprestNo; Rec."Imprest No.")
                {
                    ToolTip = 'Specifies the value of the Imprest No. field.';
                }
                field(ClaimNo; Rec."Claim No.")
                {
                    ToolTip = 'Specifies the value of the Claim No. field.';
                }
                field(PFNo; Rec."PF No")
                {
                    ToolTip = 'Specifies the value of the PF No field.';
                }
                field(FinancialPeriod; Rec."Financial Period")
                {
                    ToolTip = 'Specifies the value of the Financial Period field.';
                }
                field(BudgetedAmount; Rec."Budgeted Amount")
                {
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field(ActualExpenditure; Rec."Actual Expenditure")
                {
                    ToolTip = 'Specifies the value of the Actual Expenditure field.';
                }
                field(CommittedAmount; Rec."Committed Amount")
                {
                    ToolTip = 'Specifies the value of the Committed Amount field.';
                }
                field(BudgetBalance; Rec."Budget Balance")
                {
                    ToolTip = 'Specifies the value of the Budget Balance field.';
                }
                field(BankCriteria; Rec."Bank Criteria")
                {
                    ToolTip = 'Specifies the value of the Bank Criteria field.';
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                }
                field(ContractAmount; Rec."Contract Amount")
                {
                    ToolTip = 'Specifies the value of the Contract Amount field.';
                }
                field(ContractBalance; Rec."Contract Balance")
                {
                    ToolTip = 'Specifies the value of the Contract Balance field.';
                }
                field(CertificateNo; Rec."Certificate No.")
                {
                    ToolTip = 'Specifies the value of the Certificate No. field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
                field(TotalVATWithholdingAmount; Rec."Total VAT Withholding Amount")
                {
                    ToolTip = 'Specifies the value of the Total VAT Withholding Amount field.';
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field(VendorName; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field(PostedCount; Rec."Posted Count")
                {
                    ToolTip = 'Specifies the value of the Posted Count field.';
                }
                field(PaymentScheduleNo; Rec."Payment Schedule No")
                {
                    ToolTip = 'Specifies the value of the Payment Schedule No field.';
                }
            }
        }
    }

    actions { }
}
