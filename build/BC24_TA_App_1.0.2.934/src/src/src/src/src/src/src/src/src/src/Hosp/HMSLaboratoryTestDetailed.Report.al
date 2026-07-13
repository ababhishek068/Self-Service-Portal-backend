Report 50212 "HMS Laboratory Test Detailed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSLaboratoryTestDetailed.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Laboratory Form Header"; "HMS Laboratory Form Header")
        {
            DataItemTableView = sorting("Laboratory No.");
            RequestFilterFields = "Laboratory No.";
            column(ReportForNavId_7278; 7278) { }
            column(Date_Printed______FORMAT_TODAY_0_4_; 'Date Printed: ' + Format(Today, 0, 4)) { }
            column(COMPANYNAME; COMPANYNAME) { }
            column(CurrReport_PAGENO; CurrReport.PageNo) { }
            column(Printed_By______USERID; 'Printed By: ' + UserId) { }
            column(HMS_Laboratory_Form_Header__Laboratory_No__; "Laboratory No.") { }
            column(HMS_Laboratory_Form_Header__Laboratory_Date_; "Laboratory Date") { }
            column(PFNo; PFNo) { }
            column(HMS_Laboratory_Form_Header__Supervisor_ID_; "Supervisor ID") { }
            column(HMS_Laboratory_Form_Header_Status; Status) { }
            column(HMS_Laboratory_Form_Header__Patient_Type_; "Patient Type") { }
            column(PatientName; PatientName) { }
            column(Number_of_Laboratory_Tests_Listed______FORMAT__HMS_Laboratory_Form_Header__COUNT_; 'Number of Laboratory Tests Listed: ' + Format("HMS Laboratory Form Header".Count)) { }
            column(UNIVERSITY_HEALTH_SERVICESCaption; UNIVERSITY_HEALTH_SERVICESCaptionLbl) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(LABORATORY_TESTS_LISTINGCaption; LABORATORY_TESTS_LISTINGCaptionLbl) { }
            column(No_Caption; No_CaptionLbl) { }
            column(DateCaption; DateCaptionLbl) { }
            column(PF_No_Caption; PF_No_CaptionLbl) { }
            column(ResponsibleCaption; ResponsibleCaptionLbl) { }
            column(HMS_Laboratory_Form_Header_StatusCaption; FieldCaption(Status)) { }
            column(HMS_Laboratory_Form_Header__Patient_Type_Caption; FieldCaption("Patient Type")) { }
            column(Patient_nameCaption; Patient_nameCaptionLbl) { }
            column(Test_PackageCaption; Test_PackageCaptionLbl) { }
            column(TestCaption; TestCaptionLbl) { }
            column(SpecimenCaption; SpecimenCaptionLbl) { }
            column(StatusCaption; StatusCaptionLbl) { }
            dataitem("HMS Laboratory Test Line"; "HMS Laboratory Test Line")
            {
                DataItemLink = "Laboratory No." = field("Laboratory No.");
                column(ReportForNavId_7451; 7451) { }
                column(HMS_Laboratory_Test_Line__HMS_Laboratory_Test_Line___Laboratory_Test_Name_; "HMS Laboratory Test Line"."Laboratory Test Name") { }
                column(HMS_Laboratory_Test_Line__Laboratory_Test_Name_; "Laboratory Test Name") { }
                column(HMS_Laboratory_Test_Line__Specimen_Name_; "Specimen Name") { }
                column(HMS_Laboratory_Test_Line_Completed; Completed) { }
                column(HMS_Laboratory_Test_Line_Laboratory_No_; "Laboratory No.") { }
                column(HMS_Laboratory_Test_Line_Laboratory_Test_Code; "Laboratory Test Code") { }
                column(HMS_Laboratory_Test_Line_Specimen_Code; "Specimen Code") { }
            }

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
                end
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Laboratory No.");
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
        LABORATORY_TESTS_LISTINGCaptionLbl: label 'LABORATORY TESTS LISTING';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        PF_No_CaptionLbl: label 'PF/No.';
        ResponsibleCaptionLbl: label 'Responsible';
        Patient_nameCaptionLbl: label 'Patient name';
        Test_PackageCaptionLbl: label 'Test Package';
        TestCaptionLbl: label 'Test';
        SpecimenCaptionLbl: label 'Specimen';
        StatusCaptionLbl: label 'Status';
}

