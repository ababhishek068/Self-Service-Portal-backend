Page 50236 "Institutional Departments"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Institution Departments";
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
                field(Institution; Rec.Institution)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7; Outlook) { }
            systempart(Control8; Notes) { }
            systempart(Control9; MyNotes) { }
            systempart(Control10; Links) { }
        }
    }

    actions { }
}

