page 50309 "HR Leave Planner List"
{
    CardPageID = "HR Leave Planner Card";
    PageType = List;
    SourceTable = "HR Leave Planner Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application Code"; Rec."Application Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Application Code field.';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field("Job Tittle"; Rec."Job Tittle")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Tittle field.';
                }
            }
        }
    }

    actions { }
}
