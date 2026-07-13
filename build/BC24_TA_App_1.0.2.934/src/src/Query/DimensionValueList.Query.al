query 50061 "Dimension Value List"
{
    QueryType = Normal;

    elements
    {
        dataitem(Dimension_Value; "Dimension Value")
        {
            column(Code; Code) { }
            column(Name; Name) { }
            column(GlobalDimensionNo; "Global Dimension No.") { }
            column(Blocked; Blocked) { }
            column(DimensionCode; "Dimension Code") { }
            column(DimensionValueType; "Dimension Value Type") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
