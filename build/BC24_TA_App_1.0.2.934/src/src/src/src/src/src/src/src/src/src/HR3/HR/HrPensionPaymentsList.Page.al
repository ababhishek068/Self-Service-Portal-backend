Page 51000 "Hr Pension Payments List"
{
    CardPageID = "Hr Pension Payments";
    Editable = false;
    PageType = List;
    SourceTable = "Hr Pension Payments";
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
                field(DateCollected; Rec."Date Collected")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Collected field.';
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
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
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
                field(CollectedBy; Rec."Collected By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Collected By field.';
                }
                field(OnBehalfOf; Rec."On Behalf Of")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field(BenefitType; Rec."Benefit Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Benefit Type field.';
                }
                field(NameofInsurance; Rec."Name of Insurance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name of Insurance field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Principal; Rec.Principal)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Principal field.';
                }
                field(PrincipalsNames; Rec."Principal's Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Principal''s Names field.';
                }
                field(EmployeeType; Rec."Employee Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Type field.';
                }
            }
        }
    }

    actions { }
}

