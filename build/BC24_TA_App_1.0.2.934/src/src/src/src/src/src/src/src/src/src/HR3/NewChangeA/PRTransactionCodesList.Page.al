Page 51290 "PR Transaction Codes List"
{
    CardPageID = "PR Transaction Code Card";
    PageType = List;
    SourceTable = "PR Transaction Codes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Enabled = true;
                field(TransactionCode; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Transaction Code field.';
                }

                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(TransactionType; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Transaction Type field.';
                }
                field(Frequency; Rec.Frequency)
                {
                    ApplicationArea = All;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Frequency field.';
                }

                field("Transaction Charge Code"; Rec."Transaction Charge Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transaction Charge Code field.';
                }

                field(BalanceType; Rec."Balance Type")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Balance Type field.';
                }
                field(Taxable; Rec.Taxable)
                {
                    ApplicationArea = All;
                    Editable = true;
                    Enabled = true;
                    ToolTip = 'Specifies the value of the Taxable field.';
                }

                field(GLAccount; Rec."GL Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GL Account field.';
                }
                field(GLAccountName; Rec."G/L Account Name")
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the G/L Account Name field.';
                }

                field("coop parameters"; Rec."coop parameters")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Other Categorization field.';
                }
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = All;
                    TableRelation = "PR Transaction Codes";
                    ToolTip = 'Specifies the value of the Group Code field.';
                }
                field(GroupDescription; Rec."Group Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group Description field.';
                }
            }
        }
    }

    actions { }
}

