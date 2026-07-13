query 50087 Items
{
    Caption = 'Items';
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            column(No; "No.") { }
            column(Description; Description) { }
            column(Blocked; Blocked) { }
            column("Type"; "Type") { }
            column(ItemCategoryCode; "Item Category Code") { }
            column(ItemCategoryId; "Item Category Id") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
