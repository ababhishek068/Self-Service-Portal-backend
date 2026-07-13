Page 50223 "Grant Surrender Details"
{
    // CALCFIELDS("Grant Phase");
    // 
    // JobTask.RESET;
    // JobTask.SETRANGE(JobTask."Job No.","Grant Task");
    // JobTask.CALCFIELDS(JobTask."Grant Phase");
    // JobTask.SETRANGE(JobTask."Grant Phase","Grant Phase");
    // IF PAGE.RUNMODAL(39004410,JobTask,"Line No.")=ACTION::LookupOK
    // THEN
    //   BEGIN
    //     "Grant Task Line":=JobTask."Line No.";
    //     VALIDATE("Grant Task Line");
    //   END;

    DelayedInsert = true;
    Editable = true;
    PageType = CardPart;
    SourceTable = "Grant Surrender Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(PVNo; Rec."PV No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PV No field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(Partner; Rec.Partner)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Partner field.';
                }
                field(AccountNo; Rec."Account No:")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No: field.';
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(DisbursedAmount; Rec."Disbursed Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disbursed Amount field.';
                }
                field(ActualSpent; Rec."Actual Spent")
                {
                    ApplicationArea = Basic;
                    Caption = 'Actual Spent';
                    Editable = true;
                    ToolTip = 'Specifies the value of the Actual Spent field.';
                }
                field(RemainingAmount; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remaining Amount field.';
                }
                field(CashReceiptNo; Rec."Cash Receipt No")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Cash Receipt No field.';
                }
                field(CashReceiptAmount; Rec."Cash Receipt Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Cash Receipt Amount field.';
                }
                field(Applyto; Rec."Apply to")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Apply to field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Apply to" := '';
                        Rec."Apply to ID" := '';

                        //Amt:=0;

                        Custledger.Reset;
                        Custledger.SetCurrentkey(Custledger."Customer No.", Open, "Document No.");
                        Custledger.SetRange(Custledger."Customer No.", Rec.Partner);
                        Custledger.SetRange(Open, true);
                        //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                        Custledger.CalcFields(Custledger.Amount);
                        if Page.RunModal(25, Custledger) = Action::LookupOK then begin

                            if Custledger."Applies-to ID" <> '' then begin
                                Custledger1.Reset;
                                Custledger1.SetCurrentkey(Custledger1."Customer No.", Open, "Applies-to ID");
                                Custledger1.SetRange(Custledger1."Customer No.", Rec.Partner);
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
                                if Rec."Disbursed Amount" <> Abs(Custledger.Amount) then
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

                        Rec.Validate("Disbursed Amount");

                    end;
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        GrantSurrenderDetails.Reset;
        GrantSurrenderDetails.SetRange(GrantSurrenderDetails.Posted, true);
        GrantSurrenderDetails.SetRange(GrantSurrenderDetails.Partner, Rec.Partner);
        GrantSurrenderDetails.SetRange(GrantSurrenderDetails."Grant No", Rec."Grant No");
        if GrantSurrenderDetails.Find('-') then begin
            repeat
                AccAmount := AccAmount + GrantSurrenderDetails."Actual Spent";
            until GrantSurrenderDetails.Next = 0;
        end;
    end;

    var
        Custledger: Record "Cust. Ledger Entry";
        Custledger1: Record "Cust. Ledger Entry";
        Amt: Decimal;
        GrantSurrenderDetails: Record "Grant Surrender Details";
        AccAmount: Decimal;

    procedure refreshform()
    begin
        CurrPage.Update(false);
    end;
}

