Page 51159 "HR Appraisal Strategic Object"
{
    PageType = ListPart;
    SourceTable = "Appraisal Strategic Obj. - UP";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Strategic Objectives"; Rec."Strategic Objectives")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Strategic Objectives field.';
                }
                field("Objective Description"; Rec."Objective Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Objective Description field.';
                }
            }
        }
    }

    actions { }
}

