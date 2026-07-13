Query 50002 "Item List"
{
    OrderBy = ascending(Description);

    elements
    {
        dataitem(Item; Item)
        {
            column(No; "No.") { }
            column(Description; Description) { }
            column(Inventory; Inventory) { }
            column(Inventory_Posting_Group; "Inventory Posting Group") { }
            column(Search_Description; "Search Description") { }
            column(Description_2; "Description 2") { }
            column(Unit_Price; "Unit Price") { }
            column(Unit_Cost; "Unit Cost") { }
        }
    }
}

