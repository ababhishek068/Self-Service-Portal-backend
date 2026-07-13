Page 50533 "Vendor Product Categories List"
{
    PageType = List;
    SourceTable = "Vendor Product Categories";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No"; Rec."Vendor No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Vendor No field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Sub Category"; Rec."Sub Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sub Category field.';
                }
                field("Sub Category Description"; Rec."Sub Category Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sub Category Description field.';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Supplier Category field.';
                }
            }
        }
    }

    actions { }
}

