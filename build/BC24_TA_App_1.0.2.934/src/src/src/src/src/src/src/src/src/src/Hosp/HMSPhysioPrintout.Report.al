Report 50260 "HMS Physio Printout"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSPhysioPrintout.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Treatment Form Header"; "HMS Treatment Form Header")
        {
            column(ReportForNavId_14; 14) { }
            column(DoctorID_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Doctor ID") { }
            column(TreatmentNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment No.") { }
            column(TreatmentDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Date") { }
            column(PatientNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient No.") { }
            column(PatientName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient Name") { }
            column(gender; objPat.Gender) { }
            column(ageinyrs; "HMS Treatment Form Header"."Relative No.") { }
            dataitem("HMS Physio Treatment"; "HMS Physio Treatment")
            {
                DataItemLink = "No." = field("Treatment No.");
                column(ReportForNavId_1; 1) { }
                column(logos; CompanyInfo.Picture) { }
                column(No_HMSPhysioTreatment; "HMS Physio Treatment"."No.") { }
                column(ProcessNo_HMSPhysioTreatment; "HMS Physio Treatment"."Process No.") { }
                column(ProcessName_HMSPhysioTreatment; "HMS Physio Treatment"."Process Name") { }
                column(ProcessMandatory_HMSPhysioTreatment; "HMS Physio Treatment"."Process Mandatory") { }
                column(ProcessRemarks_HMSPhysioTreatment; "HMS Physio Treatment"."Process Remarks") { }
                column(ProcessResult_HMSPhysioTreatment; "HMS Physio Treatment"."Process Result") { }
                column(Diagnosis_HMSPhysioTreatment; "HMS Physio Treatment".Diagnosis) { }
                column(Treatment_HMSPhysioTreatment; "HMS Physio Treatment".Treatment) { }
                column(FrequencyPerweek_HMSPhysioTreatment; "HMS Physio Treatment"."Frequency Per week") { }
                column(Duration_HMSPhysioTreatment; "HMS Physio Treatment".Duration) { }
                column(Names; StrNames) { }

                trigger OnAfterGetRecord()
                begin
                    StrNames := '';

                    ObjTreat.Reset;
                    ObjTreat.SetRange(ObjTreat."Treatment No.", "HMS Physio Treatment"."No.");
                    if ObjTreat.Find('-') then begin
                        StrNames := ObjTreat."Patient Name";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if CompanyInfo.Get() then
                        CompanyInfo.CalcFields(CompanyInfo.Picture);
                end;
            }
            dataitem("HMS Patient"; "HMS Patient")
            {
                DataItemLink = "Patient No." = field("Patient No.");
                column(ReportForNavId_20; 20) { }
                column(AgeinYears_HMSPatient; objPat."Relative No.") { }
                column(Gender_HMSPatient; "HMS Patient".Gender) { }
                column(IDNumber_HMSPatient; "HMS Patient"."ID Number") { }
                column(SearchName_HMSPatient; "HMS Patient"."Search Name") { }
            }

            trigger OnAfterGetRecord()
            begin
                if objPat.Get("HMS Treatment Form Header"."Patient No.") then begin


                end;
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
        ObjTreat: Record "HMS Treatment Form Header";
}

