Page 51193 "HR Institutions."
{
    PageType = Card;
    SourceTable = "Hr Institutions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(InstitutionCode; Rec."Institution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution Code field.';
                }
                field(InstitutionName; Rec."Institution Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution Name field.';
                }
            }
        }
    }

    actions { }
}

