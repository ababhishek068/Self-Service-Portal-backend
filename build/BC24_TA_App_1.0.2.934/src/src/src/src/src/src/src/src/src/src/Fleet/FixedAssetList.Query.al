query 50060 "Fixed Asset List"
{
    QueryType = Normal;

    elements
    {
        dataitem(Fixed_Asset; "Fixed Asset")
        {
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Assigned_Employee; "Assigned Employee") { }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
