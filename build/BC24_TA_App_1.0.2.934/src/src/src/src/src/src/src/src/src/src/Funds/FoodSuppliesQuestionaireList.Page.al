Page 50710 "Food Supplies QuestionaireList"
{
    CardPageID = "Food Supplies QuestionaireCard";
    Editable = false;
    PageType = List;
    SourceTable = "Food Supplies Questionaire";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TenderNo; Rec."Tender No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tender No. field.';
                }
                field(ReceiptNo; Rec."Receipt No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt No. field.';
                }
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(SupplierName; Rec."Supplier Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supplier Name field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
            }
        }
    }

    actions { }
}

