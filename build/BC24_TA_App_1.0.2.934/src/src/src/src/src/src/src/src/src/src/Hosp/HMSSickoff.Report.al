Report 50259 "HMS Sickoff"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSSickoff.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Treatment Form Header"; "HMS Treatment Form Header")
        {
            column(ReportForNavId_1; 1) { }
            column(StrNames; StrNames) { }
            column(TreatmentNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment No.") { }
            column(TreatmentType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Type") { }
            column(TreatmentDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Date") { }
            column(TreatmentTime_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Time") { }
            column(DoctorID_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Doctor ID") { }
            column(PatientNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient No.") { }
            column(NextAppointmentDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Sick Off End Date") { }
            column(OffDutyDays_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Off Duty Days") { }
            column(LightDutyDays_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Light Duty Days") { }
            column(OffDutyComments_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Off Duty Comments") { }
            column(OffDuty_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Off Duty") { }
            column(logos; CompanyInfo.Picture) { }
            column(SickOffStartDate_HMSTreatmentFormHeader; "HMS Treatment Form Header".InPatient) { }
            column(SickOffEndDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Status Remarks") { }

            trigger OnAfterGetRecord()
            begin
                StrNames := '';

                objPat.Reset;
                objPat.SetRange(objPat."Patient No.", "HMS Treatment Form Header"."Patient No.");
                if objPat.Find('-') then begin
                    StrNames := objPat.Surname + ' ' + objPat."Middle Name" + ' ' + objPat."Last Name";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var
        objPat: Record "HMS Patient";
        StrNames: Text;
        CompanyInfo: Record "Company Information";
}

