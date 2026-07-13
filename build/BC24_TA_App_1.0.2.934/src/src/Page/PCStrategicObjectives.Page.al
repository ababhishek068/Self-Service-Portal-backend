page 51273 "PC Strategic Objectives"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Strategic Objectives";
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
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
            }
        }
    }

    actions { }
}