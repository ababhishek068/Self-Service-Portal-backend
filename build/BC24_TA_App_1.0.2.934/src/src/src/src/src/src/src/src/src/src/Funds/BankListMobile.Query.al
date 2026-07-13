Query 50037 "Bank List Mobile"
{

    elements
    {
        dataitem(Bank_Account; "Bank Account")
        {
            DataItemTableFilter = "Bank Type" = const("Mobile Collection");
            column(Name; Name)
            {
                Caption = 'Bank Account Name';
            }
            column(Bank_Account_No; "Bank Account No.")
            {
                Caption = 'Paybill Number';
            }
        }
    }
}