report 50138 "Material Usage"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './Layouts/WaterUsage.rdlc';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Items Usage Register"; "Items Usage Register")
        {
            column(Date; Date) { }
            column(Type_of_Materials; "Type of Materials") { }
            column(Section; Section) { }
            column(Quantity_Received; "Quantity Received") { }

            column(Quantity_Used; "Quantity Used") { }
            column(Balance; Balance) { }
            column(Responsible_Person; "Responsible Person") { }
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