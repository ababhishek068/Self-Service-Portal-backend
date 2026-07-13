namespace ABH_UAT.ABH_UAT;

page 51561 "Asset Accessory List"
{
    ApplicationArea = All;
    Caption = 'Asset Accessory List';
    PageType = ListPart;
    SourceTable = "Asset Accessories";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.', Comment = '%';
                    Editable=false;
                    Visible=false;
                }
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
                field("Serial No";rec."Serial No"){}
                field("Has SN?";Rec."Has SN?"){}
                field(Condition; Rec.Condition)
                {
                    ToolTip = 'Specifies the value of the Condition field.', Comment = '%';
                }
            }
        }
    }
}
