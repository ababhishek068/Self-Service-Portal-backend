Table 50412 "HR Job Applications"
{
    Caption = 'HR Job Applications';

    fields
    {
        field(1; "Job Application No."; Code[50])
        {
            Editable = false;
        }
        field(2; "First Name"; Text[100])
        {

            trigger OnValidate()
            begin
                fn_FullName;
            end;
        }
        field(3; "Middle Name"; Text[50])
        {

            trigger OnValidate()
            begin
                fn_FullName;
            end;
        }
        field(4; "Last Name"; Text[50])
        {

            trigger OnValidate()
            begin
                fn_FullName
            end;
        }
        field(5; Initials; Text[15]) { }
        field(7; "Search Name"; Code[50]) { }
        field(8; "Postal Address"; Text[80]) { }
        field(9; "Residential Address"; Text[80]) { }
        field(10; City; Text[30]) { }
        field(11; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(12; county; Text[30]) { }
        field(13; "Home Phone Number"; Text[30]) { }
        field(14; "Cell Phone Number"; Text[30]) { }
        field(15; "Work Phone Number"; Text[30]) { }
        field(16; "Ext."; Text[7]) { }
        field(17; "E-Mail"; Text[80]) { }
        field(19; Picture; Blob)
        {
            SubType = Bitmap;
        }
        field(20; "ID Number"; Text[30])
        {

            trigger OnValidate()
            begin
                /*
                HRJobApp.RESET;
                HRJobApp.SETRANGE(HRJobApp."ID Number","ID Number");
                IF HRJobApp.FIND('-') THEN BEGIN
                  ERROR('This ID Number has been used in a prior Job Application.');
                END;
                */

            end;
        }
        field(21; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(22; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(23; Status; Option)
        {
            OptionMembers = Submitted,Interview,Successful,Unsuccessful,Canceled;
        }
        field(24; Comment; Boolean)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(25; "Fax Number"; Text[30]) { }
        field(26; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(27; Colour; Option)
        {
            OptionMembers = African,Indian,White,Coloured;
        }
        field(28; "First Language (R/W/S)"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter(Language));
        }
        field(29; "Driving Licence"; Code[10]) { }
        field(30; Disabled; Option)
        {
            OptionMembers = No,Yes," ";
        }
        field(31; "Health Assesment?"; Boolean) { }
        field(32; "Health Assesment Date"; Date) { }
        field(33; "Date Of Birth"; Date)
        {

            trigger OnValidate()
            begin
                if "Date Of Birth" >= Today then begin
                    Error('Date of Birth cannot be after %1', Today);
                end;
            end;
        }
        field(34; Age; Text[80]) { }
        field(35; "Second Language (R/W/S)"; Code[10])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter(Language));
        }
        field(36; "Additional Language"; Code[100])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter(Language));
        }
        field(37; "Primary Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(38; Level; Option)
        {
            OptionMembers = " ","Level 1","Level 2","Level 3","Level 4","Level 5","Level 6","Level 7";
        }
        field(39; "Termination Category"; Option)
        {
            OptionMembers = " ",Resignation,"Non-Renewal Of Contract",Dismissal,Retirement,Death,Other;

            trigger OnValidate()
            begin
            end;
        }
        field(40; "Postal Address2"; Text[30]) { }
        field(41; "Postal Address3"; Text[20]) { }
        field(42; "Residential Address2"; Text[30]) { }
        field(43; "Residential Address3"; Text[20]) { }
        field(44; "Post Code2"; Code[20])
        {
            TableRelation = "Post Code";
        }
        field(45; Citizenship; Code[10])
        {
            TableRelation = "Country/Region".Code;

            trigger OnValidate()
            begin
                Country.Reset;
                Country.SetRange(Country.Code, Citizenship);
                if Country.Find('-') then begin
                    "Citizenship Details" := Country.Name;
                end;
            end;
        }
        field(46; "Disabling Details"; Text[50]) { }
        field(47; "Disability Grade"; Text[30]) { }
        field(48; "Passport Number"; Text[30]) { }
        field(49; "2nd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(50; "3rd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(51; Region; Code[10])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(52; "First Language Read"; Boolean) { }
        field(53; "First Language Write"; Boolean) { }
        field(54; "First Language Speak"; Boolean) { }
        field(55; "Second Language Read"; Boolean) { }
        field(56; "Second Language Write"; Boolean) { }
        field(57; "Second Language Speak"; Boolean) { }
        field(58; "PIN Number"; Code[20]) { }
        field(59; "Job Applied For"; Text[30])
        {
            Editable = false;
        }
        field(60; "Employee Requisition No"; Code[20])
        {
            TableRelation = "HR Employee Requisitions";

            trigger OnValidate()
            begin
                "Job Applied For" := '';
                "Job Applied for Description" := '';

                HREmpReq.Reset;
                HREmpReq.SetRange(HREmpReq."Requisition No.", "Employee Requisition No");
                if HREmpReq.Find('-') then
                    "Job Applied For" := HREmpReq."Job ID";
                "Job Applied for Description" := HREmpReq."Job Description";
                "Applicant Type" := HREmpReq."Requisition Type";
            end;
        }
        field(61; "Total Score"; Decimal)
        {
            CalcFormula = lookup("HR Job Interview".Score where("Interview Code" = field("Job Application No.")));
            FieldClass = FlowField;
        }
        field(62; Shortlist; Boolean) { }
        field(63; Qualified; Boolean)
        {
            Editable = false;
        }
        field(64; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR Recruitment Stages".code;
        }
        field(65; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(66; "Employee No"; Code[20])
        {

            trigger OnValidate()
            begin
                //COPY EMPLOYEE DETAILS FROM EMPLOYEE TABLE
                /*Employee.RESET;
                IF Employee.GET("Employee No") THEN BEGIN
                "First Name":=Employee."First Name";
                "Middle Name":=Employee."Middle Name";
                "Last Name":=Employee."Last Name";
                //"Search Name":=Employee."Full Name";
                "Postal Address":=Employee."Postal Address";
                "Residential Address":=Employee."Residential Address";
                City:=Employee.City;
                "Post Code":=Employee."Post Code";
                Region:=Employee."Region Code";
                "Home Phone Number":=Employee."Home Phone Number";
                "Cell Phone Number":=Employee."Cellular Phone Number";
                "Work Phone Number":=Employee."Work Phone Number";
                "Ext.":=Employee."Ext.";
                "E-Mail":=Employee."E-Mail";
                "ID Number":=Employee."ID Number";
                Gender:=Employee.Gender;
                "Country Code":=Employee.Citizenship;
                "Fax Number":=Employee."Fax Number";
                "Marital Status":=Employee."Marital Status";
                //Colour:=Employee.Color;
                "First Language (R/W/S)":=Employee."First Language (R/W/S)";
                //"Driving Licence":=Employee."Has Driving Licence";
                Disabled:=Employee.Disabled;
                "Health Assesment?":=Employee."Health Assesment?";
                "Health Assesment Date":=Employee."Health Assesment Date";
                "Date Of Birth":=Employee."Date Of Birth";
                Age:=Employee.Age;
                "Second Language (R/W/S)":=Employee."Second Language (R/W/S)";
                "Additional Language":=Employee."Additional Language";
                Citizenship:=Employee.Citizenship;
                "Passport Number":=Employee."Passport Number";
                "First Language Read":=Employee."First Language Read";
                "First Language Write":=Employee."First Language Write";
                "First Language Speak":=Employee."First Language Speak";
                "Second Language Read":=Employee."Second Language Read";
                "Second Language Write":=Employee."Second Language Write";
                "Second Language Speak":=Employee."Second Language Speak";
                "PIN Number":=Employee."PIN Number";
                
                "Applicant Type":="Applicant Type"::External;
                MODIFY;
                
                            //DELETE QUALIFICATIONS PREVIOUSLY COPIED
                            AppQualifications.RESET;
                            AppQualifications.SETRANGE(AppQualifications."Line No.","Job Application No.");
                            IF AppQualifications.FIND('-') THEN
                            AppQualifications.DELETEALL;
                
                            //GET EMPL0YEE QUALIFICATIONS
                            EmpQualifications.RESET;
                            EmpQualifications.SETRANGE(EmpQualifications."Employee No.",Employee."No.");
                            IF EmpQualifications.FIND('-') THEN
                            EmpQualifications.FINDFIRST;
                            BEGIN
                            AppQualifications.RESET;
                
                                REPEAT
                                AppQualifications.INIT;
                                AppQualifications."Line No.":="Job Application No.";
                                AppQualifications.Email:="Employee No";
                                AppQualifications."Qualification Type":=EmpQualifications."Qualification Type";
                                AppQualifications."Qualification Code":=EmpQualifications."Qualification Code";
                                AppQualifications."Employee No.":=EmpQualifications."Qualification Description";
                                AppQualifications."Qualification Type":=EmpQualifications."From Date";
                                AppQualifications."Qualification Category":=EmpQualifications."To Date";
                                AppQualifications."Qualification Code":=EmpQualifications.Type;
                                AppQualifications."Institution/Company":=EmpQualifications."Institution/Company";
                                AppQualifications.INSERT();
                
                                UNTIL EmpQualifications.NEXT = 0;
                            END
                END;
                
                {
                END ELSE BEGIN
                "First Name":='';
                "Middle Name":='';
                "Last Name":='';
                "Search Name":='';
                "Postal Address":='';
                "Residential Address":='';
                City:=Employee.City;
                "Post Code":='';
                Region:='';
                "Home Phone Number":='';
                "Cell Phone Number":='';
                "Work Phone Number":='';
                "Ext.":='';
                "E-Mail":='';
                "ID Number":='';
                
                "Country Code":='';
                "Fax Number":='';
                
                "First Language (R/W/S)":='';
                //"Driving Licence":=Employee."Has Driving Licence";
                
                "Health Assesment Date":=0D;
                "Date Of Birth":=0D;
                Age:='';
                "Second Language (R/W/S)":='';
                "Additional Language":='';
                "Postal Address2":='';
                "Postal Address3":='';
                "Residential Address2":='';
                "Residential Address3":='';
                "Post Code2":='';
                Citizenship:='';
                "Passport Number":='';
                "First Language Read":=FALSE;
                "First Language Write":=FALSE;
                "First Language Speak":=FALSE;
                "Second Language Read":=FALSE;
                "Second Language Write":=FALSE;
                "Second Language Speak":=FALSE;
                "PIN Number":='';
                
                "Applicant Type":="Applicant Type"::External;
                MODIFY;
                
                //DELETE QUALIFICATIONS PREVIOUSLY COPIED
                AppQualifications.RESET;
                AppQualifications.SETRANGE(AppQualifications."Application No","Application No");
                IF AppQualifications.FIND('-') THEN
                AppQualifications.DELETEALL;
                
                //DELETE APPLICANT REFEREES
                AppRefferees.RESET;
                AppRefferees.SETRANGE(AppRefferees."Job Application No","Application No");
                IF AppRefferees.FIND('-') THEN
                AppRefferees.DELETEALL;
                
                //DELETE APPLICANT HOBBIES
                AppHobbies.RESET;
                AppHobbies.SETRANGE(AppHobbies."Job Application No","Application No");
                IF AppHobbies.FIND('-') THEN
                AppHobbies.DELETEALL;
                
                END;}
                */

            end;
        }
        field(67; "Applicant Type"; Option)
        {
            OptionCaption = ' ,External,Internal';
            OptionMembers = " ",External,Internal;
        }
        field(68; "Interview Invitation Sent"; Boolean)
        {
            Editable = true;
        }
        field(69; "Date Applied"; Date) { }
        field(70; "Citizenship Details"; Text[60]) { }
        field(71; Expatriate; Boolean) { }
        field(72; "Total Score After Interview"; Decimal)
        {
            CalcFormula = sum("HR Job Interview".Score where("Interview Code" = field("Job Application No.")));
            FieldClass = FlowField;
        }
        field(73; "Total Score After Shortlisting"; Decimal) { }
        field(74; "Date of Interview"; Date) { }
        field(75; "From Time"; Time) { }
        field(76; "To Time"; Time) { }
        field(77; Venue; Text[100]) { }
        field(78; "Job Applied for Description"; Text[100]) { }
        field(79; "Regret Notice Sent"; Boolean) { }
        field(80; "Interview Type"; Option)
        {
            OptionCaption = 'Writen & Oral,Practicals & Writen,Writen & Practical,All(Writen Practicals & Oral),Writen,Practicals,Oral';
            OptionMembers = "Writen & Oral","Practicals & Writen","Writen & Practical","All(Writen Practicals & Oral)",Writen,Practicals,Oral;
        }
        field(81; Uploaded; Boolean) { }
        field(82; "Full Name"; Text[100]) { }
        field(83; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR".Code;
        }
        field(84; "Approval Status"; Option)
        {
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(85; "Ethnic Origin"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("ShortListing Criteria"));
        }
        field(86; "Region Of Birth"; Code[100]) { }
        field(87; "Region Of Residence"; Code[100])
        {
            Enabled = false;
        }
        field(127; "First Language Proficiency"; Option)
        {
            OptionCaption = ' ,Proficient,Excellent,Intermediate,Basic';
            OptionMembers = " ",Proficient,Excellent,Intermediate,Basic;
        }
        field(128; "Second Language Proficiency"; Option)
        {
            OptionCaption = ' ,Proficient,Excellent,Intermediate,Basic';
            OptionMembers = " ",Proficient,Excellent,Intermediate,Basic;
        }
        field(50000; "Recommended By Committee"; Boolean)
        {

            trigger OnValidate()
            begin
                "Commitee Recommendation Date" := Today;
                "Committee User ID" := UserId;
            end;
        }
        field(50001; "Reason for Com Recommendation"; Text[250]) { }
        field(50002; "Recommended By DG"; Boolean)
        {

            trigger OnValidate()
            begin
                // "DG  Recommendation Date":=TODAY;
                // "DG User ID":=USERID;
            end;
        }
        field(50003; "Reason for Comm  Recommed"; Text[250]) { }
        field(50004; "Committee User ID"; Code[40]) { }
        field(50005; "Commitee Recommendation Date"; Date) { }
        field(50006; "DG  Recommendation Date"; Date) { }
        field(50007; "DG User ID"; Code[40]) { }
        field(50009; "Account No"; Code[20])
        {
            TableRelation = "Applicant Register"."Account No";
            trigger OnValidate()
            var
                AppRegister: record "Applicant Register";
            begin
                AppRegister.reset;
                AppRegister.setrange(AppRegister."Account No", "Account No");
                if AppRegister.find('-') then begin
                    "E-Mail" := AppRegister.Email;
                    "First Name" := AppRegister."First Name";
                    "Last Name" := AppRegister."Last Name";
                    "Middle Name" := AppRegister."Middle Name";
                    "ID Number" := AppRegister."ID Number";
                    Disabled := AppRegister."Living with Disability?";
                    "Disabling Details" := AppRegister."Disability Details";
                    Citizenship := AppRegister.Nationality;
                end;
            end;
        }
        field(50008; MyRecId; RecordID) { }
        field(50010; "Shortlisting Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;

        }
        field(50011; "Qualified Stages Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("HR Shortlisting Entry" where("Applicant No" = field("Job Application No."), "Requisition No" = field("Employee Requisition No"), "Stage Code" = field("Shortlisting Stage Filter")));
        }
    }

    keys
    {
        key(Key1; "Job Application No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //GENERATE NEW NUMBER FOR THE DOCUMENT

        if "Job Application No." = '' then begin
            HRJobApplications.Reset();
            if HRJobApplications.FindLast() then begin
                "Job Application No." := IncStr(HRJobApplications."Job Application No.")
            end else begin
                "Job Application No." := 'APPL0001';
            end;
        end;

        "Date Applied" := Today;
        MyRecRef.GetTable(Rec);
        MyRecId := MyRecRef.RecordId;
    end;

    trigger OnModify()
    begin
        if "Date Applied" = 0D then
            "Date Applied" := Today;
    end;

    var
        HREmpReq: Record "HR Employee Requisitions";
        Country: Record "Country/Region";
        MyRecRef: RecordRef;
        HRJobApplications: Record "HR Job Applications";

    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("First Name" + ' ' + "Last Name")
        else
            exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    local procedure fn_FullName()
    begin
        "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
    end;
}

