report 50140 "Tools & Equipments Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ToolEquipmentsRegister.rdlc';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Serial_No_; "Serial No.") { }
            column(FA_Subclass_Code; "FA Subclass Code") { }
            column(Maintenance_Vendor_No_; "Maintenance Vendor No.") { }
            column(Location_Code; "Location Code") { }
            column(Comment; Comment) { }

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