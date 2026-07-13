Page 51297 "HMS Blood Group Donation Card"
{
    PageType = Card;
    SourceTable = "HMS Setup Blood Donation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Donor; Rec.Donor)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Donor field.';
                }
                field(Recipient; Rec.Recipient)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recipient field.';
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

