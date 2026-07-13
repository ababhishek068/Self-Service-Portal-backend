Page 50252 "Investment Rates"
{
    PageType = List;
    SourceTable = "Investment Rates";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rate field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; MyNotes) { }
            systempart(Control8; Links) { }
        }
    }

    actions { }
}

