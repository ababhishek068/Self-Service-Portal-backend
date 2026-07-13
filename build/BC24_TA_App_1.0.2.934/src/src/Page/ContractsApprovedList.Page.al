Page 50382 "Contracts Approved List"
{
    CardPageID = "Contract Card";

    PageType = List;
    SourceTable = Contract;
    SourceTableView = where(Status = filter(Approved));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract Reference No"; Rec."Contract Reference No")
                {
                    ToolTip = 'Specifies the value of the Contract Reference No field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Contractor No."; Rec."Contractor No.")
                {
                    ToolTip = 'Specifies the value of the Contractor No. field.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the value of the Requested By field.';
                }
            }
        }
    }

    actions { }
}

