Report 50080 "Motor Vehicle Checklist Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/MotorVehicleChecklistReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Motor Vehicle Checklists"; "Motor Vehicle Checklists")
        {
            column(ReportForNavId_1; 1) { }
            column(Contition_MotorVehicleChecklists; "Motor Vehicle Checklists".Contition) { }
            column(Remarks_MotorVehicleChecklists; "Motor Vehicle Checklists".Remarks) { }
            column(MileageReading_MotorVehicleChecklists; "Motor Vehicle Checklists"."Mileage Reading") { }
            column(NameOfReceivingDriver_MotorVehicleChecklists; "Motor Vehicle Checklists"."Name Of Receiving Driver") { }
            column(NameOfHandingOverDriver_MotorVehicleChecklists; "Motor Vehicle Checklists"."Name Of Handing Over Driver") { }
            column(Adminofficer_MotorVehicleChecklists; "Motor Vehicle Checklists"."Admin officer") { }
            column(VehicleName_MotorVehicleChecklists; "Motor Vehicle Checklists"."Vehicle Name") { }
            column(NoSeries_MotorVehicleChecklists; "Motor Vehicle Checklists"."No. Series") { }
            column(Departments_MotorVehicleChecklists; "Motor Vehicle Checklists".Departments) { }
            column(Directorate_MotorVehicleChecklists; "Motor Vehicle Checklists".Directorate) { }
            column(Station_MotorVehicleChecklists; "Motor Vehicle Checklists".Station) { }
            column(RaisedBy_MotorVehicleChecklists; "Motor Vehicle Checklists"."Raised By") { }
            column(No_MotorVehicleChecklists; "Motor Vehicle Checklists"."No.") { }
            column(VehicleRegNo_MotorVehicleChecklists; "Motor Vehicle Checklists"."Vehicle Reg No.") { }
            column(Date_MotorVehicleChecklists; "Motor Vehicle Checklists".Date) { }
            column(TypeOfVehicle_MotorVehicleChecklists; "Motor Vehicle Checklists"."Type Of Vehicle") { }
            column(Picture; CompanyInfo.Picture) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

