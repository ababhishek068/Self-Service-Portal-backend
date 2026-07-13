namespace ABH_UAT.ABH_UAT;

page 51539 "Staff Medical Claims Refund"
{
    ApplicationArea = All;
    Caption = 'Staff Medical Claims Refund';
    PageType = List;
    SourceTable = "Satff Medical Claims Setup";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Hospital Classification"; Rec."Hospital Classification")
                {
                    ToolTip = 'Specifies the value of the Hospital Classification field.', Comment = '%';
                }
                field("Percentage refund"; Rec."Percentage refund")
                {
                    ToolTip = 'Specifies the value of the Percentage refund field.', Comment = '%';
                }
            }
        }
    }
}
