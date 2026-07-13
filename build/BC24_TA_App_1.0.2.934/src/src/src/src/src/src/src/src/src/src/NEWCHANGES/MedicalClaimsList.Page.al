namespace ABH_UAT.ABH_UAT;

page 51571 "Medical Claims List"
{
    ApplicationArea = All;
    Caption = 'Medical Claims List';
    PageType = List;
    SourceTable = "Medical Claims Header";
    UsageCategory = Lists;
    CardPageId="Medical Claims Card";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Claim No"; Rec."Claim No")
                {
                    ToolTip = 'Specifies the value of the Claim No field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Invoice No"; Rec."Invoice No")
                {
                    ToolTip = 'Specifies the value of the Invoice No field.', Comment = '%';
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ToolTip = 'Specifies the value of the Vendor No field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount field.', Comment = '%';
                }
            }
        }
    }
}
