Page 51102 "HR Job Grades Card"
{
    PageType = Card;
    SourceTable = "HR Job Grades";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Descrition; Rec.Descrition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Descrition field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000005; Notes) { }
        }
    }

    actions { }
}

