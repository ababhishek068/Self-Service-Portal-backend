Page 51261 "HR Hiring Criteria"
{
    PageType = List;
    SourceTable = "HR Hiring Criteria";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ApplicationCode; Rec."Application Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Application Code field.';
                }
                field(HiringCriteria; Rec."Hiring Criteria")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hiring Criteria field.';
                }
            }
        }
    }

    actions { }
}

