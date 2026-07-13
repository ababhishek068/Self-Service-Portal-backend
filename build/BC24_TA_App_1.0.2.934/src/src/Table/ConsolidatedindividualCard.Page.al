namespace ABH_UAT.ABH_UAT;
using microsoft;

page 51580 "Consolidated-individual Card"
{
    ApplicationArea = All;
    Caption = 'Consolidated-individual Card';
    PageType = Card;
    SourceTable = "Consolidated Budget";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field(Budget; Rec.Budget)
                {
                    ToolTip = 'Specifies the value of the Budget Number field.', Comment = '%';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ToolTip = 'Specifies the value of the Financial Year field.', Comment = '%';
                }
            }
            part(BudgetLines; IndividualizedBudgetLine)
             //part(BudgetLines; "Purchase Requisition Subform")
            {
                Editable = true;
                SubPageLink = "Budget No"=field(Budget);
            }
        }
    }
}
