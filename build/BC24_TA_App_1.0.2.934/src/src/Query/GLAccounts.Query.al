query 50088 "G/L Accounts"
{
    Caption = 'G/L Accounts';
    QueryType = Normal;

    elements
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableFilter = "Direct Posting" = const(true);
            column(No; "No.") { }
            column(No2; "No. 2") { }
            column(Name; Name) { }
            column(SearchName; "Search Name") { }
            column(DirectPosting; "Direct Posting") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
