namespace ABH_UAT.ABH_UAT;

page 51567 "vehicle transfer List"
{
    ApplicationArea = All;
    Caption = 'vehicle transfer List';
    PageType = List;
    SourceTable = "Vehicle Transfer";
    UsageCategory = Lists;
    CardPageId="vehicle transfer card.";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Plate No"; Rec."Plate No")
                {
                    ToolTip = 'Specifies the value of the Plate No field.', Comment = '%';
                }
                field("Vehicle No"; Rec."Vehicle No")
                {
                    ToolTip = 'Specifies the value of the Vehicle No field.', Comment = '%';
                }
                field("Transfer No"; Rec."Transfer No")
                {
                    ToolTip = 'Specifies the value of the Transfer No field.', Comment = '%';
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ToolTip = 'Specifies the value of the Transfer Date field.', Comment = '%';
                }
                field("Transfered To"; Rec."Transfered To")
                {
                    ToolTip = 'Specifies the value of the Transfered To field.', Comment = '%';
                }
                field("Transfered To Location"; Rec."Transfered To Location")
                {
                    ToolTip = 'Specifies the value of the Transfered To Location field.', Comment = '%';
                }
            }
        }
    }
}
