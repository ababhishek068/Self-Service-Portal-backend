Page 50197 "PR Bank Branches"
{
    PageType = List;
    SourceTable = "PR Bank Branches";
    DataCaptionFields = "Branch Code", "Branch Name", "Bank Name";
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(BankCode; Rec."Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(BranchCode; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field(BranchName; Rec."Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }
            }
        }
    }

    actions { }
}

