page 50965 "Ethic Community"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sub Tribe";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec."Sub Tribe Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Language"; Rec."Sub Tribe Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Language field.';
                }
            }
        }

    }

    actions { }
}