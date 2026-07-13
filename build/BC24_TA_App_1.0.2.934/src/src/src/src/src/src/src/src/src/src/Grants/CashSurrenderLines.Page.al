Page 51163 "Cash Surrender Lines"
{
    PageType = ListPart;
    SourceTable = "Cash Payment Line q";
    SourceTableView = where("Require Surrender" = const(true),
                            Posted = const(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(SelecttoSurrender; Rec."Select to Surrender")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select to Surrender field.';
                }
                field("Surrender Doc"; Rec."Temp Surr Doc")
                {
                    ApplicationArea = Basic;
                    Caption = 'Surrender Doc';
                    ToolTip = 'Specifies the value of the Surrender Doc field.';
                }
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(AccountName; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        SurrenderDoc := SurrenderDocVar;
    end;

    var
        // ImprestSurrDetails: Record "Payroll Variations";
        CashPaymentsLine: Record "Cash Payment Line q";
        SurrenderDocVar: Code[20];
        SurrenderDoc: Code[20];

    procedure SetSurrDoc(var SurrDocNo: Code[20]; var LineNo: Code[20])
    begin
        SurrenderDocVar := SurrDocNo;
        CashPaymentsLine.Reset;
        CashPaymentsLine.SetRange(CashPaymentsLine.No, LineNo);
        if CashPaymentsLine.Find('-') then begin
            repeat
                CashPaymentsLine."Temp Surr Doc" := SurrDocNo;
                CashPaymentsLine.Modify;
            until CashPaymentsLine.Next = 0;
        end;
    end;
}

