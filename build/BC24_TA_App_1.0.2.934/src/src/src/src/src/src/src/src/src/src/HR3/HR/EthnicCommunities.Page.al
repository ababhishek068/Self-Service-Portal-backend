Page 51209 "Ethnic Communities"
{
    PageType = ListPart;
    SourceTable = "Sub Tribe";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Code; Rec."Sub Tribe Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Language"; Rec."Sub Tribe Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Language field.';
                }
            }
        }
    }

    actions { }
}

