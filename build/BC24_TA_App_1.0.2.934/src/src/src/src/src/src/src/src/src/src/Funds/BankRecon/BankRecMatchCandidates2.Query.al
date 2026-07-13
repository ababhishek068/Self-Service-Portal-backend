Query 50005 "Bank Rec. Match Candidates2"
{

    elements
    {
        dataitem(Bank_Acc__Statement_Line1; "Bank Acc. Statement Line1")
        {
            DataItemTableFilter = Difference = filter(<> 0), Type = filter(= "Bank Account Ledger Entry");
            column(Rec_Line_Bank_Account_No; "Bank Account No.") { }
            column(Rec_Line_Statement_No; "Statement No.") { }
            column(Rec_Line_Statement_Line_No; "Statement Line No.") { }
            column(Rec_Line_Transaction_Date; "Transaction Date") { }
            column(Rec_Line_Description; Description) { }
            column(Rec_Line_RltdPty_Name; "Related-Party Name") { }
            column(Rec_Line_Transaction_Info; "Additional Transaction Info") { }
            column(Rec_Line_Statement_Amount; "Statement Amount") { }
            column(Rec_Line_Applied_Amount; "Applied Amount") { }
            column(Rec_Line_Difference; Difference) { }
            column(Rec_Line_Type; Type) { }
            column(Rec_Line_Applied_Entries; "Applied Entries") { }
            column(Rec_Line_Check_No; "Check No.") { }

            //Added <<<
            column(Rec_Line_Document_no; "Document No.") { }
            dataitem(Bank_Account_Ledger_Entry; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = Bank_Acc__Statement_Line1."Bank Account No.";
                DataItemTableFilter = "Remaining Amount" = filter(<> 0), Open = const(true), "Statement Status" = filter(Open);
                column(Entry_No; "Entry No.") { }
                column(Bank_Account_No; "Bank Account No.") { }
                column(Posting_Date; "Posting Date") { }
                column(Document_No; "Document No.") { }
                column(Description; Description) { }
                column(Remaining_Amount; "Remaining Amount") { }
                column(Bank_Ledger_Entry_Open; Open) { }
                column(Statement_Status; "Statement Status") { }
                column(External_Document_No; "External Document No.") { }
            }
        }
    }
}

