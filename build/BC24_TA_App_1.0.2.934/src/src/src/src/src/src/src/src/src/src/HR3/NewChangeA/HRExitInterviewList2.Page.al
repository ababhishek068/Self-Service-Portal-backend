page 51335 "HR Exit Interview List 2"
{
    // version HRMIS 2015 VRS1.0

    CardPageID = "HR Employee Exit Interviews";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Employee Exit Interviews 2";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Exit Interview No"; Rec."Exit Interview No")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Exit Interview No field.';
                }
                field("Date Of Interview"; Rec."Date Of Interview")
                {
                    ToolTip = 'Specifies the value of the Date Of Interview field.';
                }
                field("Interviewer Name"; Rec."Interviewer Name")
                {
                    ToolTip = 'Specifies the value of the Interviewer Name field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Reason For Leaving"; Rec."Reason For Leaving")
                {
                    ToolTip = 'Specifies the value of the Reason For Leaving field.';
                }
            }
        }
    }

    actions { }
}

