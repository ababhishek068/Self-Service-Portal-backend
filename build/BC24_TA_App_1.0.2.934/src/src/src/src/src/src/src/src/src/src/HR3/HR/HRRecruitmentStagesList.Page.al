page 50609 "HR Recruitment Stages List"
{
    CardPageID = "HR Recruitment  Stage Card";
    Editable = false;
    PageType = List;
    SourceTable = "HR Recruitment Stages";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

