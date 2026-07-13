Page 51418 "Bidder List"
{
    CardPageID = "Bidder Card";
    Editable = false;
    PageType = List;
    SourceTable = "Bidder";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("TIN No"; Rec."PIN No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No field.';
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
                field(TendererName; Rec."Tenderer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tenderer Name field.';
                }
            }
        }
    }

    actions { }
}

