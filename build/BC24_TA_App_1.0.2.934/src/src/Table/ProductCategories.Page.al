page 51459 "Product Categories"
{
    ApplicationArea = All;
    Caption = 'Product Categories';
    PageType = List;
    CardPageId="Product Categories Card";
    SourceTable = "Product Categories";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Sub Product Code"; Rec."Sub Product Code")
                {
                    ToolTip = 'Specifies the value of the Sub Product Code field.';
                }
                field("Sub Product Description"; Rec."Sub Product Description")
                {
                    ToolTip = 'Specifies the value of the Sub Product Description field.';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ToolTip = 'Specifies the value of the Supplier Category field.';
                }
            }
        }
    }
}
