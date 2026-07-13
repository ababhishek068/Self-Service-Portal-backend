Report 50135 "HMS Lab Result"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSLabResult.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Laboratory Results Entry"; "HMS Laboratory Results Entry")
        {
            DataItemTableView = sorting("Laboratory No.", "Laboratory Test Code", "Sort Test", "Specimen Code") order(ascending);
            column(ReportForNavId_1; 1) { }
            column(LaboratoryNo_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Laboratory No.") { }
            column(LaboratoryTestCode_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Laboratory Test Code") { }
            column(SpecimenCode_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Specimen Code") { }
            column(SpecimenName_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Specimen Name") { }
            column(MeasuringUnitCode_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Measuring Unit Code") { }
            column(MeasuringUnitName_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Measuring Unit Name") { }
            column(TestNormalRanges_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Test Normal Ranges") { }
            column(CountValue_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Results) { }
            column(Remarks_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Remarks) { }
            column(Positive_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Positive) { }
            column(Completed_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Completed) { }
            column(PatNo; HMSPat."Patient No.") { }
            column(PatNames; HMSPat."Search Name") { }
            column(DoctID; DocsRec."Doctors Name") { }
            column(ReceivedDate; LabH."Laboratory Date") { }
            column(CompletionDate; LabH."Completion Date") { }
            column(CompName; CompInf.Name) { }
            column(CompLogo; CompInf.Picture) { }
            column(TestDesc; LabTest.Description) { }
            column(Flag_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Flag) { }
            column(SupervisorID; LabH."Supervisor ID") { }
            column(AgeinYrs; HMSPat."Age in Years") { }
            column(PatGender; HMSPat.Gender) { }
            column(LaboratoryTestName_HMSLaboratoryResultsEntry; TestName) { }
            column(Reactive_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Reactive) { }
            column(Results; Matokeo) { }
            column(Counts; Counts) { }
            column(SortTest_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Sort Test") { }
            column(AssignedUserID_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Assigned User ID") { }

            trigger OnAfterGetRecord()
            begin
                if LabH.Get("HMS Laboratory Results Entry"."Laboratory No.") then begin
                    if DocsRec.Get(LabH."Doctor ID") then;
                    if HMSPat.Get(LabH."Patient No.") then begin
                        LabTest.Reset;
                        LabTest.SetRange(LabTest.Code, "HMS Laboratory Results Entry"."Laboratory Test Code");
                        if LabTest.Find('-') then begin
                            //LabTest.CALCFIELDS(LabTest.Description);
                            TestName := LabTest.Description;
                        end;
                    end;
                end;
                if ("HMS Laboratory Results Entry".Results > 0.0)
                  then begin
                    Matokeo := Format("HMS Laboratory Results Entry".Results);
                end else begin
                    Matokeo := "HMS Laboratory Results Entry".Remarks;
                end;

                Counts := Counts + 1;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(CompInf.Picture);
                //CALCFIELDS("HMS Laboratory Results Entry"."Specimen Code");
                CalcFields("HMS Laboratory Results Entry"."Specimen Name");
                CalcFields("HMS Laboratory Results Entry"."Laboratory Test Name");
                Counts := 0;
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
        HMSPat: Record "HMS Patient";
        LabH: Record "HMS Laboratory Form Header";
        CompInf: Record "Company Information";
        LabTest: Record "HMS Setup Lab Test";
        DocsRec: Record "HMS Setup Doctor";
        Matokeo: Text[250];
        Counts: Integer;
        TestName: Text;
}

