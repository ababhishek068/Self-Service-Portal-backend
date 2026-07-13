Report 50226 "HMS Treatment Notes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMSTreatmentNotes.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("HMS Treatment Form Header"; "HMS Treatment Form Header")
        {
            RequestFilterFields = "Treatment No.";
            column(ReportForNavId_1; 1) { }
            column(Names; strNm) { }
            column(TreatmentNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment No.") { }
            column(TreatmentType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Type") { }
            column(TreatmentDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Date") { }
            column(TreatmentTime_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Treatment Time") { }
            column(DoctorID_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Doctor ID") { }
            column(PatientNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient No.") { }
            column(StudentNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Student No.") { }
            column(EmployeeNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Employee No.") { }
            column(RelativeNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Relative No.") { }
            column(DoctorNotes_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Doctor Notes") { }
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
            column(IDNumber_HMSTreatmentFormHeader; "HMS Treatment Form Header"."ID Number") { }
            column(CorrespondenceAddress1_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Correspondence Address 1") { }
            column(TelephoneNo1_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Telephone No. 1") { }
            column(Email_HMSTreatmentFormHeader; "HMS Treatment Form Header".Email) { }
            column(PatientRefNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient Ref. No.") { }
            column(PatientName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Patient Name") { }
            column(SettlementType_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Settlement Type") { }
            column(MembershipNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Membership No") { }
            column(InsuranceName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Insurance Name") { }
            column(AdmNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Adm No.") { }
            column(LkNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Lk No") { }
            column(TriageNotes_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Triage Notes") { }
            column(NextAppointmentDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Next Appointment Date") { }
            column(SickOffStartDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Sick Off Start Date") { }
            column(SickOffEndDate_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Sick Off End Date") { }
            column(InPatient_HMSTreatmentFormHeader; "HMS Treatment Form Header".InPatient) { }
            column(StatusRemarks_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Status Remarks") { }
            column(Clinic_HMSTreatmentFormHeader; "HMS Treatment Form Header".Clinic) { }
            column(DoctorsName_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Doctor's Name") { }
            column(WaitingAt_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Waiting At") { }
            column(LabNo_HMSTreatmentFormHeader; "HMS Treatment Form Header"."Lab No") { }
            column(Branch_HMSTreatmentFormHeader; "HMS Treatment Form Header".Branch) { }
            column(DOB; strDateofBirth) { }
            column(Sex; strSex) { }
            column(Residence; strResident) { }
            column(Address; strAddress) { }
            column(DOA; strDOA) { }
            column(Age; strAge) { }
            column(Tel; strTel) { }
            column(PatNo; PatNo) { }
            column(Logo; CompInf.Picture) { }
            column(CompName; CompInf.Name) { }
            column(Adress; CompInf.Address) { }
            column(Adress2; CompInf."Address 2") { }
            column(Phone; CompInf."Phone No.") { }
            column(PB; PB) { }
            column(Temp; Temp) { }
            column(Pulse; Pulse) { }
            column(Resp; Resp) { }
            column(Wt; Wt) { }
            column(O2; O2) { }
            column(HPI; HPI) { }
            column(HPIuser; HPIuser) { }
            column(Nt1; Nt[1]) { }
            column(Nt2; Nt[2]) { }
            column(Nt3; Nt[3]) { }
            column(Nt4; Nt[4]) { }
            column(Nt5; Nt[5]) { }
            column(Nt6; Nt[6]) { }
            column(Nt7; Nt[7]) { }
            column(Nt8; Nt[8]) { }
            column(Nt9; Nt[9]) { }
            column(Nt10; Nt[10]) { }
            column(Chiefcomplaints; Chiefcomplaints) { }
            column(ChiefcomplaintsUser; ChiefcomplaintsUser) { }
            column(CC1; CC[1]) { }
            column(CC2; CC[2]) { }
            column(CC3; CC[3]) { }
            column(CC4; CC[4]) { }
            column(CC5; CC[5]) { }
            column(CC6; CC[6]) { }
            column(CC7; CC[7]) { }
            column(DocNotes; DocNotes) { }
            column(DocNotesUser; DocNotesUser) { }
            column(DocNot1; DocNot[1]) { }
            column(DocNot2; DocNot[2]) { }
            column(DocNot3; DocNot[3]) { }
            column(DocNot4; DocNot[4]) { }
            column(DocNot5; DocNot[5]) { }
            column(DocNot6; DocNot[6]) { }
            column(DocNot7; DocNot[7]) { }
            column(PastSurgicalH; PastSurgicalH) { }
            column(PastSurgicalHUser; PastSurgicalHUser) { }
            column(PSH1; PSH[1]) { }
            column(PSH2; PSH[2]) { }
            column(PSH3; PSH[3]) { }
            column(PSH4; PSH[4]) { }
            column(PSH5; PSH[5]) { }
            column(PSH6; PSH[6]) { }
            column(PSH7; PSH[7]) { }
            column(PastMed; PastMed) { }
            column(PastMedUser; PastMedUser) { }
            column(PMH1; PMH[1]) { }
            column(PMH2; PMH[2]) { }
            column(PMH3; PMH[3]) { }
            column(PMH4; PMH[4]) { }
            column(PMH5; PMH[5]) { }
            column(PMH6; PMH[6]) { }
            column(PMH7; PMH[7]) { }
            column(PastSocialHist; PastSocialHist) { }
            column(PastSocialHistUser; PastSocialHistUser) { }
            column(PSCH1; PSCH[1]) { }
            column(PSCH2; PSCH[2]) { }
            column(PSCH3; PSCH[3]) { }
            column(PSCH4; PSCH[4]) { }
            column(PSCH5; PSCH[5]) { }
            column(PSCH6; PSCH[6]) { }
            column(PSCH7; PSCH[7]) { }
            column(MedicalReport; MedicalReport) { }
            column(MedicalReportUser; MedicalReportUser) { }
            column(MEDR1; MEDR[1]) { }
            column(MEDR2; MEDR[2]) { }
            column(MEDR3; MEDR[3]) { }
            column(MEDR4; MEDR[4]) { }
            column(MEDR5; MEDR[5]) { }
            column(MEDR6; MEDR[6]) { }
            column(MEDR7; MEDR[7]) { }
            column(TreatmentPlan; TreatmentPlan) { }
            column(TreatmentPlanUser; TreatmentPlanUser) { }
            column(TreatP1; TreatP[1]) { }
            column(TreatP2; TreatP[2]) { }
            column(TreatP3; TreatP[3]) { }
            column(TreatP4; TreatP[4]) { }
            column(TreatP5; TreatP[5]) { }
            column(TreatP6; TreatP[6]) { }
            column(TreatP7; TreatP[7]) { }
            column(Investigations; Investigations) { }
            column(InvestigationsUser; InvestigationsUser) { }
            column(Inves1; Inves[1]) { }
            column(Inves2; Inves[2]) { }
            column(Inves3; Inves[3]) { }
            column(Inves4; Inves[4]) { }
            column(Inves5; Inves[5]) { }
            column(Inves6; Inves[6]) { }
            column(Inves7; Inves[7]) { }
            column(AssessmentPlan; AssessmentPlan) { }
            column(AssessmentPlanuser; AssessmentPlanuser) { }
            column(Asses1; Asses[1]) { }
            column(Asses2; Asses[2]) { }
            column(Asses3; Asses[3]) { }
            column(Asses4; Asses[4]) { }
            column(Asses5; Asses[5]) { }
            column(Asses6; Asses[6]) { }
            column(Asses7; Asses[7]) { }
            column(ReviewsOfSytems; ReviewsOfSytems) { }
            column(ReviewsOfSytemsUser; ReviewsOfSytemsUser) { }
            column(RvwS1; RvwS[1]) { }
            column(RvwS2; RvwS[2]) { }
            column(RvwS3; RvwS[3]) { }
            column(RvwS4; RvwS[4]) { }
            column(RvwS5; RvwS[5]) { }
            column(RvwS6; RvwS[6]) { }
            column(RvwS7; RvwS[7]) { }
            column(Impression; Impression) { }
            column(Impressionuser; Impressionuser) { }
            column(Impr1; Impr[1]) { }
            column(Impr2; Impr[2]) { }
            column(Impr3; Impr[3]) { }
            column(Impr4; Impr[4]) { }
            column(Impr5; Impr[5]) { }
            column(Impr6; Impr[6]) { }
            column(Impr7; Impr[7]) { }
            column(VisualAcuity; VisualAcuity) { }
            column(VisualAcuityUser; VisualAcuityUser) { }
            column(VA1; VA[1]) { }
            column(VA2; VA[2]) { }
            column(VA3; VA[3]) { }
            column(VA4; VA[4]) { }
            column(VA5; VA[5]) { }
            column(VA6; VA[6]) { }
            column(VA7; VA[7]) { }
            column(PastOcularHis; PastOcularHis) { }
            column(PastOcularHisUser; PastOcularHisUser) { }
            column(POCH1; POCH[1]) { }
            column(POCH2; POCH[2]) { }
            column(POCH3; POCH[3]) { }
            column(POCH4; POCH[4]) { }
            column(POCH5; POCH[5]) { }
            column(POCH6; POCH[6]) { }
            column(POCH7; POCH[7]) { }
            column(PhysicalExam; PhysicalExam) { }
            column(PhysicalExamUser; PhysicalExamUser) { }
            column(PhyEx1; PhyEx[1]) { }
            column(PhyEx2; PhyEx[2]) { }
            column(PhyEx3; PhyEx[3]) { }
            column(PhyEx4; PhyEx[4]) { }
            column(PhyEx5; PhyEx[5]) { }
            column(PhyEx6; PhyEx[6]) { }
            column(PhyEx7; PhyEx[7]) { }
            column(Diagnosis; Diagnosis) { }
            column(DiagnosisName1; DiagnosisName[1]) { }
            column(DiagnosisName2; DiagnosisName[2]) { }
            column(DiagnosisName3; DiagnosisName[3]) { }
            column(DiagnosisName4; DiagnosisName[4]) { }
            column(DiagnosisName5; DiagnosisName[5]) { }
            column(DiagnosisName6; DiagnosisName[6]) { }
            column(DiagnosisName7; DiagnosisName[7]) { }
            column(TreatDone; TreatDone) { }
            column(TDone1; TDone[1]) { }
            column(TDone2; TDone[2]) { }
            column(TDone3; TDone[3]) { }
            column(TDone4; TDone[4]) { }
            column(TDone5; TDone[5]) { }
            column(TDone6; TDone[6]) { }
            column(TDone7; TDone[7]) { }
            column(PastDental; PastDental) { }
            column(PastDentalUser; PastDentalUser) { }
            column(PDent1; PDent[1]) { }
            column(PDent2; PDent[2]) { }
            column(PDent3; PDent[3]) { }
            column(PDent4; PDent[4]) { }
            column(PDent5; PDent[5]) { }
            column(PDent6; PDent[6]) { }
            column(PDent7; PDent[7]) { }
            column(PastFam; PastFam) { }
            column(PastFamUser; PastFamUser) { }
            column(PFam1; PFam[1]) { }
            column(PFam2; PFam[2]) { }
            column(PFam3; PFam[3]) { }
            column(PFam4; PFam[4]) { }
            column(PFam5; PFam[5]) { }
            column(PFam6; PFam[6]) { }
            column(PFam7; PFam[7]) { }
            dataitem("HMS Laboratory Results Entry"; "HMS Laboratory Results Entry")
            {
                DataItemLink = "Laboratory No." = field("Lab No");
                DataItemTableView = sorting("Laboratory No.", "Laboratory Test Code", "Sort Test", "Specimen Code") order(ascending);
                PrintOnlyIfDetail = false;
                column(ReportForNavId_228; 228) { }
                column(PatNames; HMSPat."Search Name") { }
                column(LaboratoryNo_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Laboratory No.") { }
                column(LaboratoryTestCode_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Laboratory Test Code") { }
                column(SpecimenCode_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Specimen Code") { }
                column(SpecimenName_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Specimen Name") { }
                column(AssignedUserID_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Assigned User ID") { }
                column(CollectionDate_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Collection Date") { }
                column(CollectionTime_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Collection Time") { }
                column(MeasuringUnitCode_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Measuring Unit Code") { }
                column(MeasuringUnitName_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Measuring Unit Name") { }
                column(Results_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Results) { }
                column(Remarks_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Remarks) { }
                column(Completed_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Completed) { }
                column(Positive_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Positive) { }
                column(TestNormalRanges_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Test Normal Ranges") { }
                column(TestUnits_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Test Units") { }
                column(Flag_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Flag) { }
                column(Reactive_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry".Reactive) { }
                column(NormalRange_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Normal Range") { }
                column(SortTest_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Sort Test") { }
                column(LabTestDate_HMSLaboratoryResultsEntry; "HMS Laboratory Results Entry"."Lab Test  Date") { }
                column(DoctID; DocsRec."Doctors Name") { }
                column(ReceivedDate; LabH."Laboratory Date") { }
                column(CompletionDate; LabH."Completion Date") { }
                column(TestDesc; LabTest.Description) { }
                column(SupervisorID; LabH."Supervisor ID") { }
                column(AgeinYrs; HMSPat."Age in Years") { }
                column(PatGender; HMSPat.Gender) { }
                column(LaboratoryTestName_HMSLaboratoryResultsEntry; TestName) { }
                column(Results; Matokeo) { }
                column(Counts; Counts) { }

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
                    //Counts:=0;
                end;
            }
            dataitem("HMS Treatment Form Drug"; "HMS Treatment Form Drug")
            {
                DataItemLink = "Treatment No." = field("Treatment No.");
                PrintOnlyIfDetail = false;
                column(ReportForNavId_210; 210) { }
                column(TreatmentNo_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Treatment No.") { }
                column(DrugNo_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Drug No.") { }
                column(DrugName_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Drug Name") { }
                column(Quantity_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Quantity) { }
                column(UnitOfMeasure_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Unit Of Measure") { }
                column(Remarks_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Remarks) { }
                column(PharmacyCode_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Pharmacy Code") { }
                column(ActualQuantity_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Actual Quantity") { }
                column(Inventory_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Inventory) { }
                column(Issued_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Issued) { }
                column(Take_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Take) { }
                column(MarkedasIncompatible_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Marked as Incompatible") { }
                column(ProductGroup_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Product Group") { }
                column(Route_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Route) { }
                column(Frequency_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Frequency) { }
                column(Dosage_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Dosage) { }
                column(NumberofDays_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Number of Days") { }
                column(Posted_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Posted) { }
                column(IPStatus_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."IP Status") { }
                column(Inpatient_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Inpatient) { }
                column(Stoppedby_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Stopped by") { }
                column(StoppedDate_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Stopped Date") { }
                column(PrescriptionDose_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Prescription Dose") { }
                column(DateTaken_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Date Taken") { }
                column(Status_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Status) { }
                column(UnitPrice_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Unit Price") { }
                column(TotalPrice_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Total Price") { }
                column(LlineNo_HMSTreatmentFormDrug; "HMS Treatment Form Drug"."Lline No") { }
                column(Branch_HMSTreatmentFormDrug; "HMS Treatment Form Drug".Branch) { }
            }

            trigger OnAfterGetRecord()
            begin
                TreatHD.Reset;
                TreatHD.SetRange(TreatHD."Treatment No.", "HMS Treatment Form Header"."Treatment No.");
                if TreatHD.Find('-') then begin
                    if TreatHD."Doctor's Name" = '' then begin
                        //"HMS Treatment Form Header".CALCFIELDS("HMS Treatment Form Header"."Doctor ID");
                        DocId.Get("HMS Treatment Form Header"."Doctor ID");
                        TreatHD."Doctor's Name" := DocId."Doctors Name";
                        TreatHD.Modify;
                    end;
                    HMSPat.SetRange(HMSPat."Patient No.", "HMS Treatment Form Header"."Patient No.");
                    if HMSPat.Find('-') then
                        strNm := HMSPat.Surname + ' ' + HMSPat."Middle Name" + ' ' + HMSPat."Last Name";
                    strAddress := HMSPat."Correspondence Address 1";
                    strResident := HMSPat."Correspondence Address 2";
                    strDateofBirth := Format(HMSPat."Date Of Birth");
                    // strDOA:=FORMAT("HMS Treatment Admission"."Date Of Admission") ;
                    strSex := Format(HMSPat.Gender);
                    strTel := HMSPat."Telephone No. 1";
                    strAge := Format(HMSPat."Age in Years");
                    PatNo := TreatHD."Patient No.";
                end;
                // ,DoctorsNotes,MedicalReport,history,Treatment Plan,Chief Complaints,Past Medical History,Past Surgical History,Social History,Investigations,Assessment and plan,Reviews of Systems,Impression,Visual Acuity,Past Ocular History
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::history);
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            HPI := 'History Of Present Illness';
                            Nt[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                ObjPhyEx.Reset;
                ObjPhyEx.SetRange(ObjPhyEx."Treatment No.", "HMS Treatment Form Header"."Treatment No.");
                if ObjPhyEx.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PhysicalExam := 'Physical Exam';
                            PhysicalExamUser := "HMS Treatment Form Header"."Doctor's Name";
                            PhyEx[i] := ObjPhyEx."Sign Code" + ' ' + ObjPhyEx.System + ' ' + ObjPhyEx."Sign Description" + '  ';
                        end;
                    until ObjPhyEx.Next = 0;
                end;
                i := 0;
                ObjDiagnosis.Reset;
                ObjDiagnosis.SetRange(ObjDiagnosis."Treatment No.", "HMS Treatment Form Header"."Treatment No.");
                if ObjDiagnosis.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            Diagnosis := 'Diagnosis';
                            ObjDiagnosis.CalcFields(ObjDiagnosis."Diagnosis Name");
                            DiagnosisName[i] := ObjDiagnosis."Diagnosis No." + ' ' + ObjDiagnosis."Diagnosis Code" + ' ' + ObjDiagnosis."Diagnosis Name" + '  ';
                        end;
                    until ObjDiagnosis.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Assessment and plan");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            AssessmentPlan := 'Assessment and plan';
                            AssessmentPlanuser := HMSNotes."User ID";
                            Asses[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::DoctorsNotes);
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            DocNotes := 'Doctors Notes';
                            DocNotesUser := HMSNotes."User ID";
                            DocNot[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Chief Complaints");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            Chiefcomplaints := 'Chief Complaints';
                            ChiefcomplaintsUser := HMSNotes."User ID";
                            CC[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::Impression);
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            Impression := 'Impression';
                            Impressionuser := HMSNotes."User ID";
                            Impr[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::Investigations);
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            Investigations := 'Investigations';
                            InvestigationsUser := HMSNotes."User ID";
                            Inves[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Treatment Done");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            TreatDone := 'Treatment Done';
                            TreatDoneUser := HMSNotes."User ID";
                            TDone[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::MedicalReport);
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            MedicalReport := 'Medical Report';
                            MedicalReportUser := HMSNotes."User ID";
                            MEDR[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Past Medical History");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PastMed := 'Past Medical History';
                            PastMedUser := HMSNotes."User ID";
                            PMH[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Past Ocular History");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PastOcularHis := 'Past Ocular History';
                            PastOcularHisUser := HMSNotes."User ID";
                            POCH[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Past Surgical History");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PastSurgicalH := 'Past Surgical History';
                            PastSurgicalHUser := HMSNotes."User ID";
                            PSH[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Reviews of Systems");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            ReviewsOfSytems := 'Reviews of Systems';
                            ReviewsOfSytemsUser := HMSNotes."User ID";
                            RvwS[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Social History");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PastSocialHist := 'Social History';
                            PastSocialHistUser := HMSNotes."User ID";
                            PSCH[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Treatment Plan");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            TreatmentPlan := 'Treatment Plan';
                            TreatmentPlanUser := HMSNotes."User ID";
                            TreatP[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Past Dental History");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PastDental := 'Past Dental History';
                            PastDentalUser := HMSNotes."User ID";
                            PDent[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Past Family History");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            PastFam := 'Past Family History';
                            PastFamUser := HMSNotes."User ID";
                            PFam[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;
                HMSNotes.Reset;
                HMSNotes.SetRange(HMSNotes.TreatmentNo, "HMS Treatment Form Header"."Treatment No.");
                HMSNotes.SetRange(HMSNotes."Notes Type", HMSNotes."notes type"::"Visual Acuity");
                if HMSNotes.Find('-') then begin
                    repeat
                        if i < 11 then begin
                            i := i + 1;
                            VisualAcuity := 'Visual Acuity';
                            VisualAcuityUser := HMSNotes."User ID";
                            VA[i] := HMSNotes.Notes
                        end;
                    until HMSNotes.Next = 0;
                end;
                i := 0;

                TreatmentFormProcess.Reset;
                TreatmentFormProcess.SetRange(TreatmentFormProcess."Treatment No.", "HMS Treatment Form Header"."Treatment No.");
                if TreatmentFormProcess.Find('-') then begin
                    repeat
                        if TreatmentFormProcess."No." = 'SYSTOLIC/DIASTOLIC' then
                            PB := TreatmentFormProcess.Results;
                        if TreatmentFormProcess."No." = 'TEMP' then
                            Temp := TreatmentFormProcess.Results;
                        if TreatmentFormProcess."No." = 'PULSE RATE' then
                            Pulse := TreatmentFormProcess.Results;
                        if TreatmentFormProcess."No." = 'WEIGHT' then
                            Wt := TreatmentFormProcess.Results;
                        if TreatmentFormProcess."No." = 'SP02' then
                            O2 := TreatmentFormProcess.Results;
                    until TreatmentFormProcess.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get;
                CompInf.CalcFields(Picture);
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
        TreatmentFormProcess: Record "HMS Treatment Form Process";
        TreatHD: Record "HMS Treatment Form Header";
        strNm: Text;
        strDateofBirth: Text;
        strSex: Text;
        strResident: Text;
        strAddress: Text;
        strDOA: Text;
        strTel: Text;
        strAge: Text;
        PatNo: Code[20];
        CompInf: Record "Company Information";
        PB: Code[20];
        Temp: Code[20];
        Pulse: Code[20];
        Resp: Code[20];
        Wt: Code[20];
        O2: Code[20];
        HMSNotes: Record "hms Notes";
        Nt: array[10] of Text[500];
        HPI: Text;
        HPIuser: Text;
        i: Integer;
        CC: array[10] of Text[500];
        Chiefcomplaints: Text;
        ChiefcomplaintsUser: Text;
        DocNot: array[10] of Text[500];
        DocNotes: Text;
        DocNotesUser: Text;
        PMH: array[10] of Text[500];
        PastMed: Text;
        PastMedUser: Text;
        PSH: array[10] of Text[500];
        PastSurgicalH: Text;
        PastSurgicalHUser: Text;
        PSCH: array[10] of Text[500];
        PastSocialHist: Text;
        PastSocialHistUser: Text;
        MEDR: array[10] of Text[500];
        MedicalReport: Text;
        MedicalReportUser: Text;
        TreatP: array[10] of Text[500];
        TreatmentPlan: Text;
        TreatmentPlanUser: Text;
        Inves: array[10] of Text[500];
        Investigations: Text;
        InvestigationsUser: Text;
        Asses: array[10] of Text[500];
        AssessmentPlan: Text;
        AssessmentPlanuser: Text;
        RvwS: array[10] of Text[500];
        ReviewsOfSytems: Text;
        ReviewsOfSytemsUser: Text;
        Impr: array[10] of Text[500];
        Impression: Text;
        Impressionuser: Text;
        VA: array[10] of Text[500];
        VisualAcuity: Text;
        VisualAcuityUser: Text;
        POCH: array[10] of Text[500];
        PastOcularHis: Text;
        PastOcularHisUser: Text;
        PhyEx: array[10] of Text[500];
        PhysicalExam: Text;
        PhysicalExamUser: Text;
        ObjPhyEx: Record "HMS Observation Signs";
        LabH: Record "HMS Laboratory Form Header";
        LabTest: Record "HMS Setup Lab Test";
        DocsRec: Record "HMS Setup Doctor";
        Matokeo: Text[250];
        Counts: Integer;
        TestName: Text;
        Diagnosis: Text;
        DiagnosisName: array[10] of Text[500];
        ObjDiagnosis: Record "HMS Treatment Form Diagnosis";
        DocId: Record "HMS Setup Doctor";
        TreatDone: Text;
        TDone: array[10] of Text[500];
        TreatDoneUser: Text;
        PastDental: Text;
        PastDentalUser: Text;
        PDent: array[10] of Text[500];
        PastFam: Text;
        PastFamUser: Text;
        PFam: array[10] of Text[500];
}

