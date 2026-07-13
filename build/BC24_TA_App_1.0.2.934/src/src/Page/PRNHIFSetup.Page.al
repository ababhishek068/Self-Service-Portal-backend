Page 50201 "PR Income Tax Setup"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "PR Income Tax";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(TierCode; Rec."Tier Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tier Code field.';
                }
                field(LowerLimit; Rec."Lower Limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lower Limit field.';
                }
                field(UpperLimit; Rec."Upper Limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Upper Limit field.';
                }
                field(Amount; Rec.Rate)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Relief;Rec.Relief){}
            }
        }
    }

    actions { }
}

