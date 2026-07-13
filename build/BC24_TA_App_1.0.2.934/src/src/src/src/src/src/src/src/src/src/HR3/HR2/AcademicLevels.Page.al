Page 51161 "Academic Levels"
{
    PageType = List;
    SourceTable = "Payment Schedule Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(PaymentNo; Rec."Payment No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment No field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
            }
        }
    }

    actions { }
}

