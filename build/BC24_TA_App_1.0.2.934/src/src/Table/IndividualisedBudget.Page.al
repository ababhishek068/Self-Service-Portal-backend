namespace ABH_UAT.ABH_UAT;

page 51495 "Individualised Budget"
{
    ApplicationArea = All;
    Caption = 'Individualised Budget';
    PageType = ListPart;
    SourceTable = "Individualized Budgets";
    Editable=false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Budget No"; Rec."Budget No")
                {
                    ToolTip = 'Specifies the value of the Budget Number field.', Comment = '%';
                }
                field("GL Name"; Rec."GL Name")
                {
                    ToolTip = 'Specifies the value of the GL Name field.', Comment = '%';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ToolTip = 'Specifies the value of the Financial Year field.', Comment = '%';
                }
                field("GL account"; Rec."GL account")
                {
                    ToolTip = 'Specifies the value of the GL account field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Total  Amount"; Rec."Total  Amount")
                {
                    ToolTip = 'Specifies the value of the Total  Amount field.', Comment = '%';
                }
                field("Total Expenditure"; Rec."Total Expenditure")
                {
                    ToolTip = 'Specifies the value of the Total Expenditure field.', Comment = '%';
                }
                field("Total Committments"; Rec."Total Committments")
                {
                    ToolTip = 'Specifies the value of the Total Committments field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                
            }
        }
    }
}
