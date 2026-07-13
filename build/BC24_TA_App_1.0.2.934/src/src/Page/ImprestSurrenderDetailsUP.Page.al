Page 50874 "Imprest Surrender Details UP"
{
    PageType = ListPart;
    SourceTable = "Imprest Surrender Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102758000)
            {
                field(AccountNo; Rec."Account No:")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No: field.';
                }
                field(SurrenderDocNo; Rec."Surrender Doc No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Surrender Doc No. field.';
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(ActualSpent; Rec."Actual Spent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Spent field.';
                }
                field(CashReceiptNo; Rec."Cash Receipt No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cash Receipt No field.';
                }
                field(CashReceiptAmount; Rec."Cash Receipt Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Cash Receipt Amount field.';
                }
                field(ImprestHolder; Rec."Imprest Holder")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Imprest Holder field.';
                }
                field(Applyto; Rec."Apply to")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Apply to" := '';
                        Rec."Apply to ID" := '';

                        //Amt:=0;

                        Custledger.Reset;
                        Custledger.SetCurrentkey(Custledger."Customer No.", Open, "Document No.");
                        Custledger.SetRange(Custledger."Customer No.", Rec."Imprest Holder");
                        Custledger.SetRange(Open, true);
                        //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                        Custledger.CalcFields(Custledger.Amount);
                        if Page.RunModal(25, Custledger) = Action::LookupOK then begin

                            if Custledger."Applies-to ID" <> '' then begin
                                Custledger1.Reset;
                                Custledger1.SetCurrentkey(Custledger1."Customer No.", Open, "Applies-to ID");
                                Custledger1.SetRange(Custledger1."Customer No.", Rec."Imprest Holder");
                                Custledger1.SetRange(Open, true);
                                //CustLedger1.SETRANGE("Transaction Type",CustLedger1."Transaction Type"::"Down Payment");
                                Custledger1.SetRange("Applies-to ID", Custledger."Applies-to ID");
                                if Custledger1.Find('-') then begin
                                    repeat
                                        Custledger1.CalcFields(Custledger1.Amount);
                                        Amt := Amt + Abs(Custledger1.Amount);
                                    until Custledger1.Next = 0;
                                end;

                                if Amt <> Amt then
                                    //ERROR('Amount is not equal to the amount applied on the application form');
                                    /*Amount:=Amt;
                                    VALIDATE(Amount);*/
                           Rec."Apply to" := Custledger."Document No.";
                                Rec."Apply to ID" := Custledger."Applies-to ID";
                            end else begin
                                if Rec.Amount <> Abs(Custledger.Amount) then
                                    Custledger.CalcFields(Custledger."Remaining Amount");

                                /*Amount:=ABS(CustLedger."Remaining Amount");
                                 VALIDATE(Amount);*/
                                //ERROR('Amount is not equal to the amount applied on the application form');

                                Rec."Apply to" := Custledger."Document No.";
                                Rec."Apply to ID" := Custledger."Applies-to ID";

                            end;
                        end;

                        if Rec."Apply to ID" <> '' then
                            Rec."Apply to" := '';

                        Rec.Validate(Amount);

                    end;
                }
                field(ApplytoID; Rec."Apply to ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Apply to ID field.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
            }
        }
    }

    actions { }

    var
        Custledger: Record "Cust. Ledger Entry";
        Custledger1: Record "Cust. Ledger Entry";
        Amt: Decimal;
}

