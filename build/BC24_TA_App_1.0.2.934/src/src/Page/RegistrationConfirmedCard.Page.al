page 50178 "Registration Confirmed Card"
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Serial Number field.';
                }
                field("Service Number"; Rec."Service Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Service Number field.';

                }

                field("Full Names"; Rec."Full Names")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full Names field.';

                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID Number field.';

                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                    trigger OnValidate()
                    begin
                        Age := Dates.DetermineAge(Rec."Date Of Birth", TODAY);
                    end;

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
                field("Letter No"; Rec."Letter No")
                {
                    caption = 'Calling Letter No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calling Letter No. field.';

                }
                field("Mean Grade"; Rec."Mean Grade")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mean Grade field.';
                }
                field("Paramilitary Academy"; Rec."Paramilitary Academy")
                {
                    Caption = 'Technical training Institute';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Technical training Institute field.';
                }
                field(Brigade; Rec.Brigade)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Brigade field.';
                }
                field(Barrack; Rec.Barrack)
                {
                    ApplicationArea = All;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Barrack field.';
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


                field(Age; Age)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Age field.';

                }
                field("Recruitment Center"; Rec."Recruitment Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recruitment Center field.';

                }
                field(NBU; Rec.NBU)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NBU field.';

                }
                field("Completion Year"; Rec."Completion Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Completion Year field.';

                }
                field("Reason for Enrollment"; Rec."Reason for Enrollment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reason for Enrollment field.';

                }
                field(Rank; Rec.Rank)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rank field.';

                }
                field("User ID"; Rec."User ID")
                {
                    Editable = false;
                    Caption = 'Recruiting officer';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Recruiting officer field.';

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
                field("Gurdian's Name"; Rec."Gurdian's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gurdian''s Name field.';

                }
                field("Gurdian's Contact"; Rec."Gurdian's Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gurdian''s Contact field.';

                }
                field(Talent; Rec.Talent)
                {
                    ApplicationArea = All;
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
            group(BankDet)
            {
                caption = 'Bank Details';
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Name field.';

                }
                field("Bank Branch Name"; Rec."Bank Branch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Branch Name field.';

                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No field.';

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
            group(ProgrammeSel)
            {
                caption = 'Course Selected';
                field("First Choice Programme"; Rec."First Choice Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the First Choice Programme field.';

                }
                field("Second Choice Programme"; Rec."Second Choice Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Second Choice Programme field.';

                }
                field("Third Choice Programme"; Rec."Third Choice Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Third Choice Programme field.';

                }
                field("Approved Programme"; Rec."Approved Programme")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approved Programme field.';

                }

            }
            group(Disciplinary)
            {
                caption = 'Disciplinary';
                part("Disciplinarydet"; "Service Disciplinary Details")
                {
                    SubPageLink = "Student No." = FIELD("Serial No");
                }
            }
            group(RegStatus)
            {
                caption = 'Status';
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';

                }
                field("Current Station"; Rec."Current Station")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Current Station field.';
                }
                field("Current Main Duty"; Rec."Current Main Duty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current Main Duty field.';
                }
                field("Current Sub Duty"; Rec."Current Sub Duty")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Current Sub Duty field.';
                }
                field("Discharge Reason"; Rec."Discharge Reason")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Discharge Reason field.';

                }
                field("Date of Exit"; Rec."Date of Exit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Exit field.';

                }
                field("Exit Mode"; Rec."Exit Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exit Mode field.';

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
                Visible = false;
                Caption = 'Mark As Confirmed';
                ToolTip = 'Executes the Mark As Confirmed action.';
                trigger OnAction();

                begin
                    if confirm('Do you really want to confirm the registration?', false) then begin
                        Rec.Status := Rec.Status::Confirmed;
                        Rec."Confirmed By" := UserId;
                        Rec."Date Confirmed" := today;
                        Rec.modify;
                    end;
                end;
            }
            action(Admitt)
            {
                ApplicationArea = All;
                Image = Register;
                Caption = 'Admit to TVET';
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