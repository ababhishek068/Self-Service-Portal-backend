Page 50859 "Posted Interbank Transfer List"
{
    CardPageID = "Posted Interbank Transfers UP";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "InterBank Transfers";
    SourceTableView = where(Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(PayMode; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field(ReceivingAccount; Rec."Receiving Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Account field.';
                }
                field(ReceivedFrom; Rec."Received From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(ReceivingBankAccountName; Rec."Receiving Bank Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Bank Account Name field.';
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
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(PayingAccount; Rec."Paying Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Account field.';
                }
                field(BankType; Rec."Bank Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Type field.';
                }
                field(SourceDepotCode; Rec."Source Depot Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Funtion Code field.';
                }
                field(SourceDepartmentCode; Rec."Source Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Budget Center Code field.';
                }
                field(SourceDepotName; Rec."Source Depot Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Depot Name field.';
                }
                field(ReceivingDepotCode; Rec."Receiving Depot Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Depot Code field.';
                }
                field(ReceivingDepartmentCode; Rec."Receiving Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Department Code field.';
                }
                field(ReceivingDepotName; Rec."Receiving Depot Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Depot Name field.';
                }
                field(ReceivingDepartmentName; Rec."Receiving Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Department Name field.';
                }
                field(SourceDepartmentName; Rec."Source Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Department Name field.';
                }
                field(PayingBankAccountName; Rec."Paying  Bank Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying  Bank Account Name field.';
                }
                field(InterBankTemplateName; Rec."Inter Bank Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inter Bank Template Name field.';
                }
                field(InterBankJournalBatch; Rec."Inter Bank Journal Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inter Bank Journal Batch field.';
                }
                field(ReceivingTransferType; Rec."Receiving Transfer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Transfer Type field.';
                }
                field(SourceTransferType; Rec."Source Transfer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Transfer Type field.';
                }
                field(CurrencyCodeDestination; Rec."Currency Code Destination")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code Destination field.';
                }
                field(CurrencyCodeSource; Rec."Currency Code Source")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code Source field.';
                }
                field(Amount2; Rec."Amount 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount 2 field.';
                }
                field(ExchRateSource; Rec."Exch. Rate Source")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exch. Rate Source field.';
                }
                field(ExchRateDestination; Rec."Exch. Rate Destination")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exch. Rate Destination field.';
                }
                field(Reciprical1; Rec."Reciprical 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reciprical 1 field.';
                }
                field(Reciprical2; Rec."Reciprical 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reciprical 2 field.';
                }
                field(Balance1; Rec."Balance 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance 1 field.';
                }
                field(Balance2; Rec."Balance 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance 2 field.';
                }
                field(CurrentSourceACBal; Rec."Current Source A/C Bal.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Source A/C Bal. field.';
                }
                field(RegisterNumber; Rec."Register Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register Number field.';
                }
                field(FromNo; Rec."From No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From No field.';
                }
                field(ToNo; Rec."To No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To No field.';
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
                field(ShortcutDimension3Code1; Rec."Shortcut Dimension 3 Code1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code1; Rec."Shortcut Dimension 4 Code1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim31; Rec.Dim31)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim31 field.';
                }
                field(Dim41; Rec.Dim41)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim41 field.';
                }
                field(SendingResponsibilityCenter; Rec."Sending Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sending Responsibility Center field.';
                }
                field(RecieptResponsibilityCenter; Rec."Reciept Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reciept Responsibility Center field.';
                }
                field(SendingRespCentre; Rec."Sending Resp Centre")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sending Resp Centre field.';
                }
                field(ReceiptRespCentre; Rec."Receipt Resp Centre")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Resp Centre field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(RequestAmtLCY; Rec."Request Amt LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Request Amt LCY field.';
                }
                field(PayAmtLCY; Rec."Pay Amt LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Amt LCY field.';
                }
                field(ExternalDocNo; Rec."External Doc No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the External Doc No. field.';
                }
                field(TransferReleaseDate; Rec."Transfer Release Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer Release Date field.';
                }
                field(CancelledBy; Rec."Cancelled By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancelled By field.';
                }
                field(DateCancelled; Rec."Date Cancelled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Cancelled field.';
                }
                field(TimeCancelled; Rec."Time Cancelled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Cancelled field.';
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                ApplicationArea = basic;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetRange(No, Rec.No);
                    REPORT.Run(70135460, true, true, Rec);
                    Rec.Reset;
                end;

            }
        }
    }
}

