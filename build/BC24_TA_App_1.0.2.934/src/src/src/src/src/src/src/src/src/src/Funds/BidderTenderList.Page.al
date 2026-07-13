Page 51417 "Bidder Tender List"
{
    PageType = ListPart;
    SourceTable = "Bidder Tender";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(TenderID; Rec."Tender ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender ID field.';
                }
                field(ReceiptNo; Rec."Receipt No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field(NonRefundableFee; Rec."Non Refundable Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Non Refundable Fee field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(SerialNo; Rec."Serial No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(TendererNames; Rec."Tenderer Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tenderer Names field.';
                }
                field(TelephoneNo; Rec."Telephone No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
                field(WitnessNames; Rec."Witness Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Witness Names field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }

    actions { }
}

