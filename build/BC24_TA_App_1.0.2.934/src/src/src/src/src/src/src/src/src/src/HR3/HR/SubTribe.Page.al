Page 50506 "Sub Tribe"
{
    PageType = List;
    SourceTable = "Sub Tribe";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Sub Tribe Code"; Rec."Sub Tribe Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sub Tribe Code field.';
                }
                field("Tribe Code"; Rec."Tribe Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tribe Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

