Page 51218 "Contract Types"
{
    PageType = Card;
    SourceTable = "Contract Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Contract; Rec.Contract)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

