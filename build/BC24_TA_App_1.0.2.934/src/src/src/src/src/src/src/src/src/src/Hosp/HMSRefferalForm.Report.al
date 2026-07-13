Report 50256 "HMS Refferal Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSRefferalForm.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Treatment Form Header"; "HMS Treatment Form Header")
        {
            column(ReportForNavId_1; 1) { }
            column(Logo; Company.Picture) { }
            column(ComName; Company.Name) { }
            column(Name_of_Patient______UPPERCASE_PatientName_; UpperCase(PatientName)) { }
            column(Doctors_Name______DoctorName; DoctorName) { }
            column(TreatmentNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment No.") { }
            column(TreatmentType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Type") { }
            column(TreatmentDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Date") { }
            column(TreatmentTime_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Time") { }
            column(DoctorID_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Doctor ID") { }
            column(PatientNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient No.") { }
            column(TreatmentRemarks_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Triage Notes") { }
            column(Status_HMSTreatmentFormHeader; "HMS Treatment Form Header".Status) { }
            column(LinkNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Link No.") { }
            column(LinkType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Link Type") { }
            column(NoSeries_HMSTreatmentFormHeader; "HMS Treatment Form Header"."No. Series") { }
            column(OffDutyDays_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Off Duty Days") { }
            column(LightDutyDays_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Light Duty Days") { }
            column(OffDutyComments_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Off Duty Comments") { }
            column(OffDuty_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Off Duty") { }
            column(TreatmentLocation_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Location") { }
            column(PatientType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient Type") { }
            column(Direct_HMSTreatmentFormHeader; "HMS Treatment Form Header".Direct) { }
            column(LabStatus_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Lab Status") { }
            column(RadiologyStatus_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Radiology Status") { }
            column(PharmacyStatus_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Pharmacy Status") { }
            column(InjectionStatus_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Injection Status") { }
            column(Surname_HMSTreatmentFormHeader; "HMS Treatment Form Header".Surname) { }
            column(MiddleName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Middle Name") { }
            column(LastName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Last Name") { }
            column(CorrespondenceAddress1_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Correspondence Address 1") { }
            column(TelephoneNo1_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Telephone No. 1") { }
            column(Email_HMSTreatmentFormHeader; "HMS Treatment Form Header".Email) { }
            column(PatientRefNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient Ref. No.") { }
            column(PatientName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient Name") { }
            column(SettlementType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Settlement Type") { }
            column(MembershipNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Membership No") { }
            column(InsuranceName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Insurance Name") { }
            column(AdmNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Adm No.") { }
            column(DoctorNotes_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Triage Notes") { }
            dataitem("HMS Referral Header"; "HMS Referral Header")
            {
                DataItemLink = "Treatment no." = field("Treatment No.");
                column(ReportForNavId_40; 40) { }
                column(Treatmentno_HMSReferralHeader; "HMS Referral Header"."Treatment no.") { }
                column(HospitalNo_HMSReferralHeader; "HMS Referral Header"."Hospital No.") { }
                column(PatientNo_HMSReferralHeader; "HMS Referral Header"."Patient No.") { }
                column(DateReferred_HMSReferralHeader; "HMS Referral Header"."Date Referred") { }
                column(ReferralReason_HMSReferralHeader; "HMS Referral Header"."Referral Reason") { }
                column(ReferralRemarks_HMSReferralHeader; "HMS Referral Header"."Referral Remarks") { }
                column(Status_HMSReferralHeader; "HMS Referral Header".Status) { }
                column(Surname_HMSReferralHeader; "HMS Referral Header".Surname) { }
                column(MiddleName_HMSReferralHeader; "HMS Referral Header"."Middle Name") { }
                column(LastName_HMSReferralHeader; "HMS Referral Header"."Last Name") { }
                column(IDNumber_HMSReferralHeader; "HMS Referral Header"."ID Number") { }
                column(CorrespondenceAddress1_HMSReferralHeader; "HMS Referral Header"."Correspondence Address 1") { }
                column(TelephoneNo1_HMSReferralHeader; "HMS Referral Header"."Telephone No. 1") { }
                column(Email_HMSReferralHeader; "HMS Referral Header".Email) { }
                column(PatientRefNo_HMSReferralHeader; "HMS Referral Header"."Patient Ref. No.") { }
                column(Diagnosis_HMSReferralHeader; "HMS Referral Header".Diagnosis) { }
                column(StudentNo_HMSReferralHeader; "HMS Referral Header"."Student No") { }
                column(ADMNo_HMSReferralHeader; "HMS Referral Header"."ADM No") { }
                column(HospitalName_HMSReferralHeader; "HMS Referral Header"."Hospital Name") { }
            }
            dataitem("HMS Treatment Form Diagnosis"; "HMS Treatment Form Diagnosis")
            {
                CalcFields = "Diagnosis Name";
                DataItemLink = "Treatment No." = field("Treatment No.");
                column(ReportForNavId_8; 8) { }
                column(DiagnosisName; "HMS Treatment Form Diagnosis"."Diagnosis Name") { }
                column(Description_HMSTreatmentFormDiagnosis; "HMS Treatment Form Diagnosis".Description) { }
                column(DiagnosisNo_HMSTreatmentFormDiagnosis; "HMS Treatment Form Diagnosis"."Diagnosis No.") { }
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName := '';
                Age := '';
                Gender := '';

                if Patient.Get("Patient No.") then begin
                    PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
                    Gender := Format(Patient.Gender);
                    PFNo := Patient."Patient No.";
                end;

                DoctorName := '';
                Doctor.Reset;
                if Doctor.Get("HMS Treatment Form Header"."Doctor ID") then begin
                    //  Doctor.CALCFIELDS(Doctor."Doctor's Name");
                    DoctorName := Doctor."Doctors Name";
                end;
            end;

            trigger OnPreDataItem()
            begin
                Company.Get;
                Company.CalcFields(Company.Picture);
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
        Company: Record "Company Information";
        Patient: Record "HMS Patient";
        Age: Text[100];
        Gender: Text[100];
        PatientName: Text[100];
        PFNo: Code[20];
        Doctor: Record "HMS Setup Doctor";
        DoctorName: Text[100];
}

