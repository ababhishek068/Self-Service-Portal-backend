page 50256 "Cons. Disposal Plan List"
{
    CardPageID = "Cons. Disposal Plan Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "Cons.Disposal Plan";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Disposal Period"; Rec."Disposal Period")
                {
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook) { }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
            }
        }
    }
}

