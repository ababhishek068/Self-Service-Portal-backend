Page 50957 "Academic Central Setup"
{
    PageType = List;
    SourceTable = "Academics Central Setups";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TitleCode; Rec."Title Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(SemesterFilter; Rec."Semester Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester Filter field.';
                }
                field(IntakeFilter; Rec."Intake Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Intake Filter field.';
                }
                field(ProgramCategory; Rec."Program Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Program Category field.';
                }
            }
        }
    }

    actions { }
}

