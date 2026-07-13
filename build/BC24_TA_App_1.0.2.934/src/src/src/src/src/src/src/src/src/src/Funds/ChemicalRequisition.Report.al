report 50137 "Chemical Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ChemicalRequisition.rdlc';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Items Usage Register"; "Items Usage Register")
        {
            column(Date; Date) { }
            column(SRN_No; "SRN No") { }
            column(Item_No; "Item No") { }
            column(Description; Description) { }
            column(Quantity_Received; "Quantity Received") { }
            column(Quantity_Used; "Quantity Used") { }
            column(Balance; Balance) { }
            column(CompInfName; CompInf.Name) { }
            column(CompInflogo; CompInf.Picture) { }
        }
    }



    var
        CompInf: Record "Company Information";

    trigger OnPreReport()
    begin
        CompInf.get;
        CompInf.CalcFields(Picture);
    end;
}