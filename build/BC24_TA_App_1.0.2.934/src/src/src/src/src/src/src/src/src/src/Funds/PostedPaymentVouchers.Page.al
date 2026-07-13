Page 50888 "Posted Payment Vouchers"
{
    CardPageID = "Posted Payment Header UP";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payments Header";
    SourceTableView = where(Status = filter(Posted));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field(OnBehalfOf; Rec."On Behalf Of")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(DatePosted; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field(TimePosted; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field(PostedBy; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field(TotalPaymentAmount; Rec."Total Payment Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payment Amount field.';
                }
                field(PayingBankAccount; Rec."Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PaymentType; Rec."Payment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(FunctionName; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field(BudgetCenterName; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field(TotalVATAmount; Rec."Total VAT Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
                field(TotalWitholdingTaxAmount; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Witholding Tax Amount field.';
                }
                field(TotalNetAmount; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field(CurrentStatus; Rec."Current Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Status field.';
                }
                field(ChequeNo; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field(PayMode; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(PaymentReleaseDate; Rec."Payment Release Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field(NoPrinted; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field(VATBaseAmount; Rec."VAT Base Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Base Amount field.';
                }
                field(ExchangeRate; Rec."Exchange Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field(CurrencyReciprical; Rec."Currency Reciprical")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Reciprical field.';
                }
                field(CurrentSourceACBal; Rec."Current Source A/C Bal.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Source A/C Bal. field.';
                }
                field(CancellationRemarks; Rec."Cancellation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancellation Remarks field.';
                }
                field(RegisterNumber; Rec."Register Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register Number field.';
                }
                field(FromEntryNo; Rec."From Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Entry No. field.';
                }
                field(ToEntryNo; Rec."To Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Entry No. field.';
                }
                field(InvoiceCurrencyCode; Rec."Invoice Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                }
                field(TotalPaymentAmountLCY; Rec."Total Payment Amount LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payment Amount LCY field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(ChequeType; Rec."Cheque Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Type field.';
                }
                field(TotalRetentionAmount; Rec."Total Retention Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Retention Amount field.';
                }
                field(PaymentNarration; Rec."Payment Narration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                }
                field(TotalPAYEAmount; Rec."Total PAYE Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total PAYE Amount field.';
                }
                field(ReferenceNo; Rec."Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reference No. field.';
                }
                field(ChequePrinted; Rec."Cheque Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Printed field.';
                }
                field(ApplytoDocumentType; Rec."Apply to Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to Document Type field.';
                }
                field(ApplytoDocumentNo; Rec."Apply to Document No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to Document No field.';
                }
                field(ImprestNo; Rec."Imprest No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Imprest No. field.';
                }
                field(ClaimNo; Rec."Claim No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Claim No. field.';
                }
                field(PFNo; Rec."PF No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PF No field.';
                }
            }
        }
        area(Factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(50887),
                              "No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PrintPreview)
            {
                ApplicationArea = Basic;
                Caption = 'Print/Preview';
                Image = PreviewChecks;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                var
                    PVLine: Record "Payment Line";
                    PVReport: Report "Payment Voucher New";
                begin

                    if Rec.Status <> Rec.Status::Approved then
                        Error('You cannot Print until the document is released for approval');

                    PVLine.reset();
                    PVLine.setfilter(No, Rec."No.");
                    if PVLine.find('-') then begin
                        PVReport.SetTableView(PVLine);
                        PVReport.Run();
                    end;

                    CurrPage.Update();
                    CurrPage.SaveRecord();
                end;
            }
        }

    }
}

