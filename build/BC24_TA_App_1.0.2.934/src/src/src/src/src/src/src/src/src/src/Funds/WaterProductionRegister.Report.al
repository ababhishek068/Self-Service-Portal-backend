report 50142 "Water Production Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WaterProduction.rdlc';
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Water Production"; "Water Production")
        {
            column(Name_of_the_Operator; "Name of the Operator") { }
            column(Date; Date) { }
            column(Time_In; "Time In") { }
            column(Time_Out; "Time Out") { }
            column(Chemical_Code_Used; "Chemical Code Used") { }
            column(Chemical_Description; "Chemical Description") { }
            column(Chemicals_Qty_Used; "Chemicals Qty Used") { }

            column(Metering_Type; "Metering Type") { }
            column(Units; Units) { }
            column(Remarks; Remarks) { }

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