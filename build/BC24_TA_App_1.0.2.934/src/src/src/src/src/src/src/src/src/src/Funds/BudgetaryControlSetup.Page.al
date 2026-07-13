Page 51431 "Budgetary Control Setup"
{
    PageType = Card;
    SourceTable = "Budgetary Control Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mandatory field.';
                }
                field("Check Budget On"; Rec."Check Budget On")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Check Budget On field.';
                }
                field("Ignore Budget Departments"; Rec."Ignore Budget Departments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ignore Budget Departments field.';
                }
                field("Check Procurement Plan"; Rec."Check Procurement Plan")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Check Procurement Plan field.';
                }
            }
            group(Budget)
            {
                Caption = 'Budget';
                field(CurrentBudgetCode; Rec."Current Budget Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Budget Code field.';
                }
                field(CurrentBudgetStartDate; Rec."Current Budget Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Budget Start Date field.';
                }
                field(CurrentBudgetEndDate; Rec."Current Budget End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Budget End Date field.';
                }
                field(BudgetDimension1Code; Rec."Budget Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Dimension 1 Code field.';
                }
                field(BudgetDimension2Code; Rec."Budget Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Dimension 2 Code field.';
                }
                field(BudgetDimension3Code; Rec."Budget Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Dimension 3 Code field.';
                }
                field(BudgetDimension4Code; Rec."Budget Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Dimension 4 Code field.';
                }
                field(BudgetDimension5Code; Rec."Budget Dimension 5 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Dimension 5 Code field.';
                }
                field(BudgetDimension6Code; Rec."Budget Dimension 6 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Dimension 6 Code field.';
                }
            }
            group(Actuals)
            {
                Caption = 'Actuals';
                field(AnalysisViewCode; Rec."Analysis View Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Analysis View Code field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(Dimension3Code; Rec."Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 3 Code field.';
                }
                field(Dimension4Code; Rec."Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 4 Code field.';
                }
            }
        }
    }

    actions { }
}

