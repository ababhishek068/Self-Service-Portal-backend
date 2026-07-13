Page 50738 "Menu Sales SetUp"
{
    PageType = Card;
    SourceTable = "Catering SetUp";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ReceiptNo; Rec."Receipt No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receipt No field.';
                }
                field(SalesTemplate; Rec."Sales Template")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sales Template field.';
                }
                field(SalesBatch; Rec."Sales Batch")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sales Batch field.';
                }
                field(MenuNoSeries; Rec."Menu No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Menu No. Series field.';
                }
                field(CateringIncomeAccount; Rec."Catering Income Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Catering Income Account field.';
                }
                field(CateringControlAccount; Rec."Catering Control Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Catering Control Account field.';
                }
                field(CashReceivingBankAccount; Rec."Cash Receiving Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cash Receiving Bank Account field.';
                }
                field(MPESABankAccount; Rec."MPESA Receiving Bank Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'MPESA Bank Account';
                    ToolTip = 'Specifies the value of the MPESA Bank Account field.';
                }
                field(PEPEABankAccount; Rec."PEPEA  Receiving Bank Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'PEPEA Bank Account';
                    ToolTip = 'Specifies the value of the PEPEA Bank Account field.';
                }
                field(DepartmentMealsExpAccount; Rec."Department Meals Exp. Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Meals Exp. Account field.';
                }
                field(CardPaymentsBankAccount; Rec."Card Payments Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Card Payments Bank Account field.';
                }
                field(EnterpriseMealsExpAccount; Rec."Enterprise Meals Exp Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Enterprise Meals Exp Account field.';
                }
                field(OtherSalesExpAccount; Rec."Other Sales Exp Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Sales Exp Account field.';
                }
            }
        }
    }

    actions { }

    trigger OnDeleteRecord(): Boolean
    begin
        exit(false);
    end;


}

