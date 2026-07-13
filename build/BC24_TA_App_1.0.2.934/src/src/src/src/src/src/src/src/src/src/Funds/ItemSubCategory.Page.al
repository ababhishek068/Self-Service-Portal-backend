namespace ABH_UAT.ABH_UAT;

page 51541 "Item Sub Category"
{
    ApplicationArea = All;
    Caption = 'Item Sub Category';
    PageType = List;
    SourceTable = "Item Subcategory";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item Category"; Rec."Item Category")
                {
                    ToolTip = 'Specifies the value of the Item Category field.', Comment = '%';
                }
                field("Item Sub Category"; Rec."Item Sub Category")
                {
                    ToolTip = 'Specifies the value of the Item Sub Category field.', Comment = '%';
                }
                field("Sub Category Name"; Rec."Sub Category Name")
                {
                    ToolTip = 'Specifies the value of the Sub Category Name field.', Comment = '%';
                }
                field("Number sequence";"Number sequence"){}
            }
        }
    }
}
