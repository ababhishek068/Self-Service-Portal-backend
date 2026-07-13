Page 50840 "HR Job Shortlist Qualification"
{
    PageType = List;
    SourceTable = "HR ShortListQualifications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(ShortListType; Rec."ShortList Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ShortList Type field.';
                }
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
            }
        }
    }

    actions { }
}

