Page 50032 "Course Prerequisite"
{
    PageType = List;
    SourceTable = "Course Prerequisite";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Requirement; Rec.Requirement)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requirement field.';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mandatory field.';
                }
            }
        }
    }

    actions { }
}

