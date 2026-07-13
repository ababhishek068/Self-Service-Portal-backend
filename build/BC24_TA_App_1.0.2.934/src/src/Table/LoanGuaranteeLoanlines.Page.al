namespace ABH_UAT.ABH_UAT;

page 51557 "Loan Guarantee Loan lines"
{
    ApplicationArea = All;
    Caption = 'Loan Guarantee Loan lines';
    PageType = ListPart;
    SourceTable = "Loan Guarantee Lines";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Guarantor Code"; Rec."Guarantor Code")
                {
                    ToolTip = 'Specifies the value of the Guarantor Code field.', Comment = '%';
                }
                field("Guarantor Name"; Rec."Guarantor Name")
                {
                    ToolTip = 'Specifies the value of the Guarantor Name field.', Comment = '%';
                }
                field("Amount Guaranteed"; Rec."Amount Guaranteed")
                {
                    ToolTip = 'Specifies the value of the Amount Guaranteed field.', Comment = '%';
                }
                field("Amount to Pay"; Rec."Amount to Pay")
                {
                    ToolTip = 'Specifies the value of the Amount to Pay field.', Comment = '%';
                }
                field(Installment;Installment){}
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
