query 50051 "Purchase Lines"
{
    QueryType = Normal;
    OrderBy = descending(Line_No_);

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            column(Document_No_; "Document No.") { }
            column(Type; Type) { }
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Description_2; "Description 2") { }
            column(Quantity; Quantity) { }
            column(Unit_of_Measure; "Unit of Measure") { }
            column(Direct_Unit_Cost; "Direct Unit Cost") { }
            column(Line_Amount; "Line Amount") { }
            column(Location_Code; "Location Code") { }
            column(Line_No_; "Line No.") { }
            column(RequestSummary; "Request Summary")
            {
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
            }

            column(Item_G_L_Budget_Account; "Item G/L Budget Account") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}