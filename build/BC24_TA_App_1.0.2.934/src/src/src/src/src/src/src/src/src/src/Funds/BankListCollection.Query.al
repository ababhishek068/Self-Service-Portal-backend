Query 50038 "Bank List Collection"
{

    elements
    {
        dataitem(Bank_Account; "Bank Account")
        {
            DataItemTableFilter = "Bank Type" = const("Chq Collection");
            column(Name; Name)
            {
                Caption = 'Bank Account Name';
            }
            column(Bank_Account_No; "Bank Account No.")
            {
                Caption = 'Bank Account Number';
            }
            column(Bank_Account_Name; "Bank Account Name")
            {
                Caption = 'Bank Account Name';
            }

        }
    }
}

