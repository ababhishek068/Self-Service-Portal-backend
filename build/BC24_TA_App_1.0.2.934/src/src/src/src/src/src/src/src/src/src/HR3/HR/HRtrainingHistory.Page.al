Page 50849 "HR training History"
{
    PageType = List;
    SourceTable = "HR Training Applications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ApplicationNo; Rec."Application No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Application No field.';
                }
                field(CourseTitle; Rec."Course Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Course Title field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(CostOfTraining; Rec."Cost Of Training")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost Of Training field.';
                }
            }
        }
    }

    actions { }
}

