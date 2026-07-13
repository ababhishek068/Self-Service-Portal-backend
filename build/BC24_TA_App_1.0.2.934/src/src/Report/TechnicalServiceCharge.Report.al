namespace ABH_UAT_LIVE.ABH_UAT_LIVE;

report 50377 "Technical Service Charge"
{
    ApplicationArea = All;
    Caption = 'Technical Service Charge';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout=Word;
    WordLayout='./Layouts/tservicecharge.docx';
    dataset
    {
        dataitem(PaymentsHeader; "Payments Header")
        {
            column(ActualExpenditure; "Actual Expenditure")
            {
            }
            column(ApplytoDocumentNo; "Apply to Document No")
            {
            }
            column(ApplytoDocumentType; "Apply to Document Type")
            {
            }
            column(BankBalance; "Bank Balance")
            {
            }
            column(BankCriteria; "Bank Criteria")
            {
            }
            column(BankName; "Bank Name")
            {
            }
            column(BudgetBalance; "Budget Balance")
            {
            }
            column(BudgetCenterName; "Budget Center Name")
            {
            }
            column(BudgetedAmount; "Budgeted Amount")
            {
            }
            column(CancellationRemarks; "Cancellation Remarks")
            {
            }
            column(Cashier; Cashier)
            {
            }
            column(CertificateNo; "Certificate No.")
            {
            }
            column(ChequeNo; "Cheque No.")
            {
            }
            column(ChequePrinted; "Cheque Printed")
            {
            }
            column(ChequeType; "Cheque Type")
            {
            }
            column(ClaimNo; "Claim No.")
            {
            }
            column(CommittedAmount; "Committed Amount")
            {
            }
            column(ContractAmount; "Contract Amount")
            {
            }
            column(ContractBalance; "Contract Balance")
            {
            }
            column(ContractNo; "Contract No.")
            {
            }
            column(CreationDocNo; "Creation Doc No.")
            {
            }
            column(CurrencyCode; "Currency Code")
            {
            }
            column(CurrencyFactor; "Currency Factor")
            {
            }
            column(CurrencyReciprical; "Currency Reciprical")
            {
            }
            column(CurrentSourceACBal; "Current Source A/C Bal.")
            {
            }
            column(CurrentStatus; "Current Status")
            {
            }
            column(Date; "Date")
            {
            }
            column(DatePosted; "Date Posted")
            {
            }
            column(Dim3; Dim3)
            {
            }
            column(Dim4; Dim4)
            {
            }
            column(Dim5; Dim5)
            {
            }
            column(DimensionSetID; "Dimension Set ID")
            {
            }
            column(DocumentType; "Document Type")
            {
            }
            column(EmployeeNo; "Employee No")
            {
            }
            column(ExchangeRate; "Exchange Rate")
            {
            }
            column(FinalApproverSeqNo; "Final Approver Seq No")
            {
            }
            column(FinalApproverStatus; "Final Approver Status")
            {
            }
            column(FinancialPeriod; "Financial Period")
            {
            }
            column(FromEntryNo; "From Entry No.")
            {
            }
            column(FullyPaid; "Fully Paid")
            {
            }
            column(FunctionName; "Function Name")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(ImprestNo; "Imprest No.")
            {
            }
            column(InvoiceCurrencyCode; "Invoice Currency Code")
            {
            }
            column(NegotiatedExchangeRate; "Negotiated Exchange Rate")
            {
            }
            column(No; "No.")
            {
            }
            column(NoPrinted; "No. Printed")
            {
            }
            column(NoSeries; "No. Series")
            {
            }
            column(OnBehalfOf; "On Behalf Of")
            {
            }
            column(OpenApproverCount; "Open Approver Count")
            {
            }
            column(PFNo; "PF No")
            {
            }
            column(PaidAmount; "Paid Amount")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(Payee; Payee)
            {
            }
            column(PayingBankAccount; "Paying Bank Account")
            {
            }
            column(PaymentNarration; "Payment Narration")
            {
            }
            column(PaymentReleaseDate; "Payment Release Date")
            {
            }
            column(PaymentScheduleNo; "Payment Schedule No")
            {
            }
            column(PaymentType; "Payment Type")
            {
            }
            column(Posted; Posted)
            {
            }
            column(PostedBy; "Posted By")
            {
            }
            column(PostedCount; "Posted Count")
            {
            }
            column(ReferenceNo; "Reference No.")
            {
            }
            column(RegisterNumber; "Register Number")
            {
            }
            column(RequestType; "Request Type")
            {
            }
            column(ResponsibilityCenter; "Responsibility Center")
            {
            }
            column(Reversed; Reversed)
            {
            }
            column(ReversedPV; "Reversed PV")
            {
            }
            column(SalesPerson; "Sales Person")
            {
            }
            column(Select; Select)
            {
            }
            column(ShiftNo; "Shift No")
            {
            }
            column(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
            {
            }
            column(ShortcutDimension3Code; "Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code; "Shortcut Dimension 4 Code")
            {
            }
            column(ShortcutDimension5Code; "Shortcut Dimension 5 Code")
            {
            }
            column(Status; Status)
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }
            column(TimePosted; "Time Posted")
            {
            }
            column(ToEntryNo; "To Entry No.")
            {
            }
            column(TotalNetAmount; "Total Net Amount")
            {
            }
            column(TotalPAYEAmount; "Total PAYE Amount")
            {
            }
            column(TotalPaymentAmount; "Total Payment Amount")
            {
            }
            column(TotalPaymentAmountLCY; "Total Payment Amount LCY")
            {
            }
            column(TotalRetentionAmount; "Total Retention Amount")
            {
            }
            column(TotalVATAmount; "Total VAT Amount")
            {
            }
            column(TotalVATWithholdingAmount; "Total VAT Withholding Amount")
            {
            }
            column(TotalWitholdingTaxAmount; "Total Witholding Tax Amount")
            {
            }
            column(VATBaseAmount; "VAT Base Amount")
            {
            }
            column(VendorName; "Vendor Name")
            {
            }
            column(VendorNo; "Vendor No.")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
