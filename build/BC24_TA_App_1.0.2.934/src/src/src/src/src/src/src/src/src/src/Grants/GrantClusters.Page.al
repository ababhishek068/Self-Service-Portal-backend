Page 50050 "Grant Clusters"
{
    Caption = 'Grant Clusters';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Job Posting Group";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(WIPCostsAccount; Rec."WIP Costs Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Costs Account field.';
                }
                field(WIPAccruedCostsAccount; Rec."WIP Accrued Costs Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Accrued Costs Account field.';
                }
                field(JobCostsAppliedAccount; Rec."Job Costs Applied Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Project Costs Applied Account field.';
                }
                field(JobCostsAdjustmentAccount; Rec."Job Costs Adjustment Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Project Costs Adjustment Account field.';
                }
                field(GLExpenseAccContract; Rec."G/L Expense Acc. (Contract)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the G/L Expense Acc. (Contract) field.';
                }
                field(WIPAccruedSalesAccount; Rec."WIP Accrued Sales Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Accrued Sales Account field.';
                }
                field(WIPInvoicedSalesAccount; Rec."WIP Invoiced Sales Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the WIP Invoiced Sales Account field.';
                }
                field(JobSalesAppliedAccount; Rec."Job Sales Applied Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Project Sales Applied Account field.';
                }
                field(JobSalesAdjustmentAccount; Rec."Job Sales Adjustment Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Project Sales Adjustment Account field.';
                }
                field(RecognizedCostsAccount; Rec."Recognized Costs Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Recognized Costs Account field.';
                }
                field(RecognizedSalesAccount; Rec."Recognized Sales Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Recognized Sales Account field.';
                }
            }
        }
    }

    actions { }
}

