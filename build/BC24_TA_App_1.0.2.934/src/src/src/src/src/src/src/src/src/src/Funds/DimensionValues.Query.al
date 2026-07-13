query 50036 "Dimension Values"
{
    QueryType = Normal;

    elements
    {
        dataitem("DimensionValue"; "Dimension Value")
        {
            column(Code; Code) { }
            column(Name; Name) { }
            column(Global_Dimension_No_; "Global Dimension No.") { }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}