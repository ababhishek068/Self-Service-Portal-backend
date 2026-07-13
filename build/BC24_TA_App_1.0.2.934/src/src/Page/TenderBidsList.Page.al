page 51424 "Tender Bids List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Tender Bids";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bid Reference"; Rec."Bid Reference")
                {
                    ToolTip = 'Specifies the value of the Bid Reference field.';
                }
                field("Tender No"; Rec."Tender No")
                {
                    ToolTip = 'Specifies the value of the Tender No field.';

                }
                field("Bidder No"; Rec."Bidder No")
                {
                    ToolTip = 'Specifies the value of the Bidder No field.';
                }
                field("Bidder Name"; Rec."Bidder Name")
                {
                    ToolTip = 'Specifies the value of the Bidder Name field.';
                }
                field("Date Submitted"; Rec."Date Submitted")
                {
                    ToolTip = 'Specifies the value of the Date Submitted field.';
                }
                field("Time Submitted"; Rec."Time Submitted")
                {
                    ToolTip = 'Specifies the value of the Time Submitted field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

