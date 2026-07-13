namespace ABH_UAT.ABH_UAT;

page 51575 "Inventory Tools and spares"
{
    ApplicationArea = All;
    Caption = 'Inventory Tools and spares ';
    PageType = List;
    SourceTable = "Inventory Spares Handover";
    UsageCategory = Lists;
    CardPageId="Inventorytools handover";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Issue No"; Rec."Issue No")
                {
                    ToolTip = 'Specifies the value of the Issue No field.', Comment = '%';
                }
                field("Issue Date"; Rec."Issue Date")
                {
                    ToolTip = 'Specifies the value of the Issue Date field.', Comment = '%';
                }
                field("Issued To"; Rec."Issued To")
                {
                    ToolTip = 'Specifies the value of the Issued To field.', Comment = '%';
                }
                field("Plate No"; Rec."Plate No")
                {
                    ToolTip = 'Specifies the value of the Plate No field.', Comment = '%';
                }
                field("Chassis No"; Rec."Chassis No")
                {
                    ToolTip = 'Specifies the value of the Chassis No field.', Comment = '%';
                }
                field("Engine No"; Rec."Engine No")
                {
                    ToolTip = 'Specifies the value of the Engine No field.', Comment = '%';
                }
            }
        }
    }
}
