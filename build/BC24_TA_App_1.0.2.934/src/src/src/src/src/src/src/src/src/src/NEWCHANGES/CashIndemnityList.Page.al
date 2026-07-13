namespace ABH_UAT.ABH_UAT;

page 51568 "Cash Indemnity List"
{
    ApplicationArea = All;
    Caption = 'Cash Indemnity List';
    PageType = List;
    SourceTable = "Cash Indemnity Header";
    UsageCategory = Lists;
    CardPageId="Cash Indemnity Card";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cash Idemnity Code"; Rec."Cash Idemnity Code")
                {
                    ToolTip = 'Specifies the value of the Cash Idemnity Code field.', Comment = '%';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ToolTip = 'Specifies the value of the Payroll Month field.', Comment = '%';
                }
                field("Payroll Year"; Rec."Payroll Year")
                {
                    ToolTip = 'Specifies the value of the Payroll Year field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
