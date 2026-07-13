namespace ABH_UAT.ABH_UAT;

page 51558 "Loan Guarantee List"
{
    ApplicationArea = All;
    Caption = 'Loan Guarantee List';
    PageType = List;
    CardPageId="loan Guarantee Card";
    SourceTable = "Loan Guarantee Header";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan Guarantee No"; Rec."Loan Guarantee No")
                {
                    ToolTip = 'Specifies the value of the Loan Guarantee No field.', Comment = '%';
                }
                field("Ref No"; Rec."Ref No")
                {
                    ToolTip = 'Specifies the value of the Ref No field.', Comment = '%';
                }
                field(Loanee; Rec.Loanee)
                {
                    ToolTip = 'Specifies the value of the Loanee field.', Comment = '%';
                }
                field("Loanee Name"; Rec."Loanee Name")
                {
                    ToolTip = 'Specifies the value of the Loanee Name field.', Comment = '%';
                }
                field("Loan Date"; Rec."Loan Date")
                {
                    ToolTip = 'Specifies the value of the Loan Date field.', Comment = '%';
                }
                field("Principal Amount"; Rec."Principal Amount")
                {
                    ToolTip = 'Specifies the value of the Principal Amount field.', Comment = '%';
                }
                field("Amount Defaulted"; Rec."Amount Defaulted")
                {
                    ToolTip = 'Specifies the value of the Amount Defaulted field.', Comment = '%';
                }
                field("Amount Recovered"; Rec."Amount Recovered")
                {
                    ToolTip = 'Specifies the value of the Amount Recovered field.', Comment = '%';
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                field("Date Defaulted"; Rec."Date Defaulted")
                {
                    ToolTip = 'Specifies the value of the Date Defaulted field.', Comment = '%';
                }
                field(Installment; Rec.Installment)
                {
                    ToolTip = 'Specifies the value of the Installment field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
