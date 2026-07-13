Page 50323 "HMS Hospital Role Centre"
{
    Caption = 'Role Center';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            group(Control10)
            {
                part(Control60; "Headline RC General Mgt.")
                {
                    ApplicationArea = RelationshipMgmt;
                }
                part(Control8; "HMS Cue")
                {
                    Caption = 'HMS CUE';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Admissions)
            {
                Caption = 'Admissions';
                Image = Payables;
                action(AdmReq)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Requests';
                    Image = FixedAssets;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Admission Form Header";
                    ToolTip = 'Executes the Admission Requests action.';
                }
                action(AdmProg)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Process';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Admission Progress";
                    ToolTip = 'Executes the Admission Process action.';
                }

            }
            group(Referrals)
            {
                Caption = 'Referrals';
                Image = Confirm;
                action(RefHosp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referral Hospitals';
                    Image = SetupColumns;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor Card";
                    ToolTip = 'Executes the Referral Hospitals action.';
                }
                action(ActiveRef)
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Referrals';
                    Image = Setup;
                    Promoted = true;
                    RunObject = Page "HMS Referral Header Active";
                    ToolTip = 'Executes the Active Referrals action.';
                }
                action(hitRef)
                {
                    ApplicationArea = Basic;
                    Caption = 'Completed Referrals';
                    Image = Employee;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Referral Header Released";
                    ToolTip = 'Executes the Completed Referrals action.';
                }
            }
            group(Immunizations)
            {
                Caption = 'Immunizations';
                Image = SNInfo;
                action(Immunization)
                {
                    ApplicationArea = Basic;
                    Image = NewOrder;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Immunization Header";
                    ToolTip = 'Executes the Immunization action.';
                }
                action(ImmHist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunization History';
                    Image = History;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Immunization Posted";
                    ToolTip = 'Executes the Immunization History action.';
                }
            }
            group(Reports)
            {
                Caption = 'HMS Reports';
                Image = SNInfo;

                action(Observ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observations';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Observation Listing Report";
                    ToolTip = 'Executes the Observations action.';
                }
                action(treatment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Treatments';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Treatment Listing Report";
                    ToolTip = 'Executes the Treatments action.';
                }
                action(labtest1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Tests Summary';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Laboratory Test Summary";
                    ToolTip = 'Executes the Lab Tests Summary action.';
                }
                action(labtest2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Tests Detailed';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Laboratory Test Detailed";
                    ToolTip = 'Executes the Lab Tests Detailed action.';
                }
                action(labtest3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab tests Findings';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Laboratory Test Finding";
                    ToolTip = 'Executes the Lab tests Findings action.';
                }
                action(pham_Drug_1)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Student Patients';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Pharmacy Issues Report";
                    ToolTip = 'Executes the Process Student Patients action.';
                }

                action(PatList)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient listing';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Patient Listing Report";
                    ToolTip = 'Executes the Patient listing action.';
                }
                action(Admission_List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission listing';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Admission Listing Summary";
                    ToolTip = 'Executes the Admission listing action.';
                }
                action(Ref_list)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals Listing';
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Referral Listing Report";
                    ToolTip = 'Executes the Referrals Listing action.';
                }


                action(Proc_Emp_and_Deps)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = ExecuteAndPostBatch;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "HMS Process Employee & Deps";
                    ToolTip = 'Executes the Appointments action.';
                }


            }
            group(Setups)
            {
                Caption = 'Hospital Setups';
                Image = SNInfo;
                action(TransactionSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transactions Setup';
                    Image = Opportunity;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Transactions code";
                    ToolTip = 'Executes the Transactions Setup action.';
                }
                action(Ob_signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation Signs';
                    Image = Opportunity;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Observation Signs";
                    ToolTip = 'Executes the Observation Signs action.';
                }
                action(DosageSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dosage Setup';
                    Image = Opportunity;
                    Promoted = true;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Dosage Setup";
                    ToolTip = 'Executes the Dosage Setup action.';
                }
                action(ImmunHist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunization History';
                    Image = History;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Immunization Posted";
                    ToolTip = 'Executes the Immunization History action.';
                }
                action(Setup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Card';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Card";
                    ToolTip = 'Executes the Setup Card action.';
                }
                action(Systems_Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Systems Card';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Systems Card";
                    ToolTip = 'Executes the Systems Card action.';
                }
                action(Setup_Doctor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Doctor';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Doctor Card";
                    ToolTip = 'Executes the Setup Doctor action.';
                }
                action(Setup_Blood_Group)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Blood Group';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Blood Group Card";
                    ToolTip = 'Executes the Setup Blood Group action.';
                }
                action(Blood_Group_Donation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blood Group Donation';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Blood Group Donation Card";
                    ToolTip = 'Executes the Blood Group Donation action.';
                }
                action(LabParameters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Parameters Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Lab Parameters Setup List";
                    ToolTip = 'Executes the Lab Parameters Setup action.';
                }

                action(Drug_Interaction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Drug Interaction';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Drug Interaction Header";
                    ToolTip = 'Executes the Drug Interaction action.';
                }
                action(Observation_Signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation Signs';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Observation Signs";
                    ToolTip = 'Executes the Observation Signs action.';
                }
                action(Appointment_Typ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointment Type';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Appointment Typ Card";
                    ToolTip = 'Executes the Appointment Type action.';
                }

                action("Setup Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Process Card";
                    ToolTip = 'Executes the Process Setup action.';
                }
                action(Injection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Injection';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Injection Card";
                    ToolTip = 'Executes the Injection action.';
                }
                action(Diagnosis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Diagnosis';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Diagnosis Card";
                    ToolTip = 'Executes the Diagnosis action.';
                }
                action(Allergy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allergy';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Allergy Card";
                    ToolTip = 'Executes the Allergy action.';
                }
                action(signs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Signs';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Signs";
                    ToolTip = 'Executes the Signs action.';
                }
                action(Symptoms)
                {
                    ApplicationArea = Basic;
                    Caption = 'Symptoms';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Syptoms";
                    ToolTip = 'Executes the Symptoms action.';
                }
                action(messuring_Uni)
                {
                    ApplicationArea = Basic;
                    Caption = 'Measuring Units';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Measuring Unit Card";
                    ToolTip = 'Executes the Measuring Units action.';
                }
                action(specimen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Specimen Card';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Specimen Card";
                    ToolTip = 'Executes the Specimen Card action.';
                }
                action(Lab_test)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lab Test Setups';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Lab Test Card";
                    ToolTip = 'Executes the Lab Test Setups action.';
                }
                action(Rad_Types)
                {
                    ApplicationArea = Basic;
                    Caption = 'Radiology Types';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Radiology Type Card";
                    ToolTip = 'Executes the Radiology Types action.';
                }
                action(Setup_Disctarge_Process)
                {
                    ApplicationArea = Basic;
                    Caption = 'Setup Disctarge Process';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Setup Disctarge Process";
                    ToolTip = 'Executes the Setup Disctarge Process action.';
                }
                action(wards)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ward Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS ward Setup";
                    ToolTip = 'Executes the Ward Setup action.';
                }
                action(Beds)
                {
                    ApplicationArea = Basic;
                    Caption = 'Beds';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Beds";
                    ToolTip = 'Executes the Beds action.';
                }
                action(Hos_Charges)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hospital Charges Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Charges";
                    ToolTip = 'Executes the Hospital Charges Setup action.';
                }
                action(Hos_Drugs_Prof)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hospital Charges Setup';
                    Image = SetupList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HMS Drugs Profit";
                    ToolTip = 'Executes the Hospital Charges Setup action.';
                }
                group(DataImp)
                {
                    Caption = 'Data Import';
                    action(DiagnosisIMp)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import Diagnosis';
                        Image = SetupList;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = xmlport "HMS Diagnosis Import";
                        ToolTip = 'Executes the Import Diagnosis action.';


                    }
                }
            }
        }
        area(sections)
        {
            group(Registration)
            {
                action("Patients List")
                {
                    ApplicationArea = Basic;
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HMS Patient List";
                    ToolTip = 'Executes the Patients List action.';
                }

            }
            group(Appointments)
            {
                Caption = 'Appointments';
                Image = Statistics;
                action(Action19)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = Register;
                    Promoted = true;
                    RunObject = Page "HMS Appointment List";
                    ToolTip = 'Executes the Appointments action.';
                }

                action(AppointmentsHistory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Appointment Form History L";
                    ToolTip = 'Executes the Appointments History action.';
                }
            }
            group(ObsRoom)
            {
                Caption = 'Observation Room';
                Image = RegisteredDocs;
                action(Observations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observations';
                    RunObject = Page "HMS Observation List";
                    ToolTip = 'Executes the Observations action.';
                }
                action(ObservationHistory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation History';
                    RunObject = Page "HMS Observation History List";
                    ToolTip = 'Executes the Observation History action.';
                }
            }
            group(DocVisit)
            {
                Caption = 'Consultation Room';
                Image = Journals;
                action(DocVisits)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctor''s Visits';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Treatment List";
                    ToolTip = 'Executes the Doctor''s Visits action.';
                }
                action(DoctorsVisitHistory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctor''s Visit History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Treatment History List";
                    ToolTip = 'Executes the Doctor''s Visit History action.';
                }
            }
            group(Physio)
            {
                Caption = 'Physiotherapy';
                Image = RegisteredDocs;
                action(PhysiotheraphyObservations)
                {
                    ApplicationArea = Basic;
                    Caption = 'PhysiotheraphyObservations';
                    RunObject = Page "Physiotheraphy List";
                    ToolTip = 'Executes the PhysiotheraphyObservations action.';
                }
                action("CLosed Physiotheraphy List")
                {
                    ApplicationArea = Basic;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    RunObject = Page "CLosed Physiotheraphy List";
                    ToolTip = 'Executes the CLosed Physiotheraphy List action.';
                }
            }
            group(Lab)
            {
                Caption = 'Lab. Visits';
                Image = FiledPosted;
                action(Lab_List)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Requests';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HMS Laboratory List";
                    ToolTip = 'Executes the Test Requests action.';
                }
                action(findings)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Findings';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Laboratory Form List 2";
                    ToolTip = 'Executes the Test Findings action.';
                }
                action(Hist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doctor''s Visit History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Labo Form History Li";
                    ToolTip = 'Executes the Doctor''s Visit History action.';
                }
            }
            group(Pharmacy)
            {
                Caption = 'Pharmacy';
                Image = Departments;
                action(Pharm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pharmacy List';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Pharmacy List";
                    ToolTip = 'Executes the Pharmacy List action.';
                }
                action(Pharm_Hist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pharmacy History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Pharmacy History List";
                    ToolTip = 'Executes the Pharmacy History action.';
                }
            }
            group(HMS_Admissions)
            {
                Caption = 'Admissions';
                Image = LotInfo;
                action(Pat_Admissions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Admissions';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Admission Form Header List";
                    ToolTip = 'Executes the Patient Admissions action.';
                }
                action(AdmissionProgress)
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission Progress';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Admission Progress List";
                    ToolTip = 'Executes the Admission Progress action.';
                }
            }
            group(Refs)
            {
                Caption = 'Referrals';
                Image = RegisteredDocs;
                action(ref)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Referral Header List";
                    ToolTip = 'Executes the Referrals action.';
                }
                action(ref_Hist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Referral Header List2";
                    ToolTip = 'Executes the Referrals History action.';
                }
            }
            group(Immuns)
            {
                Caption = 'Immunizations';
                Image = ReferenceData;
                action(Immun)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunizations';
                    Image = Register;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HMS Immunization Header List";
                    ToolTip = 'Executes the Immunizations action.';
                }
                action(Immun_History)
                {
                    ApplicationArea = Basic;
                    Caption = 'Immunizations History';
                    Image = History;
                    Promoted = true;
                    RunObject = Page "HMS Immunization Posted List";
                    ToolTip = 'Executes the Immunizations History action.';
                }
            }
            group(Billing)
            {
                Caption = 'Hospital Billing';
                Image = Intrastat;
                action(Receipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Receipts';
                    Image = Insurance;
                    Promoted = true;
                    RunObject = Page "Receipts List";
                    ToolTip = 'Executes the Receipts action.';
                }
                action("Sales Invoice List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice List';
                    RunObject = Page "Sales Invoice List";
                    ToolTip = 'Executes the Invoice List action.';
                }
            }
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Administration;
                action(PendingMyApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending My Approval';
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Executes the Pending My Approval action.';
                }
                action(MyApprovalrequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approval requests';
                    RunObject = Page "Approval Request Entries";
                    ToolTip = 'Executes the My Approval requests action.';
                }
            }
            group(Common_req)
            {
                Caption = 'Common Requisitions';
                Image = LotInfo;
                action(StoresRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stores Requisitions';
                    RunObject = Page "Store Requisition";
                    ToolTip = 'Executes the Stores Requisitions action.';
                }
                action(StaffClaim)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Claim';
                    RunObject = Page "Staff Claim List";
                    ToolTip = 'Executes the Staff Claim action.';
                }
                action(PurchaseRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition';
                    RunObject = Page "Purchase Requisition";
                    ToolTip = 'Executes the Purchase Requisition action.';
                }
                action(ImprestSurrender)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Surrender';
                    RunObject = Page "Imprest Accounting";
                    ToolTip = 'Executes the Imprest Surrender action.';
                }
                action(ImprestRequisitions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imprest Requisitions';
                    RunObject = Page "Imprest List UP";
                    ToolTip = 'Executes the Imprest Requisitions action.';
                }
                action(LeaveApplications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Applications';
                    RunObject = Page "HR Leave Requisition List";
                    ToolTip = 'Executes the Leave Applications action.';
                }
                action(MyApprovedLeaves)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Approved Leaves';
                    Image = History;
                    RunObject = Page "Hr My Approved Leaves List";
                    ToolTip = 'Executes the My Approved Leaves action.';
                }
            }
        }
    }
}

