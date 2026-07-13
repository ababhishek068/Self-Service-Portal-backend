Page 50243 Employee
{
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Print,Functions,Employee,Attachments';
    SourceTable = "HR-Employee";
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(GeneralDetails)
            {
                Caption = 'General Details';
                field(No; Rec."No.")
                {
                    caption = 'Staff No.';
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }

                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = false;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(FYDA; FYDA) { }
                field("Employees Type"; Rec."Employees Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Employees Type field.';
                }

                field(PassportNumber; Rec."Passport Number")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Passport Number field.';
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Citizenship field.';
                }
                field(EthnicOrigin; Rec."Ethnic Origin")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ethnic Origin field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                    end;
                }


                // field(GlobalDimension3Code; Rec."Global Dimension 3 Code")
                // {
                //     ApplicationArea = Basic;
                //     ShowMandatory = true;
                //     ToolTip = 'Specifies the value of the Global Dimension 3 Code field.';
                // }

                field(Sector; Sector)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    visible = false;
                }
                field("Sector Name"; "Sector Name")
                {
                    editable = false;
                    visible = false;
                }
                //field("Business Unit";"Business Unit"){}
                field("District Name"; "District Name")
                {
                    editable = false;
                    visible = false;
                }

                field("<GlobSal Dimension 1 Code>"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Division';
                    visible = true;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Global Dimension 3 Code field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                    end;
                }
                field("Branch- Name"; "Branch- Name")
                {
                    Editable = false;
                    Visible = false;
                }



                field(Division; Division)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    visible = false;
                    Caption = 'Division';

                }
                field("Division Name"; "Division Name")
                {
                    Editable = false;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Caption = 'Department';
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';

                }
                field("Department Name"; "Department Name")
                {
                    editable = false;
                }
                field("Branch Grade"; "Branch Grade")
                {
                    ApplicationArea = basic;
                    visible = false;

                }
                field("Business Unit";"Business Unit"){}
                field("Clearance Form?"; "Clearance Form?")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Hiring Guarantee?"; "Hiring Guarantee?") { }
                field("Hiring Guarantor"; "Hiring Guarantor") { }
                field("Guarantor Phone No"; "Guarantor Phone No") { }
                field("Guarantor E-mail"; "Guarantor E-mail") { }
                field("Guarantor Work Place"; "Guarantor Work Place") { }

                field("Cost Share?"; "Cost Share?") { }
                field("Cost Share Start Date"; "Cost Share Start Date") { }
                field("Cost Share Outstanding Balance"; "Cost Share Outstanding Balance") { }
                field("CostShare Contributions"; "CostShare Contributions") { }
                field("CostShare Balance"; "CostShare Balance") { }
                field("Procurement Officer"; "Procurement Officer") { }
                field("Loan Guarantee?"; "Loan Guarantee?")
                {
                    ApplicationArea = Basic;
                    //ShowMandatory = true;
                    Editable = false;
                }
                field("Customer No"; Rec."Customer No")
                {
                    ToolTip = 'Specifies the value of the Customer No field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                    Editable = false;
                }

                field("Guarantee Start Date"; "Guarantee Start Date") { }
                field("Guarantee Outstanding Balance"; "Guarantee Outstanding Balance") { }
                field("Guarantee Contributions"; "Guarantee Contributions") { }
                field("Guarantee Balance"; "Guarantee Balance") { }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }

                field("Is HOD"; Rec."Is HOD")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Is HOD field.';
                }

                field(Tribe; Rec.Tribe)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tribe field.';
                    Visible = false;
                }
                field("Sub Tribe"; Rec."Sub Tribe")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sub Tribe field.';
                    Visible = false;
                }

                field(EmployeeUserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee User ID';
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Employee User ID field.';

                    trigger OnValidate()
                    begin

                    end;
                }
                field(SupervisorUserID; Rec."Supervisor User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor User ID field.';

                    trigger OnValidate()
                    begin
                        GetSupervisor(Rec."User ID");
                    end;
                }
                field("Supervisor No."; Rec."Supervisor No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Supervisor No. field.';
                }
                field(HODUserID; Rec."HOD User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HOD User ID field.';

                    trigger OnValidate()
                    begin
                        GetSupervisorID(Rec."User ID");
                    end;
                }

                field("Leave Period Filter"; Rec."Leave Period Filter")
                {
                    ToolTip = 'Specifies the value of the Leave Period Filter field.';
                }

                field("Leave Balance"; Rec."Leave Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Leave Balance field.';
                }
                field("No of Worked Days"; "No of Worked Days") { }
                field("Earned Leave Days"; "Earned Leave Days") { }
                field("Leave in Birr"; "Leave in Birr") { }
                field("Annual Leave Code"; "Annual Leave Code")
                {
                    Editable = false;
                }
                field("Annual Leave balance"; Rec."Annual Leave balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Annual Leave balance field.';
                }
                field("Carry forward"; Rec."Carry forward")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Carry forward field.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field(LastDateModifiedBy; Rec."Last Date Modified By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Date Modified By field.';
                }
                //field("Employee-Type";"Employee-Type"){}
                field(EmployeeType; Rec."Employee Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Type field.';
                }

                field("Secondment Type"; Rec."Secondment Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Secondment Type field.';
                }

                field("Seconded Duration"; Rec."Seconded Duration")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seconded Duration field.';
                }
                field("Seconded Start Date"; Rec."Seconded Start Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seconded Start Date field.';
                }

                field("Seconded End Date"; Rec."Seconded End Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Seconded End Date field.';
                }
                field("Secondment Institution"; Rec."Secondment Institution")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Secondment Institution field.';
                }


                field("Employement Type"; Rec."Employement Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Employement Type field.';
                }

                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Type field.';

                }


                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the value of the Status field.';

                    trigger OnValidate()
                    begin

                    end;
                }
                field("On Probation"; Rec."On Probation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Probation field.';
                    Editable = false;
                }
                field("Joined Social Club?"; "Joined Social Club?") { }
                field("Left social Club?"; "Left social Club?") { }
                field("On Suspension"; Rec."On Suspension")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Suspension field.';
                }
                field("On Interdiction"; Rec."On Interdiction")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Interdiction field.';
                }
                field(WorkStation; Rec."Work Station")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Work Station field.';
                }
                field("Works in Desert"; "Works in Desert")
                {
                    Caption = 'Works in Hard/Desert Regions?';
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Region field.';
                }
                field(RegionName; Rec."Region Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Region Name field.';
                }
            }
            group(PersonalDetails)
            {
                Caption = 'Personal Details';
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(MaritalStatus; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field(Religion; Rec.Religion)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Religion field.';
                }


                field(VehicleRegistrationNumber; Rec."Vehicle Registration Number")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Vehicle Registration Number field.';
                }

                field(NumberOfDependants; Rec."Number Of Dependants")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Number Of Dependants field.';
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = Basic;
                    Caption = 'Physically Challanged';
                    ToolTip = 'Specifies the value of the Physically Challanged field.';
                }

                field(TypeOfDisability; Rec."Type Of Disability")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type Of Disability field.';
                }


                field("Disabling Details"; Rec."Disabling Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disabling Details field.';
                }

                field("PWD No"; Rec."PWD No")
                {
                    ApplicationArea = Basic;
                    Caption = 'NCPWD No.';
                    ToolTip = 'Specifies the value of the NCPWD No. field.';
                }

                field("PWD Start Date"; Rec."PWD Start Date")
                {
                    ApplicationArea = all;
                    Caption = 'NCPWD Start Date.';
                    ToolTip = 'Specifies the value of the NCPWD Start Date. field.';
                }

                field("PWD Duration"; Rec."PWD Duration")
                {
                    ApplicationArea = all;
                    Caption = 'NCPWD Duration.';
                    ToolTip = 'Specifies the value of the NCPWD Duration. field.';
                }

                field("PWD Notification Date"; Rec."PWD Notification Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PWD Notification Date field.';
                }

                field("PWD Expiry Date"; Rec."PWD Expiry Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PWD Expiry Date field.';
                }


            }
            group(CommunicationDetails)
            {
                Caption = 'Communication Details';
                field(HomePhoneNumber; Rec."Home Phone Number")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = PhoneNo;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Home Phone Number field.';
                }
                field(CellPhoneNumber; Rec."Cell Phone Number")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = PhoneNo;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Cell Phone Number field.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(CompanyEMail; Rec."Company E-Mail")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = EMail;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Company E-Mail field.';
                }
                field("Emergency Contact Name"; "Emergency Contact Name")
                {
                    ShowMandatory = true;
                }
                field("Emergency Contact Phone No"; "Emergency Contact Phone No")
                {
                    ShowMandatory = true;
                }
                field("Emergency Contact Email"; "Emergency Contact Email") { }

                field(PostalAddress; Rec."Postal Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }

                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the City field.';
                }

            }
            group(ImportantDates)
            {
                Caption = 'Important Dates';
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                        if Rec."Date Of Birth" >= Today then begin
                            Error('Invalid Entry');
                        end;
                        DAge := Dates.DetermineAge(Rec."Date Of Birth", Today);
                    end;
                }
                field(DAge; DAge)
                {
                    ApplicationArea = Basic;
                    Caption = 'Age';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Age field.';
                }
                field(DateOfJoiningtheCompany; Rec."Date Of Joining the Company")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Caption = 'Date Of Joining the Organization';
                    Visible = true;
                    ToolTip = 'Specifies the value of the Date Of Joining the Organization field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                        DService := Dates.DetermineAge(Rec."Date Of Joining the Company", Today);
                    end;
                }

                field("Date of First Appointment"; Rec."Date of First Appointment")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Visible = true;
                    Caption = 'Current Appointment Date';
                    ToolTip = 'Specifies the value of the Current Appointment Date field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                        DService := Dates.DetermineAge(Rec."Date Of Joining the Company", Today);
                    end;
                }




                field(DService; DService)
                {
                    ApplicationArea = Basic;
                    Caption = 'Length of Service';
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Length of Service field.';
                }
                field(EndOfProbationDate; Rec."End Of Probation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Of Probation Date field.';
                }
                field("Temporary job Expiry Date"; "Temporary job Expiry Date") { }
                field("Acting job Start Date"; "Acting job Start Date") { }
                field("Acting job Expiry Date"; "Acting job Expiry Date") { }
                field("Acting Position?"; "Acting Position?") { }
                field("Acting Position Months"; "Acting Position Months")
                {
                    //Caption='Days in Acting Position';
                }
                field("No of acting Days"; "No of acting Days")
                {
                    Editable = false;
                }
                field("Acting Arrears Days"; "Acting Arrears Days")
                {
                    Editable = false;
                }
                field("Arrears Days"; "Arrears Days")
                {
                    Editable = false;
                }
                // field(Transfered;Transfered){}
                // field(Promoted;Promoted){}
                // field(Demoted;Demoted){}
                // field("Demotion/Transfer/Promotion Date";"Demotion/Transfer/Promotion Date"){}
                //field("Reason for tran/demo/pro";"Reason for tran/demo/pro"){}
                field(Retirementdate; Rec."Retirement date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Retirement date field.';
                }
                field(NotificationDate; Rec."Notification Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notification Date field.';
                }

                field("Days to Probation Date"; Rec."Days to Probation Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Days to Probation Date field.';
                }
                field("Date of Joining Social Club"; "Date of Joining Social Club") { }
                field("Paid social Club"; "Paid social Club") { }

                field(PensionSchemeJoinDate; Rec."Pension Scheme Join Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Scheme Join Date field.';

                    trigger OnValidate()
                    begin
                        //CORETEC PROTECTED
                        DPension := Dates.DetermineAge(Rec."Pension Scheme Join Date", Today);
                    end;
                }
                field(Dretire; Dretire)
                {
                    ApplicationArea = Basic;
                    Caption = 'Days to Retire';
                    ToolTip = 'Specifies the value of the Days to Retire field.';
                }
                field(DPension; DPension)
                {
                    ApplicationArea = Basic;
                    Caption = 'Days to Retirement';
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Days to Retirement field.';
                }


                field("Medical Scheme Member No."; Rec."Medical Scheme Member No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Medical Scheme Member No. field.';
                }

                field(MedicalSchemeJoinDate; Rec."Medical Scheme Join Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Medical Scheme Join Date field.';

                    trigger OnValidate()
                    begin
                        DMedical := Dates.DetermineAge(Rec."Medical Scheme Join Date", Today);
                    end;
                }
                field(DMedical; DMedical)
                {
                    ToolTip = 'Specifies the value of the DMedical field.';

                }


                // field(WeddingAnniversary; "Wedding Anniversary")
                // {
                //     ApplicationArea = Basic;
                // }
            }
            group(JobDetails)
            {
                Caption = 'Job Details';
                field(JobID; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field("Temporary Job ID"; "Temporary Job ID") { }
                field("Temporary Job"; "Temporary Job") { }
                field("Acting Job ID"; "Acting Job ID") { }
                field("Acting job"; "Acting job") { }
                field("Acting Job Grade"; "Acting Job Grade") { }
                field("Payroll Posting Group"; Rec."Payroll Posting Group")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Payroll Posting Group field.';
                }
                field("Allow Overtime"; Rec."Allow Overtime")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Allow Overtime field.';
                }

                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Group field.';
                }


                field("Current Job ID"; Rec."Current Job ID")
                {
                    ApplicationArea = all;
                    caption = 'Acting Job ID';
                    ToolTip = 'Specifies the value of the Acting Job ID field.';
                }

                field("Current Job Title"; Rec."Current Job Title")
                {
                    caption = 'Acting Job Title';
                    ToolTip = 'Specifies the value of the Acting Job Title field.';
                }

                field("Reason for Change of Designation"; Rec."Reason for Changing Designation")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reason for Change of Designation field.';
                }


            }
            group(TermsofService)
            {
                Caption = 'Terms of Service';

                field("Contract Duration"; Rec."Contract Duration")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Duration field.';

                }

                field(ContractEndDate; Rec."Contract End Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Contract End Date field.';
                }
                field(NoticePeriod; Rec."Notice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notice Period field.';
                }
                field(SendAlertto; Rec."Send Alert to")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Send Alert to field.';
                }
                field(IsPaidDaily; Rec."Is Paid Daily?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Is Paid Daily? field.';
                }
            }
            group(PaymentInformation)
            {
                Caption = 'Payment Information';
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(PensionNo; Rec."Pension No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Pension No. field.';
                }
                field(NHIFNo; Rec."NHIF No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    Visible = false;
                    ToolTip = 'Specifies the value of the NHIF No. field.';
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Payment Mode field.';
                }

                field("Main Bank"; Rec."Main Bank")
                {
                    ApplicationArea = all;
                    Caption = 'Bank Code';
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }


                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }

                field("Branch Bank"; Rec."Branch Bank")
                {
                    ApplicationArea = all;
                    Caption = 'Branch Code';
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }

                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }

                // field("Bank and Branch Code"; "Bank and Branch Code")
                // {
                //     ApplicationArea = all;
                // }

                field("Bank Account Number"; Rec."Bank Account Number")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bank Account Number field.';
                }
                field("Manual Salary Negotiation";"Manual Salary Negotiation"){}
                field("Job Group"; "Job Group") { }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                
                field("Works in-out Office"; "Works in-out Office") { }
                field("Allocate Transport Allowance?"; "Allocate Transport Allowance?") { }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                }
                field(Pointer; Rec.Pointer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pointer field.';

                }
                field("Salary Incremental Month"; Rec."Salary Incremental Month")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Salary Incremental Month field.';
                }

                field("Pay Mode Committed"; Rec."Pay Mode Committed")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Pay Mode Committed field.';
                }
                group(Allowance)
                {
                    caption = 'Salary Allowance';
                    part(Slary; "PR Employee Allowance Part")
                    {
                        caption = 'Employee Salary Allowance';
                        SubPageLink = "Employee Code" = field("No.");
                        Editable = false;
                    }
                }
            }

            group(
            SeparationDetails)
            {
                Caption = 'Separation Details';
                field(DateOfLeavingtheCompany; Rec."Date Of Leaving the Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Leaving the Company field.';
                }
                field(TerminationGrounds; Rec."Termination Grounds")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Termination Grounds field.';
                }
                field("Resignation Date"; "Resignation Date") { }
                field(ExitInterviewDate; Rec."Exit Interview Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Exit Interview Date field.';
                }
                field(ExitInterviewDoneby; Rec."Exit Interview Done by")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Exit Interview Done by field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control3; "HR-Employee Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No." = FIELD("No.");
            }

            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50746),
                              "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Employee)
            {
                Caption = '&Employee';
                action(AssetIssue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Asset Issue';
                    Image = ExternalDocument;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Fixed Asset List";
                    RunPageLink = "Assigned Employee" = field("No.");
                    ToolTip = 'Executes the Asset Issue action.';
                }

                action(NextofKn)
                {
                    ApplicationArea = Basic;
                    Caption = 'Next of Kin & Beneficiaries';
                    Image = Relatives;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Next of Kin & Beneficiaries action.';
                    // RunObject = Page Kin
                    //RunPageView = where(Type = filter("Next of Kin"));
                    // RunPageLink = "Employee Code" = field("No.");

                }

                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Employee Qualifications 2";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Executes the Qualifications action.';
                }
                // action(NuclearFamily)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Nuclear Family';
                //     Image = Opportunity;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     RunObject = Page "HR Employee Beneficiaries";
                //     RunPageLink = "No." = field("No.");
                //     // RunPageView = where(Type=filter(Beneficiary));
                // }               

                action("Next of Kin")
                {
                    Caption = 'Next of Kin';
                    Image = Relatives;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Employee Beneficiary";
                    RunPageLink = "Employee Code" = FIELD("No.");
                    RunPageView = WHERE(Type = FILTER("Next of Kin"));
                    ToolTip = 'Executes the Next of Kin action.';
                }
                action(Beneficiaries)
                {
                    Caption = 'Beneficiaries';
                    Image = Opportunity;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Employee Beneficiary";
                    RunPageLink = "Employee Code" = FIELD("No.");
                    RunPageView = WHERE(Type = FILTER("Beneficiary"));
                    ToolTip = 'Executes the Beneficiaries action.';
                }
                action(Dependants)
                {
                    Caption = 'Dependants';
                    Image = Relatives;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Employees Dependants";
                    RunPageLink = "Employee Code" = FIELD("No.");
                    RunPageView = WHERE(Type = FILTER("Dependant"));
                    ToolTip = 'Executes the Dependants action.';
                }




                action("External Employment History")
                {
                    Caption = 'External Employment History';
                    Image = History;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "Employment History";
                    RunPageLink = "No." = FIELD("No.");
                    ToolTip = 'Executes the Employment History action.';
                }
                action(" Internal Employment History")
                {
                    Caption = 'Internal Employment History';
                    Image = History;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "Internal Employee History";
                    RunPageLink = "No." = FIELD("No.");
                    ToolTip = 'Executes the Employment History action.';
                }
                action("Appointment Checklist")
                {
                    Caption = 'Appointment Checklist';
                    Image = AddAction;
                    Promoted = true;
                    ApplicationArea = Basic;

                    PromotedCategory = Process;
                    RunObject = Page "HR Appointment Checklist";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ToolTip = 'Executes the Appointment Checklist action.';
                }
                action("Proffessional Membership")
                {
                    Caption = 'Proffessional Membership';
                    Image = Group;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "Hr Proffessional Membership";
                    RunPageLink = "Employee Code" = FIELD("No.");
                    ToolTip = 'Executes the Proffessional Membership action.';
                }
                action("Training History")
                {
                    Caption = 'Training History';
                    Image = Certificate;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HR training History";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ToolTip = 'Executes the Training History action.';
                }
                action("EmployeeRewards")
                {
                    Caption = 'Employee Rewards';
                    Image = Certificate;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HR Employee Rewards";
                    RunPageLink = "Employee No" = FIELD("No.");
                    ToolTip = 'Executes the Employee Rewards action.';
                }
                action("Employee Responsibilities")
                {
                    Caption = 'Employee Responsibilities';
                    Enabled = false;
                    Image = ResourcePlanning;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    PromotedIsBig = false;
                    RunObject = Page "HR Job Responsiblities (RO)";
                    RunPageLink = "Responsibility Description" = FIELD("Job Title");
                    Visible = false;
                    ToolTip = 'Executes the Employee Responsibilities action.';
                }

                action("Assign Clearance Items")
                {
                    Caption = 'Assigned Assets';
                    Image = ExternalDocument;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "Fixed Asset List";
                    RunPageLink = "Responsible Employee" = FIELD("No.");
                    ToolTip = 'Executes the Assigned Assets action.';
                }
                action(ViewPayslip)
                {
                    ApplicationArea = Basic;
                    Caption = 'View Payslip';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the View Payslip action.';

                    trigger OnAction()
                    var
                        PRSalARYCard: record "PR Salary Card";
                        PRPeriod: record "PR Payroll Periods";
                        SelectedPeriod: Date;
                    begin
                        PRPeriod.Reset;
                        PRPeriod.SetRange(PRPeriod.Closed, false);
                        if PRPeriod.FindFirst() then begin
                            SelectedPeriod := PRPeriod."Date Opened";
                        end else begin
                            Error('No Payroll period found');
                        end;

                        PRSalARYCard.SetRange("Employee Code", Rec."No.");
                        PRSalARYCard.SetRange(PRSalARYCard."Period Filter", SelectedPeriod);

                        Report.Run(Report::"Individual Payslips mst", true, false, PRSalARYCard);
                        //Report.Run(Report::"PR Individual Payslip", true, false, PRSalARYCard);//felix
                    end;
                }
                action(advanceimprest)
                {
                    Caption = 'Activate Advance and Imprest';
                    Image = AccountingPeriods;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        userset: Record "User Setup";
                        cust: Record Customer;
                        cust2: Record Customer;
                        Customer: Record Customer;
                        NoSeriesMgt: Codeunit "No. Series";
                        SalesSetup: Record "Sales & Receivables Setup";

                    begin
                        TestField(rec."User ID");
                        userset.Reset();
                        userset.SetRange(userset."User ID", Rec."User ID");
                        if userset.FindFirst() then begin

                            if (userset."Other Advance Staff Account" = '') or (userset."Imprest Account" = '') or (userset."Employee No." = '') then begin
                                cust.Reset();
                                cust.SetRange(cust."Staff No.", rec."No.");
                                if cust.FindFirst() then begin
                                    userset."Other Advance Staff Account" := cust."No.";
                                    userset.Validate("Other Advance Staff Account");
                                    userset."Imprest Account" := cust."No.";
                                    userset.Validate("Imprest Account");
                                    userset."Employee No." := rec."No.";
                                    userset.Modify();

                                end else if not cust.Find() then begin
                                    SalesSetup.Get();
                                    SalesSetup.TestField("Customer Nos.");
                                    //"No." := NoSeries.GetNextNo("No. Series");

                                    cust.Init;
                                    cust."No." := NoSeriesMgt.GetNextNo(SalesSetup."Customer Nos.", today, true);
                                    cust.Validate("No.");
                                    cust."Customer Type" := cust."Customer Type"::Customer;
                                    cust.Name := Rec."First Name" + '' + rec."Middle Name" + '' + rec."Last Name";
                                    cust."Customer Posting Group" := 'IMPREST';
                                    cust."Gen. Bus. Posting Group" := 'LOCAL';
                                    cust."Staff No." := rec."No.";
                                    cust."Account Type" := cust."Account Type"::"Staff Advance";
                                    cust.Insert;
                                    Message('Successfully added');
                                    Sleep(20);
                                    cust2.Reset();
                                    cust2.SetRange(cust2."Staff No.", rec."No.");
                                    if cust2.FindFirst() then begin
                                        userset."Other Advance Staff Account" := cust."No.";
                                        userset.Validate("Other Advance Staff Account");
                                        userset."Imprest Account" := cust2."No.";
                                        userset.Validate("Imprest Account");
                                        userset."Employee No." := rec."No.";
                                        userset.Modify();
                                    end;


                                end;
                            end;

                        end else begin

                        end;

                    end;
                }

                action("View Clearance Details")
                {
                    Caption = 'View Clearance Details';
                    Image = ExternalDocument;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Asset Return Form";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ToolTip = 'Executes the View Clearance Details action.';
                }

                action("&Confidential Information")
                {
                    Caption = '&Confidential Information';
                    Image = SNInfo;

                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;

                    RunObject = Page "HR Confidential Comment List2";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ToolTip = 'Executes the &Confidential Information action.';
                }

                action("A&bsences")
                {
                    Caption = 'A&bsences';
                    Image = AbsenceCalendar;
                    Promoted = true;
                    ApplicationArea = Basic;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    PromotedCategory = Process;
                    RunObject = Page "HR Absence Registration";
                    RunPageLink = "Employee No." = FIELD("No.");
                    ToolTip = 'Executes the A&bsences action.';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = false;
                    ApplicationArea = Basic;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category6;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(5200),
                                      "No." = FIELD("No.");
                    ToolTip = 'Executes the Dimensions action.';
                }

                action("Hiring Details")
                {
                    Caption = 'Hiring Details';
                    Image = Answers;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Job Interview";
                    Visible = false;
                    ToolTip = 'Executes the Hiring Details action.';
                }
                action("Employee Disciplinary Cases")
                {
                    Caption = 'Employee Disciplinary Cases';
                    Image = Components;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Process;
                    RunObject = Page "HR Disciplinary Cases List";
                    RunPageLink = "Accused Employee" = FIELD("No.");
                    ToolTip = 'Executes the Employee Disciplinary Cases action.';
                }

                action("Employee Vehicles")
                {
                    ApplicationArea = Basic;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HR Employee Vehicles";
                    RunPageLink = "Employee No" = FIELD("No.");
                    ToolTip = 'Executes the Employee Vehicles action.';
                }
                action(PrintRetNotice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Retirement Notice';
                    Ellipsis = true;
                    Image = Print;
                    ToolTip = 'Executes the Print Retirement Notice action.';
                    trigger OnAction()
                    var
                        HRDispcase: Record "HR-Employee";
                        DispCases: Report "HR Riterement Notice Letter";
                    begin
                        HRDispcase.Reset();
                        HRDispcase.setfilter("No.", Rec."No.");
                        if HRDispcase.Find('-') then begin
                            DispCases.SetTableView(HRDispcase);
                            DispCases.Run();
                        end;
                    end;
                }

            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    ToolTip = 'Executes the Approve action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    ToolTip = 'Executes the Reject action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    ToolTip = 'Executes the Delegate action.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //CORETEC PROTECTED
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    begin
                        //CORETEC PROTECTED
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    begin
                        //CORETEC PROTECTED
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //CORETEC PROTECTED***kumali
        DAge := '';
        DService := '';
        DPension := '';
        DMedical := '';



        //Recalculate Important Dates
        if (Rec."Date Of Leaving the Company" = 0D) then begin
            if (Rec."Date Of Birth" <> 0D) then
                DAge := Dates.DetermineAge(Rec."Date Of Birth", Today);
            if (Rec."Date Of Joining the Company" <> 0D) then
                DService := Dates.DetermineAge(Rec."Date Of Joining the Company", Today);
            if (Rec."Pension Scheme Join Date" <> 0D) then
                DPension := Dates.DetermineAge(Rec."Pension Scheme Join Date", Today);
            if (Rec."Medical Scheme Join Date" <> 0D) then
                DMedical := Dates.DetermineAge(Rec."Medical Scheme Join Date", Today);
            //MODIFY;
        end else begin
            if (Rec."Date Of Birth" <> 0D) then
                DAge := Dates.DetermineAge(Rec."Date Of Birth", Rec."Date Of Leaving the Company");
            if (Rec."Date Of Joining the Company" <> 0D) then
                DService := Dates.DetermineAge(Rec."Date Of Joining the Company", Rec."Date Of Leaving the Company");
            if (Rec."Pension Scheme Join Date" <> 0D) then
                DPension := Dates.DetermineAge(Rec."Pension Scheme Join Date", Rec."Date Of Leaving the Company");
            if (Rec."Medical Scheme Join Date" <> 0D) then
                DMedical := Dates.DetermineAge(Rec."Medical Scheme Join Date", Rec."Date Of Leaving the Company");
            //MODIFY;
        end;
        if rec."Resignation Date" <> 0D then begin
            if rec."Resignation Date" < today then begin
                rec.status := rec.status::InActive;
            end;

        end;
        if rec."Date Of Leaving the Company" <> 0D then begin
            if rec."Date Of Leaving the Company" < today then begin
                rec.status := rec.status::InActive;
            end;

        end;
        if rec."Acting job Expiry Date" <> 0D then
            rec.Validate("Acting job Expiry Date");

        //Recalculate Leave Days
        //Validate("Annual Leave balance");

        SupervisorNames := GetSupervisor(Rec."User ID");
        //****
    end;




    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //CORETEC PROTECTED
    end;

    // trigger OnAfterGetCurrRecord()
    // var
    // leavetypes: Record "Leave Types";
    // begin
    //  leavetypes.Reset();
    //  leavetypes.SetRange(leavetypes.Annual,true);
    //  if leavetypes.FindFirst() then begin
    //     "Annual Leave Code":=leavetypes.Code;
    //     Validate("Annual Leave Code");
    //  end;
    // end;

    trigger OnModifyRecord(): Boolean
    var
    // HRPRAccess: Record "Imported Receipts Buffer";
    begin
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF Rec."No." = '' THEN BEGIN
            selection := STRMENU(Text100, 1);
            HRSetup.GET();
            case selection of
                0:
                    EXIT;
                1:
                    begin
                        HRSetup.TestField("Employee Nos.");
                        // NoSeriesMgt.GetNextNo(HRSetup."Employee Nos.", xRec."No Series", 0D, "No.", "No Series");
                        Rec."No." := NoSeriesMgt.GetNextNo(HRSetup."Employee Nos.", 0D, true);
                        Rec."Employee Types" := Rec."Employee Types"::Employee;
                    end;
                2:
                    begin
                        HRSetup.TestField("Casual No.");
                        //  NoSeriesMgt.GetNextNo(HRSetup."Casual No.", xRec."No Series", 0D, "No.", "No Series");
                        Rec."No." := NoSeriesMgt.GetNextNo(HRSetup."Casual No.", 0D, true);
                        Rec."Employee Types" := Rec."Employee Types"::Casual;
                        Rec."Employee Contract Type" := Rec."Employee Contract Type"::Casual;
                    end;
                3:
                    begin
                        HRSetup.TestField("Interns Nos.");
                        // NoSeriesMgt.GetNextNo(HRSetup."Interns Nos.", xRec."No Series", 0D, "No.", "No Series");
                        Rec."No." := NoSeriesMgt.GetNextNo(HRSetup."Interns Nos.", 0D, true);
                        Rec."Employee Types" := Rec."Employee Types"::Intern;
                        Rec."Employee Contract Type" := Rec."Employee Contract Type"::Intern;
                    end;
                4:
                    begin
                        HRSetup.TestField("Attachees Nos");
                        Rec."No." := NoSeriesMgt.GetNextNo(HRSetup."Attachees Nos", 0D, true);
                        // NoSeriesMgt.GetNextNo(HRSetup."Attachees Nos", xRec."No Series", 0D, "No.", "No Series");
                        Rec."Employee Types" := Rec."Employee Types"::Attachee;
                    end;
                else
                    exit;
            end;


        END;
    end;

    var
        selection: Option Employee,Casual,Intern,Attachee;
        Text100: Label ' &Employee,&Casual,&Intern,&Attachee';
        NoSeriesMgt: Codeunit "No. Series";

    var
        HRSetup: Record "HR Setup";
        DAge: Text[100];
        DService: Text[100];
        DPension: Text[100];
        DMedical: Text[100];
        HREmp: Record "HR-Employee";
        SupervisorNames: Text[60];
        Dretire: Text[100];
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        StyleTxt: Text;
        Dates: Codeunit "HR Dates";

    procedure GetSupervisor(var sUserID: Code[50]) SupervisorName: Text[200]
    var
        UserSetup: Record "User Setup";
    begin
        //CORETEC PROTECTED** kumali
        if sUserID <> '' then begin
            UserSetup.Reset;
            if UserSetup.Get(sUserID) then begin

                SupervisorName := UserSetup."Approver ID";
                if SupervisorName <> '' then begin

                    HREmp.SetRange(HREmp."User ID", SupervisorName);
                    if HREmp.Find('-') then
                        SupervisorName := HREmp."Full Name";

                end else begin
                    SupervisorName := '';
                end;


            end else begin
                //ERROR('User'+' '+ sUserID +' '+ 'does not exist in the user setup table');
                SupervisorName := '';
            end;
        end;
    end;

    procedure GetSupervisorID(var EmpUserID: Code[50]) SID: Text[200]
    var
        UserSetup: Record "User Setup";
        SupervisorID: Code[20];
    begin
        //CORETEC PROTECTED **kumali
        if EmpUserID <> '' then begin
            SupervisorID := '';

            UserSetup.Reset;
            if UserSetup.Get(EmpUserID) then begin
                SupervisorID := UserSetup."Approver ID";
                if SupervisorID <> '' then begin
                    SID := SupervisorID;
                end else begin
                    SID := '';
                end;
            end else begin
                Error('User' + ' ' + EmpUserID + ' ' + 'does not exist in the user setup table');
            end;
        end;
    end;
}

