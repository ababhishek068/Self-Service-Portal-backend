page 50282 "Vendor Product List"
{
    PageType = List;
    SourceTable = "Product Categories";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}