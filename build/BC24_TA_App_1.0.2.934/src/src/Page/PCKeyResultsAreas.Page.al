page 51143 "PC Key Results Areas"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Key Results Area";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
            }


        }
    }

    actions { }
}