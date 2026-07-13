Page 50162 "Stage Charges"
{
    PageType = List;
    SourceTable = "Stage Charges";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Per Unit Billing"; Rec."Per Unit Billing")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Per Unit Billing field.';
                }
                field("Audit Unit"; Rec."Audit Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit Unit field.';
                }
                field("First Time Only"; Rec."First Time Only")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Time Only field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field("Settlement Type"; Rec."Settlement Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }

            }
        }
    }

    actions { }
}

