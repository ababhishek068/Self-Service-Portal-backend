Page 50039 "Grant G/L Account Prices"
{
    Caption = 'Grant G/L Account Prices';
    PageType = Card;
    SourceTable = "Job-G/L Account Price";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job No. field.';
                }
                field(JobTaskNo; Rec."Job Task No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Task No. field.';
                }
                field(GLAccountNo; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(UnitCostFactor; Rec."Unit Cost Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost Factor field.';
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line Discount % field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }

    actions { }
}

