page 51380 "Receipts Line UP"
{
    PageType = ListPart;
    SourceTable = "Receipt Line q";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760083)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type field.';

                    trigger OnValidate()
                    begin
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Type, RecPayTypes.Type::Receipt);
                        RecPayTypes.SetRange(RecPayTypes.Code, Rec.Type);
                        if RecPayTypes.Find('-') then begin
                            if RecPayTypes."Account Type" = RecPayTypes."Account Type"::"G/L Account" then begin
                                "Account No.Editable" := false;
                            end
                            else begin
                                "Account No.Editable" := true;
                            end;
                        end;
                    end;
                }
                field(Grouping; Rec.Grouping)
                {
                    // Editable = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Grouping field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }

                field("Account Name"; Rec."Account Name")
                {
                    Editable = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Customer Price Group field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Mode field.';

                    trigger OnValidate()
                    begin
                        PayModeOnAfterValidate;
                    end;
                }

                field("Cheque/Deposit Slip Type"; Rec."Cheque/Deposit Slip Type")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque/Deposit Slip Type field.';
                }
                field("Cheque/Deposit Slip Date"; Rec."Cheque/Deposit Slip Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque/Deposit Slip Date field.';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount Exclusive VAT';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount Exclusive VAT field.';
                }
                field(Quantity; Rec.Quantity)
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Total Amount"; Rec."Total Amount")
                {

                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Amount field.';
                }

                field("Drawer Bank"; Rec."Drawer Bank")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Drawer Bank field.';
                }
                field("Deposit Slip Time"; Rec."Deposit Slip Time")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Deposit Slip Time field.';
                }
                field("Transaction Name"; Rec."Transaction Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field("Cheque/Deposit Slip No"; Rec."Cheque/Deposit Slip No")
                {
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cheque/Deposit Slip No field.';
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction No. field.';
                }
                field("Teller ID"; Rec."Teller ID")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Teller ID field.';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT % field.';
                }

                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applies-to Doc. Type field.';
                }
                field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                {
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
                }
                field("Applies-to ID"; Rec."Applies-to ID")
                {
                    Visible = true;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Applies-to ID field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    if Rec.Posted then
                        Error('The transaction has already been posted.');

                    if Rec."Transaction Name" = '' then
                        Error('Please enter the transaction description under transaction name.');

                    if Rec.Amount = 0 then
                        Error('Please enter amount.');

                    if Rec.Amount < 0 then
                        Error('Amount cannot be less than zero.');

                    if Rec."Global Dimension 1 Code" = '' then
                        Error('Please enter the Function code');

                    if Rec."Shortcut Dimension 2 Code" = '' then
                        Error('Please enter the source of funds.');

                    /*
                    CashierLinks.RESET;
                    CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
                    IF CashierLinks.FIND('-') THEN BEGIN
                    END
                    ELSE BEGIN
                    ERROR('Please link the user/cashier to a collection account before proceeding.');
                    END;
                    */

                    // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec.No);
                    GenJnlLine.DeleteAll;

                    if DefaultBatch.Get('CASH RECEI', Rec.No) then
                        DefaultBatch.Delete;

                    DefaultBatch.Reset;
                    DefaultBatch."Journal Template Name" := 'CASH RECEI';
                    DefaultBatch.Name := Rec.No;
                    DefaultBatch.Insert;

                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := 'CASH RECEI';
                    GenJnlLine."Journal Batch Name" := Rec.No;
                    GenJnlLine."Line No." := 10000;
                    GenJnlLine."Account Type" := Rec."Account Type";
                    GenJnlLine."Account No." := Rec."Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    GenJnlLine."External Document No." := Rec."Cheque/Deposit Slip No";
                    GenJnlLine.Amount := -Rec."Total Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);

                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := Rec."Apply to";
                    //GenJnlLine."Bal. Account No.":=CashierLinks."Bank Account No";
                    if Rec."Bank Code" = '' then
                        Error('Select the Bank Code');


                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description := Rec."Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;


                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name" := 'CASH RECEI';
                    GenJnlLine."Journal Batch Name" := Rec.No;
                    GenJnlLine."Line No." := 10001;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    GenJnlLine."Account No." := Rec."Bank Code";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date" := Rec.Date;
                    GenJnlLine."Document No." := Rec.No;
                    GenJnlLine."External Document No." := Rec."Cheque/Deposit Slip No";
                    GenJnlLine.Amount := Rec."Total Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);




                    GenJnlLine.Description := Rec."Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code" := Rec."Dest Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := Rec."Dest Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");

                    if GenJnlLine.Amount <> 0 then
                        GenJnlLine.Insert;

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec.No);
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);

                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name", 'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", Rec.No);
                    if GenJnlLine.Find('-') then
                        exit;

                    Rec.Posted := true;
                    Rec."Date Posted" := Today;
                    Rec."Time Posted" := Time;
                    Rec."Posted By" := UserId;
                    Rec.Modify;

                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    if Rec.Posted = false then
                        Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(52015, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action("Direct Printing")
            {
                Caption = 'Direct Printing';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                ToolTip = 'Executes the Direct Printing action.';

                trigger OnAction()
                begin
                    if Rec.Posted = false then
                        Error('Post the receipt before printing.');
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    REPORT.Run(52015, false, true, Rec);
                    Rec.Reset;
                end;
            }
            separator(Separator5) { }

        }
    }

    trigger OnInit()
    begin
        "Account No.Editable" := true;
        "Bank AccountVisible" := true;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        RecPayTypes: Record "Receipts and Payment Types";
        [InDataSet]
        "Bank AccountVisible": Boolean;
        [InDataSet]
        "Account No.Editable": Boolean;

    local procedure PayModeOnAfterValidate()
    begin
        if Rec."Pay Mode" = Rec."Pay Mode"::"Deposit Slip" then begin
            "Bank AccountVisible" := true;
        end
        else begin
            "Bank AccountVisible" := false;
        end;
    end;
}

