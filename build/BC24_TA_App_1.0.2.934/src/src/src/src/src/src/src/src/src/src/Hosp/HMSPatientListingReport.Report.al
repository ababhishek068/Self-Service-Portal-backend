Report 50221 "HMS Patient Listing Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSPatientListingReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Patient"; "HMS Patient")
        {
            DataItemTableView = sorting("Patient No.");
            RequestFilterFields = "Patient No.";
            column(ReportForNavId_5769; 5769) { }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(UserId; UserId) { }
            column(PFNo; PFNo) { }
            column(HMS_Patient__Patient_Type_; "Patient Type") { }
            column(HMS_Patient_Gender; Gender) { }
            column(HMS_Patient__Date_Of_Birth_; "Date Of Birth") { }
            column(PatientName; PatientName) { }
            column(HMS_Patient__ID_Number_; "ID Number") { }
            column(HMS_Patient__COUNT; "HMS Patient".Count) { }
            column(HEALTH_SERVICESCaption; HEALTH_SERVICESCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(PATIENT_LISTING_REPORTCaption; PATIENT_LISTING_REPORTCaptionLbl) { }
            column(Date_Printed_Caption; Date_Printed_CaptionLbl) { }
            column(Printed_By_Caption; Printed_By_CaptionLbl) { }
            column(No_Caption; No_CaptionLbl) { }
            column(TypeCaption; TypeCaptionLbl) { }
            column(HMS_Patient_GenderCaption; FieldCaption(Gender)) { }
            column(HMS_Patient__Date_Of_Birth_Caption; FieldCaption("Date Of Birth")) { }
            column(HMS_Patient__ID_Number_Caption; FieldCaption("ID Number")) { }
            column(Patient_nameCaption; Patient_nameCaptionLbl) { }
            column(Total_Number_Of_Patients_Listed_Caption; Total_Number_Of_Patients_Listed_CaptionLbl) { }
            column(HMS_Patient_Patient_No_; "Patient No.") { }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName := '';
                if Patient.Get("Patient No.") then begin
                    PatientName := UpperCase(Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name");
                    if Patient."Patient Type" = Patient."patient type"::Private then begin
                        PFNo := Patient."Student No.";
                    end
                    else
                        if Patient."Patient Type" = Patient."patient type"::" " then begin
                            PFNo := Patient."Patient No.";
                        end
                        else begin
                            PFNo := Patient."Employee No.";
                        end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Patient No.");
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
        LastFieldNo: Integer;
        Patient: Record "HMS Patient";
        PatientName: Text[200];
        PFNo: Code[20];
        HEALTH_SERVICESCaptionLbl: label 'HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PATIENT_LISTING_REPORTCaptionLbl: label 'PATIENT LISTING REPORT';
        Date_Printed_CaptionLbl: label 'Date Printed:';
        Printed_By_CaptionLbl: label 'Printed By:';
        No_CaptionLbl: label 'No.';
        TypeCaptionLbl: label 'Type';
        Patient_nameCaptionLbl: label 'Patient name';
        Total_Number_Of_Patients_Listed_CaptionLbl: label 'Total Number Of Patients Listed:';
}

