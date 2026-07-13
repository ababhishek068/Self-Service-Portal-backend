page 50880 "Interbank Transfer"
{
    CardPageID = "Bank & Cash Transfer Request";
    PageType = List;
    SourceTable = "InterBank Transfers";
    SourceTableView = WHERE(Posted = CONST(false), Type = filter(Interbank));
    UsageCategory = lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Receiving Account"; Rec."Receiving Account")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Account field.';
                }
                field("Received From"; Rec."Received From")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Received From field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Receiving Bank Account Name"; Rec."Receiving Bank Account Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Bank Account Name field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field("Paying Account"; Rec."Paying Account")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Paying Account field.';
                }
                field("Bank Type"; Rec."Bank Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Bank Type field.';
                }
                field("Source Depot Code"; Rec."Source Depot Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Funtion Code field.';
                }
                field("Source Department Code"; Rec."Source Department Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Budget Center Code field.';
                }
                field("Source Depot Name"; Rec."Source Depot Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Depot Name field.';
                }
                field("Receiving Depot Code"; Rec."Receiving Depot Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Depot Code field.';
                }
                field("Receiving Department Code"; Rec."Receiving Department Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Department Code field.';
                }
                field("Receiving Depot Name"; Rec."Receiving Depot Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Depot Name field.';
                }
                field("Receiving Department Name"; Rec."Receiving Department Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Department Name field.';
                }
                field("Source Department Name"; Rec."Source Department Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Department Name field.';
                }
                field("Paying  Bank Account Name"; Rec."Paying  Bank Account Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Paying  Bank Account Name field.';
                }
                field("Inter Bank Template Name"; Rec."Inter Bank Template Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Inter Bank Template Name field.';
                }
                field("Inter Bank Journal Batch"; Rec."Inter Bank Journal Batch")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Inter Bank Journal Batch field.';
                }
                field("Receiving Transfer Type"; Rec."Receiving Transfer Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receiving Transfer Type field.';
                }
                field("Source Transfer Type"; Rec."Source Transfer Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Transfer Type field.';
                }
                field("Currency Code Destination"; Rec."Currency Code Destination")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Currency Code Destination field.';
                }
                field("Currency Code Source"; Rec."Currency Code Source")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Currency Code Source field.';
                }
                field("Amount 2"; Rec."Amount 2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount 2 field.';
                }
                field("Exch. Rate Source"; Rec."Exch. Rate Source")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Exch. Rate Source field.';
                }
                field("Exch. Rate Destination"; Rec."Exch. Rate Destination")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Exch. Rate Destination field.';
                }
                field("Reciprical 1"; Rec."Reciprical 1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reciprical 1 field.';
                }
                field("Reciprical 2"; Rec."Reciprical 2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reciprical 2 field.';
                }
                field("Balance 1"; Rec."Balance 1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Balance 1 field.';
                }
                field("Balance 2"; Rec."Balance 2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Balance 2 field.';
                }
                field("Current Source A/C Bal."; Rec."Current Source A/C Bal.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Current Source A/C Bal. field.';
                }
                field("Register Number"; Rec."Register Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Register Number field.';
                }
                field("From No"; Rec."From No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the From No field.';
                }
                field("To No"; Rec."To No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the To No field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("Shortcut Dimension 3 Code1"; Rec."Shortcut Dimension 3 Code1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code1"; Rec."Shortcut Dimension 4 Code1")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim31; Rec.Dim31)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Dim31 field.';
                }
                field(Dim41; Rec.Dim41)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Dim41 field.';
                }
                field("Sending Responsibility Center"; Rec."Sending Responsibility Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sending Responsibility Center field.';
                }
                field("Reciept Responsibility Center"; Rec."Reciept Responsibility Center")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Reciept Responsibility Center field.';
                }
                field("Sending Resp Centre"; Rec."Sending Resp Centre")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Sending Resp Centre field.';
                }
                field("Receipt Resp Centre"; Rec."Receipt Resp Centre")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receipt Resp Centre field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Request Amt LCY"; Rec."Request Amt LCY")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Request Amt LCY field.';
                }
                field("Pay Amt LCY"; Rec."Pay Amt LCY")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Pay Amt LCY field.';
                }
                field("External Doc No."; Rec."External Doc No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the External Doc No. field.';
                }
                field("Transfer Release Date"; Rec."Transfer Release Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Transfer Release Date field.';
                }
                field("Transactions Type"; Rec."Transactions Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Transactions Type field.';
                }
                field("Cancelled By"; Rec."Cancelled By")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cancelled By field.';
                }
                field("Date Cancelled"; Rec."Date Cancelled")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Cancelled field.';
                }
                field("Time Cancelled"; Rec."Time Cancelled")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Time Cancelled field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Posted Interbank Transfers")
            {
                RunObject = Page "Posted Interbank Transfers UP";
                RunPageLink = No = FIELD(No);
                ToolTip = 'Executes the Posted Interbank Transfers action.';
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rcpt.Reset;
        Rcpt.SetRange(Rcpt.Posted, false);
        Rcpt.SetRange(Rcpt."Created By", UserId);
        if Rcpt.Count > 0 then begin
            if Confirm('There are still some unposted interbank transfers. Continue?', false) = false then begin
                Error('There are still some unposted interbank transfers. Please utilise them first');
            end;
        end;
    end;

    var
        Rcpt: Record "InterBank Transfers";
}

