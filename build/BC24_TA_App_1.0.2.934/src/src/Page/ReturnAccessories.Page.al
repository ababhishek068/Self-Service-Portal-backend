namespace ABH_UAT.ABH_UAT;

page 51578 "Return Accessories"
{
    ApplicationArea = All;
    Caption = 'Return Accessories';
    PageType = ListPart;
    SourceTable = "Asset Accessories";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Accessory Code"; Rec."Accessory Code")
                {
                    ToolTip = 'Specifies the value of the Accessory Code field.', Comment = '%';
                }
                field("Accessory Name"; Rec."Accessory Name")
                {
                    ToolTip = 'Specifies the value of the Accessory Name field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Serial No"; Rec."Serial No")
                {
                    ToolTip = 'Specifies the value of the Serial No field.', Comment = '%';
                }
                field("Has SN?"; Rec."Has SN?")
                {
                    ToolTip = 'Specifies the value of the Has SN? field.', Comment = '%';
                }
            }
        }
    }
}
