Page 50470 "Project/Proposal Area setup"
{
    PageType = List;
    SourceTable = "Proposal/Projects Areas setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(AreaDescription; Rec."Area Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Area Description field.';
                }
            }
        }
    }

    actions { }
}

