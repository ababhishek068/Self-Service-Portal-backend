query 50062 "Imprest Surrender List"
{
    QueryType = Normal;

    elements
    {
        dataitem(Imprest_Surrender_Header; "Imprest Surrender Header")
        {
            column(No; No) { }
            column(Account_No; "Account No.") { }
            column(AccountName; "Account Name") { }
            column(Surrender_Date; "Surrender Date") { }
            column(Purpose; "Imp Purpose") { }
            column(Function_Name; "Function Name") { }
            column(Amount; Amount) { }
            column(Net_Amount; "Net Amount") { }
            column(Budget_Center_Name; "Budget Center Name") { }
            column(Imprest_Issue_Doc_No; "Imprest Issue Doc. No") { }
            column(Status; Status) { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
            column(Imprest_Issue_Date; "Imprest Issue Date") { }
            column(Responsibility_Center; "Responsibility Center") { }
            column(Imp_Purpose; "Imp Purpose") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
