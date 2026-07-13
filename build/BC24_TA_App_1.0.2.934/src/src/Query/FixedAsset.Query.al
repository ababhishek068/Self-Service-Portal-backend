query 50089 "Fixed Asset"
{
    Caption = 'Fixed Asset';
    QueryType = Normal;

    elements
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            DataItemTableFilter = Blocked = const(false);
            column(No; "No.") { }
            column(Description; Description) { }
            column(Description2; "Description 2") { }
            column(FAClassCode; "FA Class Code") { }
            column(FALocationCode; "FA Location Code") { }
            column(FASubclassCode; "FA Subclass Code") { }
            column(GlobalDimension1Code; "Global Dimension 1 Code") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(LocationCode; "Location Code") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
