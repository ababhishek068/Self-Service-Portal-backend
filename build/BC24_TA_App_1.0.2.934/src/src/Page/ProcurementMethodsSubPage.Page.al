page 51146 "Procurement Methods Sub Page"
{
    // version W/P

    PageType = ListPart;
    SourceTable = "Procurement Method Stages";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Stage Code"; Rec."Stage Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stage Code field.';
                }

                field("Stage Description"; Rec."Stage Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stage Description field.';
                }

                field("Minimum Duration"; Rec."Minimum Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Minimum Duration field.';
                }

                field("Maximum Duration"; Rec."Maximum Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Duration field.';
                }
            }
        }
    }

    actions { }
}

