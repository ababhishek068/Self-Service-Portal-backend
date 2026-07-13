Table 50275 "Admission Form Header"
{

    fields
    {
        field(1; "Admission No."; Code[30])
        {
            Description = 'Stores the admission number in the database';
            NotBlank = true;
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the admission was entered into the system';
        }
        field(3; "Admission Type"; Code[20])
        {
            Description = 'Stores the type of admission in the database';
            // TableRelation = "Settlement Type";
        }
        field(4; "JAB S.No"; Code[20])
        {
            Description = 'Stores the JAB Serial No';
        }
        field(5; "Academic Year"; Code[20])
        {
            Description = 'Stores the academicyear';
            TableRelation = "Academic Year".Code;
        }
        field(6; "Application No."; Code[25])
        {
            Description = 'Stores the application number in the database';
        }
        field(7; Surname; Text[30])
        {
            Description = 'Stores the surname of the student in the database';
            NotBlank = true;
        }
        field(8; "Other Names"; Text[30])
        {
            Description = 'Stores the other names of the student in the database';
            NotBlank = true;
        }
        field(9; "Faculty Admitted To"; Code[20])
        {
            Description = 'Stores the faculty the student is admitted to';
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('FACULTY'));
        }
        field(10; "Degree Admitted To"; Code[20])
        {
            Description = 'Stores the degree the student is admitted to';
            NotBlank = true;
            TableRelation = Programme.Code;

            trigger OnValidate()
            begin
                Programme.Reset;
                if Programme.Get("Degree Admitted To") then begin
                    //"Faculty Admitted To":=Programme."Base Date";
                end;
            end;
        }
        field(11; "Date Of Birth"; Date)
        {
            Description = 'Stores the date of birth of the student in the database';
            NotBlank = true;
        }
        field(12; Gender; Option)
        {
            Description = 'Stores the gender of the student in the database';
            NotBlank = true;
            OptionMembers = " ",Male,Female,Intersex;
        }
        field(13; "Marital Status"; Option)
        {
            Description = 'Stores the marital status of the student in the database';
            NotBlank = true;
            OptionCaption = 'Single,Married,Separeted';
            OptionMembers = Single,Married,Separeted;
        }
        field(14; "Spouse Name"; Text[30])
        {
            Description = 'Stores the name of the spouse in the database';
        }
        field(15; "Spouse Address 1"; Text[30])
        {
            Description = 'Stores the first line of the spouse address in the database';
        }
        field(16; "Spouse Address 2"; Text[30])
        {
            Description = 'Stores the second line of the spouse address in the database';
        }
        field(17; "Spouse Address 3"; Text[30])
        {
            Description = 'Stores the third line of the spouse address in the database';
        }
        field(18; "Place Of Birth Village"; Code[20])
        {
            Description = 'Stores the village place of birth in the database';
            NotBlank = true;
        }
        field(19; "Place Of Birth Location"; Code[20])
        {
            Description = 'Stores the location place of birth in the databasse';
            NotBlank = true;
        }
        field(20; "Place Of Birth District"; Code[20])
        {
            Description = 'Stores thdistrict place of birth in the database';
            NotBlank = true;
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Districts));
        }
        field(21; "Name of Chief"; Text[30])
        {
            Description = 'Stores the name of the chief in the database';
            NotBlank = true;
        }
        field(22; "Nearest Police Station"; Text[30])
        {
            Description = 'Stores the name of the nearest police station in the database';
            NotBlank = true;
        }
        field(23; Nationality; Code[20])
        {
            Description = 'Stores the nationality of the student being admitted in the database';
            NotBlank = true;
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Nationality));
        }
        field(24; Religion; Code[20])
        {
            Description = 'Stores the religion of the student in the database';
            NotBlank = true;
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Religions));
        }
        field(25; "Correspondence Address 1"; Text[100])
        {
            Description = 'Stores the first line of the correspondence address in the database';
            NotBlank = true;
        }
        field(26; "Correspondence Address 2"; Text[100])
        {
            Description = 'Stores the second line of the correspondence address in the database';
            NotBlank = true;
        }
        field(27; "Correspondence Address 3"; Text[100])
        {
            Description = 'Stores the third line of the correspondence address in the database';
            NotBlank = true;
        }
        field(28; "Telephone No. 1"; Text[30])
        {
            Description = 'Stores the first telephone number of the student in the database';
        }
        field(29; "Telephone No. 2"; Text[30])
        {
            Description = 'Stores the second telephone number of the student in the database';
        }
        field(30; "Fax No."; Text[30])
        {
            Description = 'Stores the fax number of the student in the database';
        }
        field(31; "E-Mail"; Text[80])
        {
            Description = 'Stores the email address of the student in the database';
        }
        field(301; "Alternate E-Mail"; Text[200])
        {
            Description = 'Stores the email address of the student in the database';
        }
        field(32; "Mother Alive Or Dead"; Option)
        {
            Description = 'Stores the status of the mother in the database';
            OptionMembers = Alive,Deceased,"Not Applicable";
        }
        field(33; "Mother Full Name"; Text[30])
        {
            Description = 'Stores the full name of the mother in the database';
        }
        field(34; "Father Alive Or Dead"; Option)
        {
            Description = 'Stores the status of the father in the database';
            OptionMembers = Alive,Deceased,"Not Applicable";
        }
        field(35; "Father Full Name"; Text[30])
        {
            Description = 'Stores the full name of the father in the database';
        }
        field(36; "Guardian Full Name"; Text[30])
        {
            Description = 'Stores the full name of the guardian in the database';
        }
        field(37; "Mother Occupation"; Text[30])
        {
            Description = 'Stores the Occupation of the Mother in the databae';
        }
        field(38; "Father Occupation"; Text[30])
        {
            Description = 'Stores the occupation of the father in the database';
        }
        field(39; "Guardian Occupation"; Text[30])
        {
            Description = 'Stores the occupation of the guardian in the database';
        }
        field(40; "Former School Code"; Code[500])
        {
            Description = 'Stores the reference to the former school in the database';
            NotBlank = true;
            // TableRelation = "Application Setup Fmr School".Code;
        }
        field(41; "Index Number"; Code[20])
        {
            Description = 'Stores the index number of the student in the database';
            NotBlank = true;
        }
        field(42; "Mean Grade"; Code[20])
        {
            Description = 'Stores the mean grade of the student in the database';
            NotBlank = true;
        }
        field(43; "Physical Impairment Details"; Text[200])
        {
            Description = 'Stores the details of any physical impairment by the student';
        }
        field(44; "Communication to University"; Text[200])
        {
            Description = 'Stores the any information useful to communicate to the university';
        }
        field(45; Photo; Media)
        {
            Description = 'Stores the image of the student in the database';
        }
        field(46; Height; Decimal)
        {
            Description = 'Stores the height of the student';
        }
        field(47; Weight; Decimal)
        {
            Description = 'Stores the wieght of the student';
        }
        field(48; "Without Glasses R.6"; Decimal) { }
        field(49; "Without Glasses L.6"; Decimal) { }
        field(50; "With Glasses R.6"; Decimal) { }
        field(51; "With Glasses L.6"; Decimal) { }
        field(52; "Hearing Right Ear"; Decimal) { }
        field(53; "Hearing Left Ear"; Decimal) { }
        field(54; "Condition Of Teeth"; Text[30]) { }
        field(55; "Condition Of Throat"; Text[30]) { }
        field(56; "Condition Of Ears"; Text[30]) { }
        field(57; "Condition Of Lymphatic Glands"; Text[30]) { }
        field(58; "Condition Of Nose"; Text[30]) { }
        field(59; "Circulatory System Pulse"; Text[30]) { }
        field(60; "Examining Officer"; Text[30]) { }
        field(61; "Medical Exam Date"; Date) { }
        field(62; "Medical Details Not Covered"; Text[200]) { }
        field(63; "Emergency Consent Relationship"; Code[20])
        {
            NotBlank = true;
            TableRelation = Relative.Code;
        }
        field(64; "Emergency Consent Full Name"; Text[30])
        {
            NotBlank = true;
        }
        field(65; "Emergency Consent Address 1"; Text[30])
        {
            NotBlank = true;
        }
        field(66; "Emergency Consent Address 2"; Text[30]) { }
        field(67; "Emergency Consent Address 3"; Text[30]) { }
        field(68; "Emergency Date of Consent"; Date)
        {
            NotBlank = true;
        }
        field(69; "Emergency National ID Card No."; Code[20])
        {
            Description = 'Stores the national identity card number of the person who consented to the emergency operation';
            NotBlank = true;
        }
        field(70; "Declaration Full Name"; Text[30])
        {
            Description = 'Stores the full name of the person who witnessed the declaration';
            NotBlank = true;
        }
        field(71; "Declaration Relationship"; Code[20])
        {
            Description = 'Stores the relation between the applicant and the witness';
            NotBlank = true;
            TableRelation = Relative.Code;
        }
        field(72; "Declaration National ID No"; Code[20])
        {
            Description = 'Stores the national identity card number of the witness';
            NotBlank = true;
        }
        field(73; "Declaration Date"; Date)
        {
            Description = 'Stores the date when the declaration was signed';
            NotBlank = true;
        }
        field(74; "Acceptance Date"; Date)
        {
            Description = 'Stores the date when the acceptance letter was signed';
        }
        field(75; "Accepted ?"; Option)
        {
            OptionMembers = "","Yes","No";
            // OptionCaption="","Yes","No";
            Description = 'Stores the state of the offer whether it was accepted or rejected';

        }
        field(76; "Family Problem"; Boolean) { }
        field(77; "Health Problem"; Boolean) { }
        field(78; "Overseas Scholarship"; Boolean) { }
        field(79; "Course Not Preference"; Boolean) { }
        field(80; Employment; Boolean) { }
        field(81; "Other Reason"; Text[100]) { }
        field(82; "Home District"; Code[20]) { }
        field(83; "Res. District"; Code[20]) { }
        field(84; Status; Option)
        {
            Description = 'Stores the status  of the admission record in the database';
            OptionMembers = New,Filled,Admitted,Rejected;
        }
        field(814; Occupation; Option)
        {
            Description = 'Stores the status  of the admission record in the database';
            OptionMembers = ,Student,SME;
        }
        field(85; "Declaration ID Number"; Code[20])
        {
            Description = 'Stores the declaration id number';
        }
        field(86; Select; Boolean)
        {
            Description = 'Stores the state of the record in the database';
        }
        field(87; "Stage Admitted To"; Code[20])
        {
            Description = 'Stores the stage that the student is admitted to';
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Degree Admitted To"));
        }
        field(88; "Semester Admitted To"; Code[20])
        {
            Description = 'Stores the semester that the student is to be admitted to';
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Degree Admitted To"));
        }
        field(89; Tribe; Code[20])
        {
            Description = 'Stores the reference to the student tribe in the database';
            // TableRelation = "HR Hiring Criteria"."Application Code";
        }
        field(90; "Settlement Type"; Code[25])
        {
            TableRelation = if ("Admission Type" = const('JAB')) "Settlement Type".Code where("Global Type" = const(KUCCPS))
            else
            "Settlement Type".Code where("Global Type" = const(PSSP));

        }
        field(91; "Intake Code"; Code[25])
        {
            TableRelation = Intake.Code where(Closed = const(false));
        }
        field(92; "ID Number"; Code[20]) { }
        field(63379; "Congregation"; Code[20])
        {

            //TableRelation = Congregation.code;
        }
        field(93; Campus; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50000; "Documents Verified"; Boolean) { }
        field(50001; "Documents Verified By"; Code[50]) { }
        field(50002; "Documents Verification Remarks"; Text[100]) { }
        field(50003; "Space No"; Code[20])
        {
            //  CalcFormula = lookup("Bank Acc. Statement Line".Description where ("Bank Account No."=field("Admission No.")));
            //  FieldClass = FlowField;
        }
        field(50004; "Programme Campus"; Code[20])
        {
            CalcFormula = lookup("Programme Stages"."Campus Code" where("Programme Code" = field("Degree Admitted To"),
                                                                         Code = field("Stage Admitted To")));
            FieldClass = FlowField;
        }
        field(50005; "Confirm Order"; Integer) { }
        field(50006; "Admission Comments"; Text[250]) { }
        field(50007; Salutation; Text[30])
        {
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Titles));

            trigger OnValidate()
            begin
                if (Salutation = 'MISS') or (Salutation = 'MS') or (Salutation = 'MRS') then
                    Gender := Gender::Female
                else
                    Gender := Gender::Male;
            end;
        }
        field(50008; Title; Code[10])
        {
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Titles));
        }
        field(50010; "Knew Through (Other)"; Text[100])
        {

            trigger OnValidate()
            begin
                if "Knew Through (Other)" <> '' then
                    "Knew University Thru" := 'OTHER'
            end;
        }
        field(50011; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('CAMPUS'));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(50012; "Knew University Thru"; Text[30])
        {
            //  TableRelation = Table50022.Field1;
        }
        field(50013; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50014; "Required Certificate"; Option)
        {
            OptionCaption = ' ,Diploma Certicate,Degree Certificate,P1 Certificate,KCSE Certificate';
            OptionMembers = " ","Diploma Certicate","Degree Certificate","P1 Certificate","KCSE Certificate";
        }
        field(50015; "Certificate Institution"; Text[100]) { }
        field(50016; Region; Code[20])
        {
            Description = 'Stores the district or the applicant in the database';
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Counties));
        }
        field(50017; Constituency; Code[20])
        {
            Description = 'Stores the district or the applicant in the database';
            TableRelation = "Academics Central Setups"."Title Code" where(Category = filter(Constituencies));
        }
        field(50018; "Print Provisional"; Boolean) { }
        field(50019; "Mode of Study"; Code[50])
        {
            TableRelation = "Student Types".Code;
        }

        field(50021; "Mother Contacts"; Code[20]) { }
        field(50022; "Father Contacts"; Code[20]) { }
        field(50023; "Gurdian Contacts"; Code[20]) { }
        field(50024; "Entry Level"; Option)
        {
            OptionCaption = ' ,P1,Diploma,KCSE';
            OptionMembers = " ",P1,Diploma,KCSE;
        }

        field(50026; "Index Number Year"; Integer) { }
        field(50027; "Online Activated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50028; Password; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Password Reset Token"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Resident ?"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Resident,Non-Resident';
            OptionMembers = ,Resident,"Non-Resident";
        }
        field(50031; "Resident Address"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "QR Code"; Blob)
        {
            DataClassification = ToBeClassified;


        }
        field(50056; "QR Code Image"; Media)
        {
            // DataClassification = ToBeClassified;
            FieldClass = FlowFilter;

            trigger OnValidate()
            begin
                GenerateBarCode;
            end;
        }
        field(50033; "Registration Details Updated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Tuition Fees"; Decimal)
        {
            CalcFormula = sum("Fee By Stage"."Break Down" where("Programme Code" = field("Degree Admitted To"),
                                                                 "Stage Code" = field("Stage Admitted To"),
                                                                 "Settlemet Type" = field("Settlement Type")));
            FieldClass = FlowField;
        }
        field(50035; "Charges Fees"; Decimal)
        {
            CalcFormula = sum("Stage Charges".Amount where("Programme Code" = field("Degree Admitted To"),
                                                            "Stage Code" = field("Stage Admitted To"),
                                                            "Settlement Type" = field("Settlement Type")));
            FieldClass = FlowField;
        }
        field(50036; "Paid Fees"; Decimal)
        {
            CalcFormula = sum("Bank Transactions Buffer".Amount where("Student No." = field("Admission No.")));
            FieldClass = FlowField;
        }
        field(50037; "Update Delta"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Student No"; Code[20])
        {
            CalcFormula = lookup(Customer."No." where("Application No." = field("Admission No.")));
            FieldClass = FlowField;
        }
        field(50039; "Booked Space No"; Code[20])
        {
            CalcFormula = lookup("Hostel Booking Agents"."Room Space" where(No = field("Admission No."),
                                                                             "Payment Status" = filter(Confirmed)));
            FieldClass = FlowField;
        }
        field(50040; "Allocated Space No"; Code[20])
        {
            CalcFormula = lookup("Students Hostel Rooms"."Space No" where(Student = field("Student No"),
                                                                           Cleared = const(False),
                                                                           Semester = field("Semester Admitted To"),
                                                                           Billed = const(True)));
            FieldClass = FlowField;
        }
        field(50041; "Printed No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Printed Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Games"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Club Society"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Marketing Strategy"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Other marketing strategy"; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "Extra Information"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "Birth Certificate No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "Disabled?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "School Code"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Programme."School Code" where(Code = field("Degree Admitted To")));
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(3));
        }
        field(50051; "Remarks"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Birth Certificate No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50053; "Password Token Expired?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "Student Exist"; Boolean)
        {

            FieldClass = FlowField;
            CalcFormula = exist(Customer where("No." = field("Admission No.")));
        }
        field(50055; "Student Ledger Exist"; Boolean)
        {

            FieldClass = FlowField;
            CalcFormula = exist("Cust. Ledger Entry" where("Customer No." = field("Admission No.")));
        }
        field(50057; "Passport No."; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50058; "Programme Level"; Option)
        {
            OptionCaption = ' ,Certificate,Diploma,Undergraduate,Masters,PHD,Professional,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List";
        }
        field(50059; "Sponsorship Type"; Option)
        {
            OptionMembers = Self,Organization,Individual;
        }
        field(50060; "Former Student?"; boolean) { }
        field(50061; "Former Student No"; Code[50]) { }
        field(50062; "Ethnicity"; Code[50]) { }
    }

    keys
    {
        key(Key1; "Admission No.")
        {
            Clustered = true;
        }
        key(Key2; "Confirm Order") { }
    }

    fieldgroups { }

    trigger OnModify()
    begin
        "Update Delta" := true;
    end;

    var
        Programme: Record Programme;


    procedure GenerateBarCode()
    var
        client: HttpClient;
        response: HttpResponseMessage;
        instreams: InStream;
        PictureUrl: Text[300];
    begin

        PictureURL := 'http://barcodes4.me/barcode/qr/myfilename.png?ecclevel=4&size=3&value=' + "Admission No.";
        client.Get(PictureURL, response);
        Response.Content().ReadAs(instreams);

        "QR Code Image".ImportStream(instreams, 'Picture From URL');
        // CalcFields("QR Code");


    end;
}

