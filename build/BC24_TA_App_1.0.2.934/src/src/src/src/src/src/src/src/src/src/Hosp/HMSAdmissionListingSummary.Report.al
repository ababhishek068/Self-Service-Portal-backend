Report 50218 "HMS Admission Listing Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSAdmissionListingSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Admission Form Header"; "HMS Admission Form Header")
        {
            DataItemTableView = sorting("Admission No.");
            RequestFilterFields = "Admission No.";
            column(ReportForNavId_8448; 8448) { }
            column(Date_Printed____FORMAT_TODAY_0_4_; 'Date Printed:' + Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(Printed_By______USERID; 'Printed By: ' + UserId) { }
            column(HMS_Admission_Form_Header__Admission_No__; "Admission No.") { }
            column(HMS_Admission_Form_Header__Admission_Date_; "Admission Date") { }
            column(PFNo; PFNo) { }
            column(HMS_Admission_Form_Header_Ward; Ward) { }
            column(HMS_Admission_Form_Header_Bed; Bed) { }
            column(HMS_Admission_Form_Header_Doctor; Doctor) { }
            column(HMS_Admission_Form_Header_Status; Status) { }
            column(HMS_Admission_Form_Header__Admission_Reason_; "Admission Reason") { }
            column(PatientName; PatientName) { }
            column(ADMISSION_RECORDS_LISTED_____FORMAT__HMS_Admission_Form_Header__COUNT_; 'ADMISSION RECORDS LISTED:' + Format("HMS Admission Form Header".Count)) { }
            column(UNIVERSITY_HEALTH_SERVICESCaption; UNIVERSITY_HEALTH_SERVICESCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(ADMISSION_LISTING_REPORTCaption; ADMISSION_LISTING_REPORTCaptionLbl) { }
            column(No_Caption; No_CaptionLbl) { }
            column(DateCaption; DateCaptionLbl) { }
            column(PF_No_Caption; PF_No_CaptionLbl) { }
            column(HMS_Admission_Form_Header_WardCaption; FieldCaption(Ward)) { }
            column(HMS_Admission_Form_Header_BedCaption; FieldCaption(Bed)) { }
            column(HMS_Admission_Form_Header_DoctorCaption; FieldCaption(Doctor)) { }
            column(HMS_Admission_Form_Header_StatusCaption; FieldCaption(Status)) { }
            column(Patient_nameCaption; Patient_nameCaptionLbl) { }
            column(ReasonCaption; ReasonCaptionLbl) { }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName := '';
                PFNo := '';
                if Patient.Get("Patient No.") then begin
                    PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
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
                LastFieldNo := FieldNo("Admission No.");
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
        UNIVERSITY_HEALTH_SERVICESCaptionLbl: label 'UNIVERSITY HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ADMISSION_LISTING_REPORTCaptionLbl: label 'ADMISSION LISTING REPORT';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        PF_No_CaptionLbl: label 'PF No.';
        Patient_nameCaptionLbl: label 'Patient name';
        ReasonCaptionLbl: label 'Reason';
}

