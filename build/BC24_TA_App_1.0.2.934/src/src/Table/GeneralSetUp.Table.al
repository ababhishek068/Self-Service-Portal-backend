Table 50571 "General Set-Up"
{
    fields
    {
        field(1; "Student Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(2; "Registration Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Primary Key"; Code[10]) { }
        field(4; "Receipt Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Defered Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Transaction Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Over Payment Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Pre-Payment Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Allow Posting From"; Date) { }
        field(10; "Allow Posting To"; Date) { }
        field(11; "Unallocated Rcpts Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Batch Receipts Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(13; "Medical Condition Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(14; "Attachment Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(15; "Enquiry Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(16; "Application Fee"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(17; "Clearance Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(18; "Proforma Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(19; "Base Date"; Date) { }
        field(20; "Max Hours Continiously"; Decimal) { }
        field(21; "Max Hours Weekly"; Decimal) { }
        field(22; "Max Days Per Week"; Integer) { }
        field(23; "Max Lecturer Hours Daily"; Decimal) { }
        field(24; "Max Lecturer Days Per Week"; Decimal) { }
        field(25; "Applications Date Line"; Date) { }
        field(26; "Allow UnPaid Hostel Booking"; Boolean) { }
        field(27; "Default Year"; Code[20])
        {
            TableRelation = "Programme Stages".Code;
        }
        field(28; "Impt. Unit"; Code[20]) { }
        field(29; "Impt. Staff"; Code[20]) { }
        field(30; "Impt. Semester"; Code[20]) { }
        field(31; "Impt. Stage"; Code[20]) { }
        field(32; "Impt. RegID"; Code[20]) { }
        field(33; "Impt. Category"; Code[20]) { }
        field(34; "Impt. Programme"; Code[20]) { }
        field(35; "Pass List Label"; Text[250]) { }
        field(36; "Fail List Label"; Text[250]) { }
        field(37; "Supp List Label"; Text[250]) { }
        field(38; "Allow Units Add. in Posted Sem"; Boolean) { }
        field(39; "Cons. Marksheet Key1"; Text[250]) { }
        field(40; "Cons. Marksheet Key2"; Text[250]) { }
        field(41; "Bill Supplimentary Fee"; Boolean) { }
        field(42; "Supplimentary Fee Code"; Code[20])
        {
            TableRelation = Charge.Code;
        }
        field(43; "CDF Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(44; "Helb Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(120; lost; Integer) { }
        field(50000; "Allowed Reg. Fees Perc."; Decimal) { }
        field(50001; "Allow Online Results Access"; Boolean) { }
        field(50002; "Current TT Code"; Code[20]) { }
        field(50050; "Time Table Semester"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Semesters.Code;
        }
        field(50051; "Time Table Campus"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50052; Picture; Blob)
        {
            SubType = Bitmap;
        }
        field(50053; "Library Fines"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50054; "Default Semester"; Code[20])
        {
            TableRelation = Semesters;
        }
        field(50055; "Default Intake"; Code[20])
        {
            TableRelation = Intake.Code;
        }
        field(50056; "Default Academic Year"; Code[20])
        {
            TableRelation = "Academic Year".Code;
        }
        field(50057; "Class Allocation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50058; "Bar Code"; Blob)
        {
            SubType = Bitmap;
        }
        field(50059; "Visitor Number"; Code[20]) { }
        field(50060; "Supplimentray Fees"; Decimal) { }
        field(50061; "Admission Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50062; "Last Bio No"; Integer) { }
        field(50063; "Max Hostel Booking Period"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50064; "Marks Approval Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50066; "Tuition Waiver Nos."; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(50065; "Programme Cap.Declaration Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Programmes Capacity Declaration Numbers';
            TableRelation = "No. Series";
        }
        field(50067; "Application Fee G/Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";

        }
        field(50068; "Portal Reports File Path"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50069; "Generate Reg No (KUCCPS)"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(50169; "Re-Generate Reg No (KUCCPS)"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(50070; "Portal Attachment File Path"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50170; "Students Portal Portal URL"; text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50071; "Allow Units Validation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50072; "Use Campus Prefix on Admission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50073; "Graduation Request Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Graduation Request Numbers';
            TableRelation = "No. Series";
        }
        field(50074; "Allow AutoProgression Stage"; Boolean)
        {
            InitValue = true;
        }
        field(50075; "Registration Number Seperator"; Text[30])
        {
            InitValue = '/';
        }
        field(50076; "Unit Billing Type"; option)
        {
            OptionMembers = ,"Unit Fees Structure","Programme Unit Fee";
        }
        field(50077; "Allow Hostel Booking"; Boolean) { }
        field(50078; "Allow Student Transfer Req"; Boolean) { }
        field(50079; "Allow Student Clearance Req"; Boolean) { }
        field(50080; "Allow Graduation Application"; Boolean) { }
        field(50081; "Results Release Type"; Option)
        {
            OptionMembers = All,"Current Semester";
        }
        field(50082; "Class Attendance Mandatory"; Boolean) { }
        field(50083; "Manual Class Generation"; Boolean) { }
        field(50084; "Exam Grading Type"; Option)

        {
            OptionMembers = Grade,GPA;
        }
        field(50085; "Penalize Late Payment"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Penalize Late Payment" = true then
                    TestField("Penalty Charge Code");
            end;
        }
        field(50086; "Penalty Charge Code"; code[20])
        {
            TableRelation = Charge.code;
        }
        field(50087; "Notify Student on Receipt"; Boolean) { }
        field(50088; "Notify Student on Invoice"; Boolean) { }
        field(50089; "Payment Plan Mandatory"; Boolean) { }
        field(50090; "Notify on Due Payments"; Boolean) { }
        field(50091; "Student Scolorship Nos."; code[20])
        {
            TableRelation = "No. Series";
        }
        field(50092; "Students Enquiry Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50093; "Default Class"; Code[20])
        {
            TableRelation = "Course Classes".Code;
        }
        field(50094; "Allow Only Y1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50095; "Exemption Grade"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Exam Rules".code;
        }
        field(50096; "Exemption Semester"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.code;
        }
        field(50097; "KUCCPS Settlement Type"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Settlement Type".code;
        }
        field(50098; "Prog. Transfer Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50099; "Fee Control Type"; Option)
        {
            OptionMembers = "Fee% Policy","Prev Balance","None";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

