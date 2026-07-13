Page 50196 "PR Bank Accounts"
{
    PageType = List;
    SourceTable = "PR Bank Accounts";
    DataCaptionFields = "Bank Code", "Bank Name";
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(BankCode; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Favourite Rank";"Favourite Rank"){}
                field("Minimum Digits";"Minimum Digits"){}
                field("Maximu Digits";"Maximu Digits"){}
                field(BankType; Rec."Bank Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Type field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Branches)
            {
                ApplicationArea = Basic;
                Image = BankAccount;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "PR Bank Branches";
                RunPageLink = "Bank Code" = field("Bank Code");
                ToolTip = 'Executes the Branches action.';
            }

        }
    }
}

