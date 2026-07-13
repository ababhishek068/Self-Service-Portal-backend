page 50004 "Admission Form Header PSSP"
{
    //InsertAllowed = false;
    PageType = Document;
    SourceTable = "Admission Form Header";
    //SourceTableView = WHERE(Status = CONST(New),
    //                        "Admission Type" = CONST('PSSP'));
    caption = 'Application Form';
    ApplicationArea = All;
    layout
    {
        area(content)
        {

            group("Student Personal Details")
            {
                Caption = 'Student Personal Details';

                field("Admission No."; Rec."Admission No.")
                {
                    caption = 'Application No';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Application No field.';
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Surname field.';
                }
                field("Other Names"; Rec."Other Names")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Other Names field.';
                }
                field("Settlement Type"; Rec."Settlement Type")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Settlement Type field.';
                    trigger OnValidate()
                    begin
                        // if "Settlement Type" = 'KUCCPS' then error('The selected settlement type is invalid for this option');
                    end;
                }
                field("Academic Year"; Rec."Academic Year")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Academic Year field.';
                }
                field("Degree Admitted To"; Rec."Degree Admitted To")
                {
                    Caption = 'Prog. Code';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Prog. Code field.';
                    trigger OnValidate()
                    begin
                        GetDegreeName(Rec."Degree Admitted To", DegreeName);
                    end;
                }
                field(DegreeName; DegreeName)
                {
                    Caption = 'Prog. Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Prog. Name field.';
                }
                field("Stage Admitted To"; Rec."Stage Admitted To")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stage Admitted To field.';
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                    trigger OnValidate()
                    begin
                        GetAge(Rec."Date Of Birth", AgeText);
                    end;
                }
                field(Salutation; Rec.Salutation)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Salutation field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Semester Admitted To"; Rec."Semester Admitted To")
                {
                    ApplicationArea = all;
                    Caption = 'Semester';
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Nationality field.';

                    trigger OnValidate()
                    begin
                        GetCountry(Rec.Nationality, NationalityName);
                    end;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Marital Status field.';

                    trigger OnValidate()
                    begin
                        /*Check the mariatl status of the student*/
                        if Rec."Marital Status" = Rec."Marital Status"::Single then begin
                            /*Disable the spouse details*/
                            "Spouse NameEnable" := false;
                            "Spouse Address 1Enable" := false;
                            "Spouse Address 2Enable" := false;
                            "Spouse Address 3Enable" := false;
                        end
                        else begin
                            /*Enable the spouse details*/
                            "Spouse NameEnable" := true;
                            "Spouse Address 1Enable" := true;
                            "Spouse Address 2Enable" := true;
                            "Spouse Address 3Enable" := true;
                        end;

                    end;
                }
                field(NationalityName; NationalityName)
                {
                    ApplicationArea = all;
                    Caption = 'Nationality Name';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Nationality Name field.';
                }
                field(Religion; Rec.Religion)
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Religion field.';
                    trigger OnValidate()
                    begin
                        GetReligionName(Rec.Religion, ReligionName);
                    end;
                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Occupation field.';
                }
                field("Telephone No. 1"; Rec."Telephone No. 1")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Telephone No. 1 field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Spouse Name"; Rec."Spouse Name")
                {
                    ApplicationArea = all;
                    Enabled = "Spouse NameEnable";
                    ToolTip = 'Specifies the value of the Spouse Name field.';
                }
                field("Spouse Address 1"; Rec."Spouse Address 1")
                {
                    Enabled = "Spouse Address 1Enable";
                    ToolTip = 'Specifies the value of the Spouse Address 1 field.';
                }
                field("Spouse Address 2"; Rec."Spouse Address 2")
                {
                    Enabled = "Spouse Address 2Enable";
                    ToolTip = 'Specifies the value of the Spouse Address 2 field.';
                }
                field("Spouse Address 3"; Rec."Spouse Address 3")
                {
                    Enabled = "Spouse Address 3Enable";
                    ToolTip = 'Specifies the value of the Spouse Address 3 field.';
                }
                field(Tribe; Rec.Tribe)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Tribe field.';
                }
                field(Region; Rec.Region)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Region field.';
                }
                field(Constituency; Rec.Constituency)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Constituency field.';
                }


                field("Mean Grade"; Rec."Mean Grade")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Mean Grade field.';
                }

                field("Mother Full Name"; Rec."Mother Full Name")
                {
                    caption = 'Next of Kin';
                    ToolTip = 'Specifies the value of the Next of Kin field.';
                }
                field("Mother Contacts"; Rec."Mother Contacts")
                {
                    caption = 'Next of Kin Contacts';
                    ToolTip = 'Specifies the value of the Next of Kin Contacts field.';
                }


                field("Guardian Full Name"; Rec."Guardian Full Name")
                {
                    ApplicationArea = all;
                    Enabled = "Guardian Full NameEnable";
                    ToolTip = 'Specifies the value of the Guardian Full Name field.';
                }
                field("Gurdian Contacts"; Rec."Gurdian Contacts")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gurdian Contacts field.';
                }
                field("Intake Code"; Rec."Intake Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Intake Code field.';
                }


                field("Correspondence Address 1"; Rec."Correspondence Address 1")
                {
                    ToolTip = 'Specifies the value of the Correspondence Address 1 field.';
                }
                field("Correspondence Address 2"; Rec."Correspondence Address 2")
                {
                    ToolTip = 'Specifies the value of the Correspondence Address 2 field.';
                }
                field("Correspondence Address 3"; Rec."Correspondence Address 3")
                {
                    ToolTip = 'Specifies the value of the Correspondence Address 3 field.';
                }

                field("Accepted ?"; Rec."Accepted ?")
                {
                    ToolTip = 'Specifies the value of the Accepted ? field.';
                }
                field("Resident ?"; Rec."Resident ?")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Resident ? field.';
                }
            }
        }
        area(factboxes)
        {
            part(Control149; "Admission Photo")
            {
                Caption = 'Student Picture';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Admission No." = FIELD("Admission No.");
                //  Visible = NOT IsOfficeAddin;
            }
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(70134734),
                              "No." = FIELD("Application No.");
            }
            part("Other Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Other Attachments';
                SubPageLink = "Table ID" = CONST(70134877),
                              "No." = FIELD("Application No.");
            }

        }
    }

    actions
    {
        area(navigation)
        {

            group(AdmLeter)
            {
                action(AdmissionLeter)
                {
                    ApplicationArea = basic;
                    Caption = 'Admission Letter';
                    Image = CustomerContact;
                    Promoted = true;
                    ToolTip = 'Executes the Admission Letter action.';
                    trigger OnAction()
                    var
                        AdmRec: record "Admission Form Header";
                    begin
                        Rec.TestField("Settlement Type");
                        if Rec."Settlement Type" = 'KUCCPS' then begin
                            AdmRec.reset;
                            Admrec.setfilter("Admission No.", Rec."Admission No.");
                            if Admrec.find('-') then
                                if AdmRec."Mode of Study" = 'ONLINE STUDENTS' then begin
                                    report.run(54723, true, true, AdmRec);
                                end else
                                    if Rec."Programme Level" = Rec."Programme Level"::PHD then begin
                                        report.run(55063, true, true, AdmRec);
                                    end else
                                        if Rec."Programme Level" = Rec."Programme Level"::Diploma then begin
                                            report.run(54723, true, true, AdmRec);
                                        end else begin
                                            report.run(70135069, true, true, AdmRec);
                                        end;

                        end else begin
                            AdmRec.reset;
                            Admrec.setfilter("Admission No.", Rec."Admission No.");
                            if Admrec.find('-') then
                                report.run(70134723, true, true, AdmRec);
                        end;
                    end;

                }




            }

        }
        area(processing)
        {
            action("Mark as Admitted")
            {
                Caption = 'Mark as Admitted';
                ApplicationArea = all;
                Image = Confirm;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Executes the Mark as Admitted action.';

                trigger OnAction()
                begin
                    /*Ask for confirmation  about the filling in*/
                    if Confirm('Mark the Admission Form as Filled?', true) = false then begin exit end;
                    Rec.TestField("Documents Verified");
                    /*Mark the record as filled*/
                    Rec.TestField(Campus);
                    Rec.TestField("Intake Code");
                    Rec.TestField("Settlement Type");
                    // TestField("Mode of Study");
                    Rec.TestField(Surname);
                    Rec.TestField(Gender);
                    Rec.TestField("Date Of Birth");
                    //TESTFIELD("Marital Status");
                    // TestField(Nationality);
                    Rec.TestField(Region);
                    //  TestField("Index Number");
                    //  TestField("Index Number Year");
                    Rec.TestField("Telephone No. 1");


                    //TESTFIELD("Documents Verified",TRUE);
                    TakeStudentToRegistration();
                    //Post Billing
                    //  GenerateHostelAllocation(NewAdminCode, "Admission No.", "Semester Admitted To", "Settlement Type");

                    BillStudent.BillStudent(NewAdminCode);

                    // BillStudent.GenerateStudentAuditUnits(NewAdminCode);
                    // Cust.Get(NewAdminCode);


                    Rec.Status := Rec.Status::Filled;
                    Cust.Password := 'student';
                    Rec.Modify;
                    Message('The Admission record has been marked as filled. Reg No: ' + NewAdminCode);

                end;
            }
            action("Mark As Verified")
            {
                Caption = 'Mark As Documents Verified';
                ApplicationArea = all;
                Image = Confirm;
                Promoted = true;
                ToolTip = 'Executes the Mark As Documents Verified action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Verify the document?') then begin
                        Rec.TestField(Campus);
                        Rec.TestField("Intake Code");
                        //Status:=Status::Filled;
                        Rec."Documents Verified" := true;
                        Rec."Documents Verified By" := UserId;
                        Cust.Password := 'student';
                        Rec.Modify;
                    end;
                end;
            }
            action("Mark As Rejected")
            {
                Caption = 'Mark As Rejected';
                ApplicationArea = all;
                Image = Confirm;
                Promoted = true;
                ToolTip = 'Executes the Mark As Rejected action.';

                trigger OnAction()
                begin
                    if Confirm('Do you really want to Reject the document?') then begin
                        Rec.TestField(Campus);
                        Rec.TestField("Intake Code");
                        Rec.TestField(Remarks);
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify;
                        //SendEmail(Remarks, 'Your request for admission at ' + CompanyName + ' was unsuccesful');

                    end;
                end;
            }
            action("&Print Admission Letter & Fee Structure")
            {
                Caption = '&Print Admission Letter & Fee Structure';
                Image = Print;
                Promoted = true;
                ApplicationArea = All;
                ToolTip = 'Executes the &Print Admission Letter & Fee Structure action.';
                trigger OnAction()
                begin
                    Apps.reset;
                    Apps.setrange("Admission No.", Rec."Admission No.");
                    if Apps.find('-') then
                        report.run(70134723, true, true, Apps);

                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    begin
        //Campus:= 'MAIN';
        Rec.Nationality := 'KE-254';
        // Religion := '002';
        // "Index Number Year" := 2017;
        // "Mode of Study" := '';
        // "Settlement Type" := 'PSSP';
    end;

    trigger OnInit()
    begin
        "Other ReasonEnable" := true;
        EmploymentEnable := true;
        "Course Not PreferenceEnable" := true;
        "Overseas ScholarshipEnable" := true;
        "Health ProblemEnable" := true;
        "Family ProblemEnable" := true;
        "Spouse Address 3Enable" := true;
        "Spouse Address 2Enable" := true;
        "Spouse Address 1Enable" := true;
        "Spouse NameEnable" := true;
        "Guardian OccupationEnable" := true;
        "Guardian Full NameEnable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Admission Type" := 'PSSP';
        //  "Settlement Type" := 'PSSP';
    end;

    procedure SendEmail(receiver: Text[50]; subject: Text[100]; message: Text[1000]) returnValue: Boolean
    var
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        SendToList: List of [Text];
        HRSetup: Record "HR Setup";
    begin
        HRSetup.Get();
        if HRSetup."Enable Emails" = true then begin
            returnValue := FALSE;
            returnValue := false;

            SendToList.Add(receiver);
            SMTPMail.Create(SendToList, subject, message, true);
            SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
            returnValue := TRUE;

        end;
    end;

    var
        FacultyName: Text[130];
        DegreeName: Text[200];
        AgeText: Text[100];
        NationalityName: Text[30];
        ReligionName: Text[30];
        Cust: Record Customer;
        CourseRegistration: Record "Course Registration";
        Prog: Record programme;

        [InDataSet]
        "Guardian Full NameEnable": Boolean;
        [InDataSet]
        "Guardian OccupationEnable": Boolean;
        [InDataSet]
        "Spouse NameEnable": Boolean;
        [InDataSet]
        "Spouse Address 1Enable": Boolean;
        [InDataSet]
        "Spouse Address 2Enable": Boolean;
        [InDataSet]
        "Spouse Address 3Enable": Boolean;
        [InDataSet]
        "Family ProblemEnable": Boolean;
        [InDataSet]
        "Health ProblemEnable": Boolean;
        [InDataSet]
        "Overseas ScholarshipEnable": Boolean;
        [InDataSet]
        "Course Not PreferenceEnable": Boolean;
        [InDataSet]
        EmploymentEnable: Boolean;
        [InDataSet]
        "Other ReasonEnable": Boolean;
        GeneralSetup: Record "General Set-Up";
        NewAdminCode: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        AdminSetup: Record "Admissions Number Setup";
        Apps: Record "Admission Form Header";
        // DSL: Codeunit "DSL Biometrics";
        BillStudent: Codeunit "Student Billing";

    procedure GetCountry(var CountryCode: Code[20]; var CountryName: Text[30])
    var
        Country: Record "Country/Region";
    begin
        /*Get the country name and display the result*/
        Country.Reset;
        CountryName := '';
        if Country.Get(CountryCode) then begin
            CountryName := Country.Name;
        end;

    end;

    procedure GetSchoolName(var SchoolCode: Code[20]; var SchoolName: Text[130])
    var
    //FormerSchool: Record "Application Setup Fmr School";
    begin
        /*Get the former school name and display the results*/
        /* FormerSchool.Reset;
        SchoolName := '';
        if FormerSchool.Get(SchoolCode) then begin
            SchoolName := FormerSchool.Description;
        end; */

    end;

    procedure GetDegreeName(var DegreeCode: Code[20]; var DegreeName: Text[200])
    var
        Programme: Record Programme;
    begin
        /*get the degree name and display the results*/
        Programme.Reset;
        DegreeName := '';
        if Programme.Get(DegreeCode) then begin
            DegreeName := Programme.Description;
        end;

    end;

    procedure GetFacultyName(var DegreeCode: Code[20]; var FacultyName: Text[130])
    var
        Programme: Record Programme;
        DimVal: Record "Dimension Value";
    begin
        /*Get the faculty name and return the result*/
        Programme.Reset;
        FacultyName := '';

        if Programme.Get(DegreeCode) then begin
            DimVal.Reset;
            DimVal.SetRange(DimVal."Global Dimension No.", 3);
            DimVal.SetRange(DimVal.Code, Programme."School Code");
            if DimVal.Find('-') then begin
                FacultyName := DimVal.Name;
            end;
        end;

    end;

    procedure GetAge(var StartDate: Date; var AgeText: Text[100])
    var
        HRDates: Codeunit "HR Dates";
    begin
        /*Get the age based on the dates inserted*/
        if StartDate = 0D then begin StartDate := Today end;

        AgeText := HRDates.DetermineAge(StartDate, Today);

    end;

    procedure GetReligionName(var ReligionCode: Code[20]; var ReligionName: Text[30])
    var
        Religion: Record "Academics Central Setups";
    begin
        /*Get the religion name and display the result*/
        Religion.Reset;
        Religion.SetRange(Religion."Title Code", ReligionCode);
        Religion.SetRange(Religion.Category, Religion.Category::Religions);

        ReligionName := '';
        if Religion.Find('-') then begin
            ReligionName := Religion.Description;
        end;

    end;

    procedure TakeStudentToRegistration()
    var
        DimRec: Record "Dimension Value";
        Spr: Text[20];
    begin
        GeneralSetup.Get;
        Rec.TestField(Campus);
        spr := GeneralSetup."Registration Number Seperator";
        Cust.Reset;
        Cust.SetRange("Application No.", Rec."Admission No.");
        if Cust.Find('-') then Error('The selected Student has already been admitted with Reg No. ' + Cust."No.");

        //   AdmissionNumber.RESET;
        //   AdmissionNumber.SETRANGE(AdmissionNumber.Degree,"Degree Admitted To");
        //   IF AdmissionNumber.FIND('-') THEN BEGIN
        //   NewAdminCode:=AdmissionNumber."Programme Prefix"+'/'+AdmissionNumber.Year
        //   END;
        AdminSetup.Reset;
        AdminSetup.SetRange(AdminSetup.Degree, Rec."Degree Admitted To");
        if AdminSetup.Find('-') then begin
            if AdminSetup."No. Series" = '' then Error('Admission Number Setup For Programme ' + Format(Rec."Degree Admitted To") + ' is incomplete');
            if GeneralSetup."Use Campus Prefix on Admission" = true then begin
                dimrec.reset;
                dimrec.setrange(Code, Rec.Campus);
                if DimRec.find('-') then begin
                    // DimRec.TestField("Admission Number prefix");
                    // NewAdminCode := AdminSetup."Programme Prefix" + spr + DimRec."Admission Number prefix" + spr + NoSeriesMgt.GetNextNo(AdminSetup."No. Series", 0D, true) + spr + AdminSetup.Year;
                end;
            end else begin
                if AdminSetup."SSP Prefix" = '' then
                    NewAdminCode := AdminSetup."Programme Prefix" + spr + NoSeriesMgt.GetNextNo(AdminSetup."No. Series", 0D, true) + spr + AdminSetup.Year
                else
                    NewAdminCode := AdminSetup."Programme Prefix" + spr + AdminSetup."SSP Prefix" + spr + NoSeriesMgt.GetNextNo(AdminSetup."No. Series", 0D, true) + spr + AdminSetup.Year;
            end;


        end
        else begin
            Error('Admission Number Setup For Programme ' + Format(Rec."Degree Admitted To") + ' is missing');
        end;
        begin
            //  NewAdminCode:="Admission No.";
            Cust.Init;
            Cust."No." := NewAdminCode;
            Cust.Name := CopyStr(UpperCase(Rec.Surname) + ', ' + UpperCase(Rec."Other Names"), 1, 50);
            Cust."Search Name" := UpperCase(CopyStr(Rec.Surname + ' ' + Rec."Other Names", 1, 30));
            Cust.Address := Rec."Correspondence Address 1";
            Cust."Address 2" := CopyStr(Rec."Correspondence Address 2" + ',' + Rec."Correspondence Address 3", 1, 30);
            Cust."Phone No." := Rec."Telephone No. 1" + ',' + Rec."Telephone No. 2";
            Cust."Telex No." := Rec."Fax No.";
            Cust."E-Mail" := Rec."E-Mail";
            Cust.Gender := Rec.Gender;
            Cust."Date Of Birth" := Rec."Date Of Birth";
            Cust."Date Registered" := Today;
            Cust."Customer Type" := Cust."Customer Type"::Student;
            //        Cust."Student Type":=FORMAT(Enrollment."Student Type");
            //        Cust."ID No":=;
            Cust."Application No." := Rec."Application No.";
            //Cust."Admission No." := "Admission No.";
            Cust."Marital Status" := Rec."Marital Status";
            Cust.Citizenship := Format(Rec.Nationality);
            Cust.Religion := Format(Rec.Religion);
            Cust."Application Method" := Cust."Application Method"::"Apply to Oldest";
            Cust."Customer Posting Group" := 'STUDENT';
            Cust."Global Dimension 1 Code" := Rec.Campus;
            Cust."Mother Full Name" := Rec."Mother Full Name";
            Cust."Father Full Name" := Rec."Father Full Name";
            Cust."Guardian Full Name" := Rec."Guardian Full Name";
            Cust."Mother Contacts" := Rec."Mother Contacts";
            Cust."Father Contacts" := Rec."Father Contacts";
            Cust."Gurdian Contacts" := Rec."Gurdian Contacts";
            Cust."KNEC No" := Rec."Index Number";
            Cust.Password := 'student';
            Cust."Current Programme" := Rec."Degree Admitted To";
            // Cust."Current Settlement Type" := "Settlement Type";
            Cust.Image := Rec.Photo;
            // Cust."Mode of Study" := "Mode of Study";
            Cust.Nationality := Rec.Nationality;
            Cust."Entry Intake" := Rec."Intake Code";
            // Cust.Congregation := Congregation;
            Cust."ID No" := Rec."ID Number";
            // Cust."Knew University Through" := "Knew University Thru";
            Cust."Region Code" := Rec.Region;
            // cust.Ethnicity := Ethnicity;
            Cust."Class Code" := GeneralSetup."Default Class";

            //  Cust.VALIDATE(Cust."Customer Posting Group");
            Cust.Insert();


            //insert the course registration details
            CourseRegistration.Reset;
            CourseRegistration.Init;
            CourseRegistration."Reg. Transacton ID" := '';
            CourseRegistration.Validate(CourseRegistration."Reg. Transacton ID");
            CourseRegistration."Student No." := NewAdminCode;
            CourseRegistration.Programme := Rec."Degree Admitted To";
            CourseRegistration.Semester := Rec."Semester Admitted To";
            CourseRegistration.Stage := Rec."Stage Admitted To";
            CourseRegistration."Student Type" := CourseRegistration."Student Type"::"Full Time";
            CourseRegistration."Registration Date" := Today;
            CourseRegistration."Settlement Type" := Rec."Settlement Type";
            CourseRegistration."Academic Year" := GetCurrYear();
            CourseRegistration."First Time Student" := true;
            if Prog.get(Rec."Degree Admitted To") then begin
                if Prog."Billing By" = prog."Billing By"::Subject then
                    CourseRegistration."Register for" := CourseRegistration."Register for"::"Unit/Subject"
                else
                    CourseRegistration."Register for" := CourseRegistration."Register for"::Stage;
            end;
            //CourseRegistration.VALIDATE(CourseRegistration."Settlement Type");
            CourseRegistration.Insert;

            if Prog."Billing By" = Prog."Billing By"::"By Stage" then begin
                CourseRegistration.Reset;
                CourseRegistration.SetRange(CourseRegistration."Student No.", NewAdminCode);
                if CourseRegistration.Find('+') then begin
                    CourseRegistration."Registration Date" := Today;
                    CourseRegistration.Validate(CourseRegistration."Registration Date");
                    CourseRegistration."Settlement Type" := Rec."Settlement Type";
                    CourseRegistration.Validate(CourseRegistration."Settlement Type");
                    CourseRegistration."Academic Year" := GetCurrYear();
                    CourseRegistration.Modify;

                end;
            end;


            //insert the details related to the next of kin of the student into the database
            /*  AdminKin.Reset;
             AdminKin.SetRange(AdminKin."Admission No.", "Admission No.");
             if AdminKin.Find('-') then begin
                 repeat
                     StudentKin.Reset;
                     StudentKin.Init;
                     StudentKin."Student No" := NewAdminCode;
                     StudentKin.Relationship := AdminKin.Relationship;
                     StudentKin.Name := AdminKin."Full Name";
                     //StudentKin."Other Names":=EnrollmentNextofKin."Other Names";
                     //StudentKin."ID No/Passport No":=EnrollmentNextofKin."ID No/Passport No";
                     //StudentKin."Date Of Birth":=EnrollmentNextofKin."Date Of Birth";
                     //StudentKin.Occupation:=EnrollmentNextofKin.Occupation;
                     StudentKin."Office Tel No" := AdminKin."Telephone No. 1";
                     StudentKin."Home Tel No" := AdminKin."Telephone No. 2";
                     //StudentKin.Remarks:=EnrollmentNextofKin.Remarks;
                     StudentKin.Insert;
                 until AdminKin.Next = 0;
             end; */

            //insert the details in relation to the guardian/sponsor into the database in relation to the current student
            /*  if "Mother Alive Or Dead" = "Mother Alive Or Dead"::Alive then begin
                 if "Mother Full Name" <> '' then begin
                     StudentGuardian.Reset;
                     StudentGuardian.Init;
                     StudentGuardian."Student No." := NewAdminCode;
                     StudentGuardian.Names := "Mother Full Name";
                     StudentGuardian.Insert;
                 end;
             end;
             if "Father Alive Or Dead" = "Father Alive Or Dead"::Alive then begin
                 if "Father Full Name" <> '' then begin
                     StudentGuardian.Reset;
                     StudentGuardian.Init;
                     StudentGuardian."Student No." := NewAdminCode;
                     StudentGuardian.Names := "Father Full Name";
                     StudentGuardian.Insert;
                 end;
             end;
             if "Guardian Full Name" <> '' then begin
                 if "Guardian Full Name" <> '' then begin
                     StudentGuardian.Reset;
                     StudentGuardian.Init;
                     StudentGuardian."Student No." := NewAdminCode;
                     StudentGuardian.Names := "Guardian Full Name";
                     StudentGuardian.Insert;
                 end;
             end; */

            /*

                    //insert the details in relation to the student history as detailed in the application
                        EnrollmentEducationHistory.RESET;
                        EnrollmentEducationHistory.SETRANGE(EnrollmentEducationHistory."Enquiry No.",Enrollment."Enquiry No.");
                        IF EnrollmentEducationHistory.FIND('-') THEN
                            BEGIN
                                REPEAT
                                    EducationHistory.RESET;
                                    EducationHistory.INIT;
                                        EducationHistory."Student No.":=NewAdminCode;
                                        EducationHistory.From:=EnrollmentEducationHistory.From;
                                        EducationHistory."To":=EnrollmentEducationHistory."To";
                                        EducationHistory.Qualifications:=EnrollmentEducationHistory.Qualifications;
                                        EducationHistory.Instituition:=EnrollmentEducationHistory.Instituition;
                                        EducationHistory.Remarks:=EnrollmentEducationHistory.Remarks;
                                        EducationHistory."Aggregate Result/Award":=EnrollmentEducationHistory."Aggregate Result/Award";
                                    EducationHistory.INSERT;
                                UNTIL EnrollmentEducationHistory.NEXT=0;
                            END;
                    //update the status of the application
                        Enrollment."Registration No":=NewAdminCode;
                        Enrollment.Status:=Enrollment.Status::Admitted;
                        Enrollment.MODIFY;

             */
        end;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        /*Display the details from the database*/
        GetFacultyName(Rec."Degree Admitted To", FacultyName);
        GetDegreeName(Rec."Degree Admitted To", DegreeName);
        GetCountry(Rec.Nationality, NationalityName);
        GetReligionName(Rec.Religion, ReligionName);
        GetAge(Rec."Date Of Birth", AgeText);

        /*Check if the mother or the father is alive or dead*/
        if (Rec."Mother Alive Or Dead" = Rec."Mother Alive Or Dead"::Deceased) and (Rec."Father Alive Or Dead" = Rec."Father Alive Or Dead"::Deceased) then begin
            /*Disable the guardian details*/
            "Guardian Full NameEnable" := not false;
            "Guardian OccupationEnable" := not false;
        end
        else
            if (Rec."Mother Alive Or Dead" = Rec."Mother Alive Or Dead"::Alive) and (Rec."Father Alive Or Dead" = Rec."Father Alive Or Dead"::Alive) then begin
                /*Disable the guardian details*/
                "Guardian Full NameEnable" := false;
                "Guardian OccupationEnable" := false;
            end;

        /*Check the mariatl status of the student*/
        if Rec."Marital Status" = Rec."Marital Status"::Single then begin
            /*Disable the spouse details*/
            "Spouse NameEnable" := false;
            "Spouse Address 1Enable" := false;
            "Spouse Address 2Enable" := false;
            "Spouse Address 3Enable" := false;
        end
        else begin
            /*Enable the spouse details*/
            "Spouse NameEnable" := true;
            "Spouse Address 1Enable" := true;
            "Spouse Address 2Enable" := true;
            "Spouse Address 3Enable" := true;
        end;

    end;

    procedure GetCurrYear() CurrYear: Text
    var
        acadYear: Record "Academic Year";
    begin
        acadYear.Reset;
        acadYear.SetRange(acadYear.Current, true);
        if acadYear.Find('-') then begin
            CurrYear := acadYear.Code;
        end else
            Error('No current academic year specified.');
    end;

    procedure GenerateHostelAllocation(StudentNo: Code[20]; AdminNo: Code[20]; Sem: Code[20]; SettlementType: Code[20])
    var
        BookingAgent: Record "Hostel Booking Agents";
        HostelAlloc: Record "Students Hostel Rooms";
        Cust: Record Customer;
        Host_Ledger: Record "Hostel Ledger";
        counts: Integer;
        Rooms_Spaces: Record "Room Spaces";
        Hostel_Rooms: Record "Hostel Block Rooms";
        RoomCost: Decimal;
        charges1: Record Charge;
        StudentCharges: Record "Student Charges";
        coReg: Record "Course Registration";
    begin
        BookingAgent.Reset;
        BookingAgent.SetRange(BookingAgent.No, AdminNo);
        BookingAgent.SetRange("Payment Status", BookingAgent."Payment Status"::Confirmed);
        if BookingAgent.Find('-') then begin
            if Cust.Get(StudentNo) then begin

                Rooms_Spaces.Reset;
                //Rooms_Spaces.SETRANGE(Rooms_Spaces.Status,Rooms_Spaces.Status::Vaccant);
                Rooms_Spaces.SetRange(Rooms_Spaces."Hostel Code", BookingAgent."Hostel Name");
                Rooms_Spaces.SetRange(Rooms_Spaces."Space Code", BookingAgent."Room Space");
                // Rooms_Spaces.SETFILTER(Rooms_Spaces.Gender,'%1',Cust.Gender);
                if Rooms_Spaces.Find('-') then begin
                    if Host_Ledger.Get(BookingAgent."Room Space", Rooms_Spaces."Room Code", Rooms_Spaces."Hostel Code") then begin
                        Host_Ledger.Delete;
                    end;
                    Host_Ledger.Reset;
                    if Host_Ledger.Find('-') then counts := Host_Ledger.Count;
                    Hostel_Rooms.Reset;
                    Hostel_Rooms.SetRange(Hostel_Rooms."Hostel Code", Rooms_Spaces."Hostel Code");
                    Hostel_Rooms.SetRange(Hostel_Rooms."Room Code", Rooms_Spaces."Room Code");
                    if Hostel_Rooms.Find('-') then begin
                        if SettlementType = 'GSSP' then RoomCost := Hostel_Rooms."JAB Fees";
                        if SettlementType = 'PSSP' then RoomCost := Hostel_Rooms."SSP Fees";
                    end;
                    Host_Ledger.Init;
                    Host_Ledger."Space No" := Rooms_Spaces."Space Code";
                    Host_Ledger."Room No" := Rooms_Spaces."Room Code";
                    Host_Ledger."Hostel No" := Rooms_Spaces."Hostel Code";
                    Host_Ledger.No := counts;
                    Host_Ledger.Status := Host_Ledger.Status::"Fully Occupied";
                    Host_Ledger."Room Cost" := RoomCost;
                    Host_Ledger."Student No" := StudentNo;
                    Host_Ledger."Receipt No" := '';
                    Host_Ledger.Semester := Sem;
                    Host_Ledger.Gender := Cust.Gender;
                    Host_Ledger."Hostel Name" := '';
                    Host_Ledger.Campus := Cust."Global Dimension 1 Code";
                    Host_Ledger."Academic Year" := BookingAgent."Academic Year";
                    Host_Ledger.Insert(true);

                    Rooms_Spaces.Status := Rooms_Spaces.Status::"Fully Occupied";
                    Rooms_Spaces.Modify;


                    Hostel_Rooms.Reset;
                    Hostel_Rooms.SetRange(Hostel_Rooms."Hostel Code", Rooms_Spaces."Hostel Code");
                    Hostel_Rooms.SetRange(Hostel_Rooms."Room Code", Rooms_Spaces."Room Code");
                    if Hostel_Rooms.Find('-') then begin
                        Hostel_Rooms.CalcFields(Hostel_Rooms."Bed Spaces", Hostel_Rooms."Occupied Spaces");
                        if Hostel_Rooms."Bed Spaces" = Hostel_Rooms."Occupied Spaces" then
                            Hostel_Rooms.Status := Hostel_Rooms.Status::"Fully Occupied"
                        else
                            if Hostel_Rooms."Occupied Spaces" < Hostel_Rooms."Bed Spaces" then
                                Hostel_Rooms.Status := Hostel_Rooms.Status::"Partially Occupied";
                        Hostel_Rooms.Modify;
                    end;

                    HostelAlloc.Init;
                    HostelAlloc.Student := StudentNo;
                    HostelAlloc."Accomodation Fee" := RoomCost;
                    HostelAlloc.Semester := Sem;
                    HostelAlloc.Charges := RoomCost;
                    HostelAlloc.Amount := RoomCost;
                    HostelAlloc.Gender := Cust.Gender;
                    HostelAlloc."Space No" := Rooms_Spaces."Space Code";
                    HostelAlloc."Room No" := Rooms_Spaces."Room Code";
                    HostelAlloc."Hostel No" := Rooms_Spaces."Hostel Code";
                    HostelAlloc.Billed := true;
                    HostelAlloc."Billed Date" := Today;
                    HostelAlloc."Allocation Date" := Today;
                    HostelAlloc.Allocated := true;
                    HostelAlloc.Insert;

                    charges1.Reset;
                    charges1.SetRange(charges1.Hostel, true);
                    if not charges1.Find('-') then
                        Error('Accommodation charges not setup.');

                    StudentCharges.Reset;
                    StudentCharges.SetRange(StudentCharges."Student No.", StudentNo);
                    StudentCharges.SetRange(StudentCharges.Semester, Sem);
                    StudentCharges.SetRange(StudentCharges.Code, charges1.Code);
                    if not StudentCharges.Find('-') then begin
                        coReg.Reset;
                        coReg.SetRange(coReg."Student No.", StudentNo);
                        coReg.SetRange(coReg.Semester, Sem);
                        if coReg.Find('-') then begin
                            StudentCharges.Init;
                            StudentCharges."Transacton ID" := '';
                            StudentCharges.Validate(StudentCharges."Transacton ID");
                            StudentCharges."Student No." := coReg."Student No.";
                            StudentCharges."Reg. Transacton ID" := coReg."Reg. Transacton ID";
                            StudentCharges."Transaction Type" := StudentCharges."Transaction Type"::Charges;
                            StudentCharges.Code := charges1.Code;
                            StudentCharges.Description := 'Accommodation Fees';
                            StudentCharges.Amount := RoomCost;
                            StudentCharges.Date := Today;
                            StudentCharges.Programme := coReg.Programme;
                            StudentCharges.Stage := coReg.Stage;
                            StudentCharges.Semester := coReg.Semester;
                            StudentCharges.Insert();
                        end;
                    end;
                end;
            end;
            // END;
        end;
    end;

    local procedure MyFormat(Text: Text[200]) Name: Text[200]
    var
        i: Integer;
    begin
        for i := 1 to StrLen(Name) do begin
            if i = 1 then
                Evaluate(Name[i], UpperCase(Format(Name[i])))
            else
                if Name[i - 1] = 32 then
                    Evaluate(Name[i], UpperCase(Format(Name[i])))
                else
                    Evaluate(Name[i], LowerCase(Format(Name[i])));
        end;
        exit(Name);
    end;
}

