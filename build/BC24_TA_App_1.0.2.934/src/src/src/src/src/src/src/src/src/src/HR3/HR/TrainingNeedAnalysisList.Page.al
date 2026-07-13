page 50606 "Training Need Analysis List"
{
    CardPageID = "HR TNA Card";
    Editable = false;
    PageType = List;
    SourceTable = "HR Training Needs Analysis";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Need Source"; Rec."Need Source")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Need Source field.';
                }
                field("Individual Course"; Rec."Individual Course")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Individual Course field.';
                }
                field("Proposed End Date"; Rec."Proposed End Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Proposed End Date field.';
                }
                field("Cost Of Training"; Rec."Cost Of Training")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
            }
        }
        area(factboxes)
        {
            // part(Control1102755002; "Job_Salary grade/steps1")
            // {
            //     SubPageLink = Grade = FIELD(Code);
            //     ApplicationArea = basic;
            // }
        }
    }

    actions { }
}

