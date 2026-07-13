Page 50037 "Exemptions List"
{
    PageType = List;
    SourceTable = "Exemption Codes";
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Exemption Lines")
            {
                ApplicationArea = Basic;
                Image = Line;
                RunObject = Page "Units Exemption Lines";
                RunPageLink = Code = field(Code);
                ToolTip = 'Executes the Exemption Lines action.';
            }
        }
    }
}

