query 50003 "GL List"
{
    Caption = 'GL List';
    QueryType = Normal;
    OrderBy = ascending(Name);
    elements
    {
        dataitem(GLAccount; "G/L Account")

        {

            column(AccountCategory; "Account Category") { }
            column(AccountType; "Account Type") { }
            column(Balance; Balance) { }
            column(Blocked; Blocked) { }
            column(BudgetControlled; "Budget Controlled") { }
            column(DirectPosting; "Direct Posting") { }
            column(Name; Name) { }
            column(No; "No.") { }
            column(No2; "No. 2") { }
            column(AccountSubcategoryDescript; "Account Subcategory Descript.") { }
            column(AccountSubcategoryEntryNo; "Account Subcategory Entry No.") { }
            column(APIAccountType; "API Account Type") { }
            column(BudgetedAmount; "Budgeted Amount") { }
            column(Comment; Comment) { }
            column(DonordefinedAccount; "Donor defined Account") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(SearchName; "Search Name") { }
            column(ResponsibilityCenter; "Responsibility Center") { }
            column(Status; Status) { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
