Page 50743 "Menu Sales List"
{
    CardPageID = "Menu Sales Header";
    PageType = List;
    SourceTable = "Menu Sale Header";
    SourceTableView = where(Posted = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReceiptNo; Rec."Receipt No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(CashierNo; Rec."Cashier No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier No field.';
                }
                field(CustomerType; Rec."Customer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Type field.';
                }
                field(CustomerNo; Rec."Customer No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer No field.';
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(ReceivingBank; Rec."Receiving Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Bank field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(ContactStaff; Rec."Contact Staff")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contact Staff field.';
                }
                field(SalesPoint; Rec."Sales Point")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sales Point field.';
                }
                field(PaidAmount; Rec."Paid Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(CashierName; Rec."Cashier Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier Name field.';
                }
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sales Type field.';
                }
                field(PrepaymentBalance; Rec."Prepayment Balance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepayment Balance field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Cashier Name", UserId);
    end;
}

