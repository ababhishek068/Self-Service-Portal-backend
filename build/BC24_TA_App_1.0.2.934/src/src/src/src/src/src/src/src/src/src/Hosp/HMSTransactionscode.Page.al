Page 50473 "HMS Transactions code"
{
    PageType = List;
    SourceTable = "HMS Transactions code";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(IncomeGLAccount; Rec."Income G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Income G/L Account field.';
                }
                field(ExpenseGLAccount; Rec."Expense G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expense G/L Account field.';
                }
                field(CalculateDoctorFee; Rec."Calculate Doctor Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calculate Doctor Fee field.';
                }
                field(CalculateInsuranceFee; Rec."Calculate Insurance Fee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Calculate Insurance Fee field.';
                }
                field(PatientNoFilter; Rec."Patient No Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No Filter field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(DateFilter; Rec."Date Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Filter field.';
                }
                field(PatientTypeFilter; Rec."Patient Type Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient Type Filter field.';
                }
                field(ReceiptAmount; Rec."Receipt Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt Amount field.';
                }
                field(PostedAmount; Rec."Posted Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted Amount field.';
                }
                field(InvoiceAmount; Rec."Invoice Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Amount field.';
                }
                field(CashAmount; Rec."Cash Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cash Amount field.';
                }
            }
        }
    }

    actions { }
}

