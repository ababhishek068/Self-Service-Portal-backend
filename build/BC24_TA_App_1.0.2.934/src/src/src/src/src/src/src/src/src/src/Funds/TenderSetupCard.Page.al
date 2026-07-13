Page 50704 "Tender Setup Card"
{
    PageType = Card;
    SourceTable = "Tender Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(NonRefundableFee; Rec."Non Refundable Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Non Refundable Fee field.';
                }
                field(FromTime; Rec."From Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Time field.';
                }
                field(ToTime; Rec."To Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Time field.';
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period field.';
                }
                field(OpeningDate; Rec."Opening Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Opening Date field.';
                }
            }
        }
    }

    actions { }
}

