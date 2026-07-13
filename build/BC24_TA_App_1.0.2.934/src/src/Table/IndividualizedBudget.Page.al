page 51475 "Individualized Budget"
{
    ApplicationArea = All;
    Caption = 'Individualized Budget';
    PageType = List;
    CardPageId="Individualized Budget Card";
    SourceTable = "Individualized Budgets";
    UsageCategory = Lists;
    
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
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.', Comment = '%';
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ToolTip = 'Specifies the value of the Financial Year field.', Comment = '%';
                }
                field("GL account"; Rec."GL account")
                {
                    ToolTip = 'Specifies the value of the GL account field.', Comment = '%';
                }
                field("GL Name"; Rec."GL Name")
                {
                    ToolTip = 'Specifies the value of the GL Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
            }
        }
    }
}
