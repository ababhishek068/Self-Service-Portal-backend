Page 51136 "Units Exemption Lines"
{
    PageType = List;
    SourceTable = "Units Exemption Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(UnitName; Rec."Unit Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Name field.';
                }
                field(CF; Rec.CF)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CF field.';
                }
            }
        }
    }

    actions { }
}

