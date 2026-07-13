Page 51149 "Contracts List"
{
    CardPageID = "Contract Card";

    PageType = List;
    SourceTable = Contract;
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
                field("Contract Value"; Rec."Contract Value")
                {
                    ToolTip = 'Specifies the value of the Contract Value field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field("Perfomance Bond Start Date";"Perfomance Bond Start Date"){}
                field("Perfomance Bond End Date";"Perfomance Bond End Date"){}
                field("PB Extended?";"PB Extended?"){}
                field("PB Extension Start date";"PB Extension Start date"){}
                field("PB Extension End date";"PB Extension End date"){}

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

