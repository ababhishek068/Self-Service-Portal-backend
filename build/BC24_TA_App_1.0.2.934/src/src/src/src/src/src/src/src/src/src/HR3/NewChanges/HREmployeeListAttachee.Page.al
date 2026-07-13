Page 51280 "HR Employee List-Attachee"
{
    CardPageID = Employee;
    PageType = List;
    SourceTable = "HR-Employee";
    SourceTableView = where("Employee Contract Type" = filter(Intern));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(DepartmentName; Rec."Department Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Name field.';
                }

                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initials field.';
                }

                field(PostalAddress; Rec."Postal Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field(ResidentialAddress; Rec."Residential Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Residential Address field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Region field.';
                }
                field(HomePhoneNumber; Rec."Home Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Home Phone Number field.';
                }
                field(CellularPhoneNumber; Rec."Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cellular Phone Number field.';
                }
                field(WorkPhoneNumber; Rec."Work Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Work Phone Number field.';
                }
                field(Ext; Rec."Ext.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ext. field.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(CompanyEMail; Rec."Company E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company E-Mail field.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field(FullPartTime; Rec."Full / Part Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Full / Part Time field.';
                }
                field(ContractType; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field(ContractEndDate; Rec."Contract End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract End Date field.';
                }
                field(NoticePeriod; Rec."Notice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notice Period field.';
                }
                field(ContractedHours; Rec."Contracted Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contracted Hours field.';
                }
                field(MaritalStatus; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field(EthnicOrigin; Rec."Ethnic Origin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ethnic Origin field.';
                }
                field(FirstLanguageRWS; Rec."First Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Language (R/W/S) field.';
                }
                field(DrivingLicence; Rec."Driving Licence")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Driving Licence field.';
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Persons with Disability? field.';
                }
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Age field.';
                }

                field(LengthOfService; Rec."Length Of Service")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Length Of Service field.';
                }
                field(EndOfProbationDate; Rec."End Of Probation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Of Probation Date field.';
                }
                field(PensionSchemeJoin; Rec."Pension Scheme Join")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Scheme Join field.';
                }
                field(TimePensionScheme; Rec."Time Pension Scheme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Pension Scheme field.';
                }
                field(MedicalSchemeJoin; Rec."Medical Scheme Join")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Scheme Join field.';
                }
                field(TimeMedicalScheme; Rec."Time Medical Scheme")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Medical Scheme field.';
                }
                field(DateOfLeaving; Rec."Date Of Leaving")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Leaving field.';
                }
                field(NumberOfDependants; Rec."Number Of Dependants")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Number Of Dependants field.';
                }
                field(MedicalSchemeName; Rec."Medical Scheme Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Scheme Name field.';
                }
                field(AmountPaidByEmployee; Rec."Amount Paid By Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount Paid By Employee field.';
                }
                field(AmountPaidByCompany; Rec."Amount Paid By Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount Paid By Company field.';
                }
                field(ReceivingCarAllowance; Rec."Receiving Car Allowance ?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Receiving Car Allowance ? field.';
                }
                field(SecondLanguageRWS; Rec."Second Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Second Language (R/W/S) field.';
                }
                field(AdditionalLanguage; Rec."Additional Language")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Additional Language field.';
                }
                field(DirectIndirect; Rec."Direct/Indirect")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Direct/Indirect field.';
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Level field.';
                }
                field(TerminationCategory; Rec."Termination Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Termination Category field.';
                }
                field(PostalAddress2; Rec."Postal Address2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address2 field.';
                }
                field(PostalAddress3; Rec."Postal Address3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address3 field.';
                }
                field(ResidentialAddress2; Rec."Residential Address2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Residential Address2 field.';
                }
                field(ResidentialAddress3; Rec."Residential Address3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Residential Address3 field.';
                }
                field(PostCode2; Rec."Post Code2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Code2 field.';
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Citizenship field.';
                }
                field(NameOfManager; Rec."Name Of Manager")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name Of Manager field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(DisablingDetails; Rec."Disabling Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disabling Details field.';
                }
                field(DisabilityGrade; Rec."Disability Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disability Grade field.';
                }
                field(PassportNumber; Rec."Passport Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Passport Number field.';
                }
                field("2ndSkillsCategory"; Rec."2nd Skills Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the 2nd Skills Category field.';
                }
                field("3rdSkillsCategory"; Rec."3rd Skills Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the 3rd Skills Category field.';
                }
                field(ManagerEmpNo; Rec."Manager Emp No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Manager Emp No field.';
                }
                field(FirstLanguageRead; Rec."First Language Read")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Language Read field.';
                }
                field(FirstLanguageWrite; Rec."First Language Write")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Language Write field.';
                }
                field(FirstLanguageSpeak; Rec."First Language Speak")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Language Speak field.';
                }
                field(SecondLanguageRead; Rec."Second Language Read")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Second Language Read field.';
                }
                field(SecondLanguageWrite; Rec."Second Language Write")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Second Language Write field.';
                }
                field(SecondLanguageSpeak; Rec."Second Language Speak")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Second Language Speak field.';
                }

                field("TIN No."; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(PensionNo; Rec."Pension No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension No. field.';
                }
                field(NHIFNo; Rec."NHIF No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the NHIF No. field.';
                }
                field(CauseofInactivityCode; Rec."Cause of Inactivity Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cause of Inactivity Code field.';
                }
                field(GroundsforTermCode; Rec."Grounds for Term. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grounds for Term. Code field.';
                }
                field(SaccoStaffNo; Rec."Sacco Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sacco Staff No field.';
                }
                field(HELBNo; Rec."HELB No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HELB No field.';
                }
                field(WeddingAnniversary; Rec."Wedding Anniversary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Wedding Anniversary field.';
                }

                field(CompetencyArea; Rec."Competency Area")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Competency Area field.';
                }
                field(CostCenterCode; Rec."Cost Center Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cost Center Code field.';
                }
                field(SendAlertto; Rec."Send Alert to")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Send Alert to field.';
                }
                field(Tribe; Rec.Tribe)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tribe field.';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Religion field.';
                }
                field(PostOfficeNo; Rec."Post Office No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Office No field.';
                }
                field(PostingGroup; Rec."Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }
                field(PayrollPostingGroup; Rec."Payroll Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payroll Posting Group field.';
                }
                field(ServedNoticePeriod; Rec."Served Notice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Served Notice Period field.';
                }
                field(ExitInterviewDate; Rec."Exit Interview Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exit Interview Date field.';
                }
                field(ExitInterviewDoneby; Rec."Exit Interview Done by")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exit Interview Done by field.';
                }
                field(AllowReEmploymentInFuture; Rec."Allow Re-Employment In Future")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Re-Employment In Future field.';
                }
                field(MedicalSchemeName2; Rec."Medical Scheme Name #2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Scheme Name #2 field.';
                }
                field(ResignationDate; Rec."Resignation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resignation Date field.';
                }
                field(SuspensionDate; Rec."Suspension Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Suspension Date field.';
                }
                field(DemisedDate; Rec."Demised Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Demised Date field.';
                }
                field(Retirementdate; Rec."Retirement date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retirement date field.';
                }
                field(Retrenchmentdate; Rec."Retrenchment date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retrenchment date field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field(Permanent; Rec.Permanent)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Permanent field.';
                }

                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }


                field(CompanyType; Rec."Company Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Type field.';
                }
                field(MainBank; Rec."Main Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field(BranchBank; Rec."Branch Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field(LockBankDetails; Rec."Lock Bank Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lock Bank Details field.';
                }
                field(BankAccountNumber; Rec."Bank Account Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Account Number field.';
                }
                field(PayrollCode; Rec."Payroll Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payroll Code field.';
                }
                field(HolidayDaysEntitlement; Rec."Holiday Days Entitlement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Holiday Days Entitlement field.';
                }
                field(HolidayDaysUsed; Rec."Holiday Days Used")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Holiday Days Used field.';
                }
                field(MedicalSchemeJoinDate; Rec."Medical Scheme Join Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Scheme Join Date field.';
                }


            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(EmployeeInfo)
            {
                Caption = 'Employee Info';
                group(Print)
                {
                    Caption = '&Print';
                    action(IDNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'ID No';
                        Image = PrintReport;
                        Promoted = true;
                        PromotedCategory = Category4;
                        ToolTip = 'Executes the ID No action.';

                        trigger OnAction()
                        begin
                            HREmp.Reset;
                            HREmp.SetRange(HREmp."No.", Rec."No.");
                            if HREmp.Find('-') then
                                Report.Run(70135242, true, true, HREmp);
                        end;
                    }
                    action(ValueChangeReport)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Value Change Report';
                        Image = PrintReport;
                        Promoted = true;
                        PromotedCategory = Category4;
                        ToolTip = 'Executes the Value Change Report action.';

                        trigger OnAction()
                        begin
                            HRValueChange.Reset;
                            HRValueChange.SetRange(HRValueChange."employee No", Rec."No.");
                            if HRValueChange.Find('-') then
                                Report.Run(70135239, true, true, HRValueChange)
                            else
                                Error('No value changes have been recorded for this employee');
                        end;
                    }
                }
                group(Employee)
                {
                    Caption = '&Employee';
                    // action(NextofKin)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Next of Kin';
                    //     Image = Relatives;
                    //     Promoted = true;
                    //     PromotedCategory = Category6;
                    //     RunObject = Page "HR Employees Kin";
                    //     RunPageLink = "Employee Code" = field("No."),
                    //                   Type = filter("Next of Kin");
                    // }
                    // action(Beneficiaries)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Beneficiaries';
                    //     Image = Opportunity;
                    //     Promoted = true;
                    //     PromotedCategory = Category6;
                    //     RunObject = Page "HR Employee Beneficiary";
                    //     RunPageLink = "Employee Code" = field("No."),
                    //                   Type = filter(Beneficiary);
                    // }
                    // action(Dependants)
                    // {
                    //     ApplicationArea = Basic;
                    //     Caption = 'Dependants';
                    //     Image = Relatives;
                    //     Promoted = true;
                    //     PromotedCategory = Category6;
                    //     RunObject = Page "HR Employees Dependants";
                    //     RunPageLink = "Employee Code" = field("No."),
                    //                   Type = filter(Dependant);
                    // }
                    action(Qualifications)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Qualifications';
                        Image = QualificationOverview;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "Employee Qualifications 2";
                        RunPageLink = "Employee No." = field("No.");
                        ToolTip = 'Executes the Qualifications action.';
                    }
                    action(EmploymentHistory)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Employment History';
                        Image = History;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "Employment History";
                        RunPageLink = "Employee No. Filter" = field("No.");
                        ToolTip = 'Executes the Employment History action.';
                    }
                    action(ProffessionalMembership)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Proffessional Membership';
                        Image = Group;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "Hr Proffessional Membership";
                        RunPageLink = "Employee Code" = field("No.");
                        ToolTip = 'Executes the Proffessional Membership action.';
                    }
                    action(TrainingHistory)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Training History';
                        Image = Certificate;
                        Promoted = true;
                        PromotedCategory = Category6;
                        PromotedIsBig = false;
                        RunObject = Page "HR training History";
                        RunPageLink = "Employee No." = field("No.");
                        ToolTip = 'Executes the Training History action.';
                    }
                    action(EmployeeResponsibilities)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Employee Responsibilities';
                        Image = ResourcePlanning;
                        Promoted = true;
                        PromotedCategory = Category6;
                        PromotedIsBig = false;
                        RunObject = Page "HR Job Responsiblities (RO)";
                        ToolTip = 'Executes the Employee Responsibilities action.';
                        // RunPageLink = "Responsibility Description" = field("Job Title");
                    }
                    action(AssignClearanceItems)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Assign Clearance Items';
                        Image = ExternalDocument;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "Misc. Article Information";
                        RunPageLink = "Employee No." = field("No.");
                        ToolTip = 'Executes the Assign Clearance Items action.';
                    }
                    action(ViewClearanceDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'View Clearance Details';
                        Image = ExternalDocument;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "HR Asset Return Form";
                        RunPageLink = "Employee No." = field("No.");
                        ToolTip = 'Executes the View Clearance Details action.';
                    }
                    action(MiscArticlesOverview)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Misc. Articles Overview';
                        Image = ViewSourceDocumentLine;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "Misc. Articles Overview";
                        ToolTip = 'Executes the Misc. Articles Overview action.';
                    }
                    action(ConfidentialInformation)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Confidential Information';
                        Image = SNInfo;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category6;
                        RunObject = Page "Confidential Information";
                        RunPageLink = "Employee No." = field("No.");
                        ToolTip = 'Executes the &Confidential Information action.';
                    }
                    action(ConfidentialInfoOverview)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Co&nfidential Info. Overview';
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category6;
                        RunObject = Page "Confidential Info. Overview";
                        ToolTip = 'Executes the Co&nfidential Info. Overview action.';
                    }
                    action(Absences)
                    {
                        ApplicationArea = Basic;
                        Caption = 'A&bsences';
                        Image = AbsenceCalendar;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category6;
                        RunObject = Page "Employee Absences";
                        RunPageLink = "Employee No." = field("No.");
                        ToolTip = 'Executes the A&bsences action.';
                    }
                    action(Dimensions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions';
                        Image = Dimensions;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category6;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(5200),
                                      "No." = field("No.");
                        ToolTip = 'Executes the Dimensions action.';
                    }
                    action(EmployeePicture)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Employee Picture';
                        Image = Picture;
                        RunObject = Page "Hr Employee Picture";
                        ToolTip = 'Executes the Employee Picture action.';
                    }
                    action(HiringDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hiring Details';
                        Image = Answers;
                        Promoted = true;
                        PromotedCategory = "Report";
                        RunObject = Page "HR Job Interview";
                        Visible = false;
                        ToolTip = 'Executes the Hiring Details action.';
                    }
                    action(EmployeeDisciplinaryCases)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Employee Disciplinary Cases';
                        Image = Components;
                        Promoted = true;
                        PromotedCategory = Category6;
                        RunObject = Page "HR Disciplinary Cases List";
                        RunPageLink = "Accused Employee" = field("No.");
                        ToolTip = 'Executes the Employee Disciplinary Cases action.';
                    }
                }
            }
        }
    }

    var
        HREmp: Record "HR-Employee";
        HRValueChange: Record "HR Change Entries";

    procedure "Filter Employees"(Type: Option Active,Archive,All)
    begin
        if Type = Type::Active then begin
            Rec.Reset;
            Rec.SetFilter("Termination Category", '=%1', Rec."termination category"::" ");
        end
        else
            if Type = Type::Archive then begin
                Rec.Reset;
                Rec.SetFilter("Termination Category", '<>%1', Rec."termination category"::" ");
            end
            else
                if Type = Type::All then
                    Rec.Reset;

        CurrPage.Update(false);
        Rec.FilterGroup(20);
    end;

    local procedure ActivegOptActiveOnPush()
    begin
        "Filter Employees"(0); //Active Employees
    end;

    local procedure ArchivegOptActiveOnPush()
    begin
        "Filter Employees"(1); //Archived Employees
    end;

    local procedure AllgOptActiveOnPush()
    begin
        "Filter Employees"(2); //  Show All Employees
    end;

    local procedure ActivegOptActiveOnValidate()
    begin
        ActivegOptActiveOnPush;
    end;

    local procedure ArchivegOptActiveOnValidate()
    begin
        ArchivegOptActiveOnPush;
    end;

    local procedure AllgOptActiveOnValidate()
    begin
        AllgOptActiveOnPush;
    end;
}

