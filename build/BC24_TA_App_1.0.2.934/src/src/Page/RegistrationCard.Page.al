page 50281 "Registration Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Registration Form";

    layout
    {
        area(Content)
        {
            group(Basic)
            {
                caption = 'Basic Information';
                field("Serial No"; Rec."Serial No")
                {
                    Caption = 'Serial Number';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial Number field.';

                }
                field("Full Names"; Rec."Full Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Names field.';

                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';

                }


                field(Region; Rec.Region)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Region field.';

                }
                field("Sub Region"; Rec."Sub Region")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sub Region field.';

                }
                field(Tribe; Rec.Tribe)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tribe field.';

                }
                field("Date of Enlistment"; Rec."Date of Enlistment")
                {
                    Caption = 'Date of Enlistment';
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Date of Enlistment field.';
                }

                field("Mean Grade"; Rec."Mean Grade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mean Grade field.';

                }
                field("Letter No"; Rec."Letter No")
                {
                    caption = 'Calling Letter No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calling Letter No. field.';

                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Number field.';

                }
                field(Cohort; Rec.Cohort)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cohort field.';

                }
                field("Huduma Number"; Rec."Huduma Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Huduma Number field.';

                }
                field("Is Disable"; Rec."Is Disable")
                {
                    Caption = 'Is Disable(PWD)';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Is Disable(PWD) field.';

                }
                field("Type of Disability"; Rec."Type of Disability")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Disability field.';

                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                    trigger OnValidate()
                    var
                        RAge: Integer;
                    begin
                        Age := Dates.DetermineAge(Rec."Date Of Birth", TODAY);
                        IF EVALUATE(RAge, Age) THEN begin
                            if ((RAge < 18) or (RAge > 24)) then
                                Error('Invalid Date of Birth');
                        end;
                    end;

                }

                field(Age; Age)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Age field.';

                }
                field("Boot Size"; Rec."Boot Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Boot Size field.';
                }
                field("Reporting Institution"; Rec."Reporting Institution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting Institution field.';
                }
                field("Training College"; Rec."Training College")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Training College field.';
                }
                field("Recruitment Center"; Rec."Recruitment Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recruitment Center field.';

                }
                field("Paramilitary Academy"; Rec."Paramilitary Academy")
                {
                    caption = 'Paramilitary Academy';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paramilitary Academy field.';

                }
                field(NBU; Rec.NBU)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NBU field.';

                }
                field("Date of Exit"; Rec."Date of Exit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Exit field.';

                }
                field("Completion Year"; Rec."Completion Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Completion Year field.';

                }
                field("Reason for Enrollment"; Rec."Reason for Enrollment")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Reason for Enrollment field.';
                }
                field("Other Qualification"; Rec."Other Qualification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Other Qualification field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    Caption = 'Recruiting officer';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recruiting officer field.';
                }
                field("Staff No"; Rec."Staff No")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }

            }
            group(Additional)
            {
                caption = 'Additional Information';
                field("Nearest Village"; Rec."Nearest Village")
                {
                    caption = 'Actual Village';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual Village field.';

                }
                field("Location/Sublocation"; Rec."Location/Sublocation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location/Sublocation field.';

                }
                field("Chief's Name"; Rec."Chief's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chief''s Name field.';

                }
                field("Chief's Contact"; Rec."Chief's Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chief''s Contact field.';

                }
                field("Assist. Chief Name"; Rec."Assist. Chief Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assist. Chief Name field.';

                }
                field("Assist. Chief Contact"; Rec."Assist. Chief Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assist. Chief Contact field.';

                }
                field("Village Elder Name"; Rec."Village Elder Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Village Elder Name field.';

                }
                field("Village Elder Contact"; Rec."Village Elder Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Village Elder Contact field.';

                }
                field("Nearest Police Station"; Rec."Nearest Police Station")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nearest Police Station field.';

                }
                field("Nearest Town"; Rec."Nearest Town")
                {
                    caption = 'Town';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Town field.';

                }
                field("Father's Name"; Rec."Father's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Father''s Name field.';

                }
                field("Father Alive/Deceased"; Rec."Father Alive/Deceased")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Father Alive/Deceased field.';

                }
                field("Father's Contacts"; Rec."Father's Contacts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Father''s Contacts field.';

                }
                field("Mother's Name"; Rec."Mother's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mother''s Name field.';

                }
                field("Mother Alive/Deceased"; Rec."Mother Alive/Deceased")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mother Alive/Deceased field.';

                }
                field("Mother's Contact"; Rec."Mother's Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mother''s Contact field.';

                }
                field("Guardian's Name"; Rec."Gurdian's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gurdian''s Name field.';

                }
                field("Guardian's Contact"; Rec."Gurdian's Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gurdian''s Contact field.';

                }
                field("Next of Kin Name"; Rec."Next of Kin Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next of Kin Name field.';

                }
                field("Next of Kin Contact"; Rec."Next of Kin Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Next of Kin Contact field.';

                }
                field(Talent; Rec.Talent)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Talent field.';

                }
                field(Denomination; Rec.Denomination)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Denomination field.';

                }
            }

            group(Academics)
            {
                Caption = 'Academics Qualifications';
                part(AcademicsQ; "Registration Qualifications")
                {
                    SubPageLink = "Service No." = field("Service Number");
                }
            }

            group(NextofKin)
            {
                caption = 'Next of Kin';
                part("StudentKin"; "Student Kin")
                {
                    SubPageLink = "Student No" = FIELD("Serial No");
                }
            }

            group(Disciplinary)
            {
                caption = 'Disciplinary';
                part("Disciplinarydet"; "Service Disciplinary Details")
                {
                    SubPageLink = "Student No." = FIELD("Service Number");
                }
            }

        }
        area(factboxes)
        {
            part(Control149; "Applicant Picture")
            {
                Caption = 'Passport Picture';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Serial No" = FIELD("Serial No");
                // Visible = NOT IsOfficeAddin;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Confirm)
            {
                ApplicationArea = All;
                Image = Register;
                Caption = 'Mark As Confirmed';
                ToolTip = 'Executes the Mark As Confirmed action.';
                trigger OnAction();
                var
                    GenLedgerSetup: Record "NYS Service Setup";
                    NoSeriesMgt: Codeunit "No. Series";
                    Brigades: Record Brigade;
                    Baracks: Record Barracks;
                    RegForm: Record "Registration Form";
                    RegForm1: Record "Registration Form";
                    CrIntake: Record Intake;
                    BrigCapacity: Integer;
                    BarCapacity: Integer;
                    AssignBrigate: Code[20];
                    AssignBarack: Code[20];
                begin
                    if confirm('Do you really want to confirm the registration?', false) then begin
                        BrigCapacity := 0;
                        BarCapacity := 0;
                        AssignBrigate := '';
                        AssignBarack := '';
                        CrIntake.Reset();
                        CrIntake.SetRange(Current, true);
                        if CrIntake.Find('-') then begin
                            Brigades.Reset();
                            Brigades.SetRange("Paramilitary Academy", Rec."Paramilitary Academy");
                            if Brigades.Find('-') then begin
                                repeat
                                    Brigades.CalcFields(Capacity);
                                    BrigCapacity := 0;
                                    RegForm.Reset();
                                    RegForm.SetRange("Paramilitary Academy", Rec."Paramilitary Academy");
                                    RegForm.SetRange(Brigade, Brigades.Code);
                                    RegForm.SetRange(Cohort, CrIntake.Code);
                                    if RegForm.Find('-') then begin
                                        BrigCapacity := RegForm.Count();
                                    end;
                                    if BrigCapacity < Brigades.Capacity then begin
                                        AssignBrigate := Brigades.Code;
                                        break;
                                    end;
                                until Brigades.Next() = 0;
                            end;
                            if (AssignBrigate <> '') then begin
                                Baracks.Reset();
                                Baracks.SetRange(Brigate, Brigades.Code);
                                Baracks.SetRange("Paramilitary Academy", Rec."Paramilitary Academy");
                                if Baracks.Find('-') then begin
                                    repeat
                                        BarCapacity := 0;
                                        RegForm1.Reset();
                                        RegForm1.SetRange("Paramilitary Academy", Rec."Paramilitary Academy");
                                        RegForm1.SetRange(Brigade, AssignBrigate);
                                        RegForm1.SetRange(Barrack, Baracks.Code);
                                        RegForm1.SetRange(Cohort, CrIntake.Code);
                                        if RegForm1.Find('-') then begin
                                            BarCapacity := RegForm1.Count();
                                        end;
                                        if BarCapacity < Baracks.Capacity then begin
                                            AssignBarack := Baracks.Code;
                                            break;
                                        end;
                                    until Baracks.Next() = 0;
                                end;
                                if AssignBarack <> '' then begin
                                    Rec.Brigade := AssignBrigate;
                                    Rec.Barrack := AssignBarack;
                                    GenLedgerSetup.Get;
                                    GenLedgerSetup.TestField(GenLedgerSetup."Service Nos");
                                    Rec."Service Number" := NoSeriesMgt.GetNextNo(GenLedgerSetup."Service Nos", today, true);
                                    Rec.Status := Rec.Status::Confirmed;
                                    Rec."Confirmed By" := UserId;
                                    Rec."Date Confirmed" := today;
                                    Rec.modify;
                                end else
                                    Error('No Available Barracks');
                            end else
                                Error('No Available Brigade');
                        end else
                            Error('No current corhot set');
                    end;
                end;

            }
            action(Admitt)
            {
                ApplicationArea = All;
                Image = Register;
                Caption = 'Admit to TVET';
                Visible = false;
                ToolTip = 'Executes the Admit to TVET action.';
                trigger OnAction();
                var
                    Cust: record customer;
                    CourseRegistration: record "Course Registration";
                    GenSetup: Record "General Set-Up";
                begin
                    if confirm('Do you really want to admit the student?', false) then begin
                        Rec.TestField("Approved Programme");
                        GenSetup.get;
                        GenSetup.TestField("Default Semester");
                        GenSetup.TestField("Default Academic Year");
                        GenSetup.TestField("Default Intake");
                        GenSetup.TestField("Default Year");
                        if not Cust.get(Rec."Serial No") then begin
                            Cust.init;
                            Cust."No." := Rec."Serial No";
                            Cust.Name := Rec."Full Names";
                            Cust.Gender := Rec.Gender;
                            Cust."Customer Type" := Cust."Customer Type"::Student;
                            Cust."Customer Posting Group" := 'STUDENT';
                            //Cust.Region := Rec.Region;
                            Cust.Address := Rec."Nearest Town";
                            Cust."ID No" := Rec."ID Number";
                            Cust.Disabled := Rec."Is Disable";
                            Cust.Image := Rec."Applicant Photo";
                            cust."Current Programme" := Rec."Approved Programme";
                            Cust."Entry Intake" := GenSetup."Default Intake";

                            Cust.insert;

                            CourseRegistration.Reset;
                            CourseRegistration.Init;
                            CourseRegistration."Reg. Transacton ID" := '';
                            CourseRegistration.Validate(CourseRegistration."Reg. Transacton ID");
                            CourseRegistration."Student No." := Rec."Serial No";
                            CourseRegistration.Programme := Rec."Approved Programme";
                            CourseRegistration.Semester := GenSetup."Default Semester";
                            CourseRegistration.Stage := GenSetup."Default Year";
                            CourseRegistration."Student Type" := CourseRegistration."Student Type"::"Full Time";
                            CourseRegistration."Registration Date" := Today;
                            CourseRegistration."Settlement Type" := '';
                            CourseRegistration."Academic Year" := GenSetup."Default Academic Year";
                            CourseRegistration."First Time Student" := true;
                            // CourseRegistration.VALIDATE(CourseRegistration."Registration Date");
                            CourseRegistration.Insert;

                            CourseRegistration.Reset;
                            CourseRegistration.SetRange(CourseRegistration."Student No.", Rec."Serial No");
                            if CourseRegistration.Find('+') then begin
                                CourseRegistration."Registration Date" := Today;
                                CourseRegistration.Validate(CourseRegistration."Registration Date");
                                // CourseRegistration."Settlement Type" := "Settlement Type";
                                // CourseRegistration.Validate(CourseRegistration."Settlement Type");
                                // CourseRegistration."Academic Year" := GetCurrYear();
                                CourseRegistration.Modify;

                            end;
                            Rec.Status := Rec.Status::TVET;
                            Rec.Modify;
                        end;
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Age := Dates.DetermineAge(Rec."Date Of Birth", Today);
    end;

    var
        Age: Text[200];
        Dates: Codeunit "HR Dates";
}