Table 50013 Programme
{
    DrillDownPageID = "Programme List";
    LookupPageID = "Programme List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[200]) { }
        field(3; "Minimum Capacity"; Decimal) { }
        field(4; "Maximum Capacity"; Decimal) { }
        field(5; "Billing By"; Option)
        {
            OptionMembers = "By Stage","Subject",Both;
        }
        field(6; "Total Income"; Decimal)
        {
            CalcFormula = sum("Student Charges"."Amount Paid" where(Programme = field(Code),
                                                                     Semester = field("Semester Filter"),
                                                                     Date = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Student Registered"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Posted" = filter(true),
                                                             "Cust Exist" = filter(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(9; Registered; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Stage = field("Stage Filter"),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Status = field(Status),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; Paid; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Total Paid" = filter(>= 1.700),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Registered Part Time"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Reversed = const(false),
                                                             "Student Type" = const("Part Time"),
                                                             "Settlement Type" = filter(<> ''),
                                                             "Intake Code" = field("Intake Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Paid Part Time"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Student Type" = const("Part Time"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Status = field(Status),
                                                             Reversed = const(false),
                                                             "Intake Code" = field("Intake Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Registered Full Time"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Stage = field("Stage Filter"),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Status = field(Status),
                                                             Reversed = const(false),
                                                             "Intake Code" = field("Intake Filter"),
                                                             "Student Type" = const("Full Time")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(15; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(16; "School Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('SCHOOL'));
        }
        field(17; Budget; Integer) { }
        field(18; "Full Time Budget"; Decimal)
        {
            CalcFormula = sum("Programme Stages"."Full Time Budget" where("Programme Code" = field(Code)));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(19; "Part Time Budget"; Decimal)
        {
            CalcFormula = sum("Programme Stages"."Part Time Budget" where("Programme Code" = field(Code)));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;
        }
        field(20; Status; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = " ",Registration,Current,Alluminae,Dropped;
        }
        field(21; "Total Income (Rcpt)"; Decimal)
        {
            CalcFormula = sum("Receipt Items".Amount where(Programme = field(Code),
                                                            Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(22; "Total Billing"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where(Programme = field(Code),
                                                              Semester = field("Semester Filter"),
                                                              Date = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; Priority; Option)
        {
            OptionCaption = '1,2';
            OptionMembers = "1","2";
        }
        field(24; "Stage Filter"; Code[100])
        {
            Caption = 'Year Filter';
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code;
        }

        field(26; "Reg Prefix"; Code[20]) { }
        field(27; "Mandatory Units"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field(Code),
                                                        "Unit Type" = const(Core)));
            FieldClass = FlowField;
        }
        field(28; "Base Date"; Date) { }
        field(29; "Grace Period"; DateFormula) { }
        field(30; "Student Type Filter"; Code[100])
        {
            FieldClass = FlowFilter;
            TableRelation = "Settlement Type".Code;
        }
        field(31; "Min No. of Courses"; Integer) { }
        field(32; "Max No. of Courses"; Integer) { }
        field(33; Category; Option)
        {
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List,Post Graduate Diploma';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List","Post Graduate Diploma";
        }
        field(34; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Code),
                                                         "Stage Code" = field("Stage Filter"));
        }
        field(35; "Min Pass Units"; Integer) { }
        field(36; "Time Table"; Boolean)
        {

            trigger OnValidate()
            begin
                Units.Reset;
                Units.SetRange(Units."Programme Code", Code);
                if Units.Find('-') then begin
                    Units.ModifyAll(Units."Time Table", "Time Table");

                end;
            end;
        }
        field(37; "Status Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'Registration,Current,Alluminae,Dropped Out,Differed,Suspended,Expulsion,Discontinued,Deferred,Deceased,Transferred';
            OptionMembers = Registration,Current,Alluminae,"Dropped Out",Differed,Suspended,Expulsion,Discontinued,Deferred,Deceased,Transferred;
        }
        field(38; "Date created"; Date) { }
        field(39; "No. Of Units Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(40; "Graduation Units"; Integer) { }
        field(80; "Teaching Weeks"; Integer) { }
        field(41; "Minimum Grade"; Code[20])
        {
            TableRelation = "Application Setup Grade".Code;
        }
        field(42; "Minimum Points"; Decimal) { }
        field(43; "Settlement Type Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Settlement Type".Code;
        }
        field(50060; "Active Students"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Customer where(Status = filter(Current | Registration), "Current Programme" = field(Code)));
        }
        field(45; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(46; "Opening Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(47; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(48; "Male Count"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             Gender = filter(Male),
                                                             "Settlement Type" = filter(<> ''),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(49; "Female Count"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             Gender = filter(Female),
                                                             "Settlement Type" = filter(<> ''),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(50; "Intake Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Intake.Code;
        }
        field(51; "Exam Category"; Code[20])
        {
            TableRelation = "Exam Category".Code;
        }
        field(96; "Exam Date"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(97; "Programme Units"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(98; "Total JAB Female"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             Gender = filter(Female),
                                                             "Settlement Type" = filter('KUCCPS'),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(99; "Total JAB Male"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             Gender = filter(Male),
                                                             "Settlement Type" = filter('KUCCPS'),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(100; "Total SSP Female"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             Gender = filter(Female),
                                                             "Settlement Type" = filter(<> 'KUCCPS'),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(101; "Total SSP Male"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             Gender = filter(Male),
                                                             "Settlement Type" = filter(<> 'KUCCPS'),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(102; "Study Year Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Exam Results".Programme;
        }
        field(103; "Norminal Registered"; Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(104; "Tuition Fees"; Decimal)
        {
            CalcFormula = sum("Stage Charges".Amount where("Programme Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(50000; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50002; "Department Name"; Text[150])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Department Code"),
                                                               "Dimension Code" = filter('DEPARTMENT')));
            FieldClass = FlowField;
        }
        field(50004; "Common Units"; Integer) { }
        field(50005; "Core Units"; Integer) { }
        field(50006; Electives; Integer) { }
        field(50007; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50008; "Unit Fee"; Decimal) { }
        field(50009; "Old Code"; Code[20]) { }
        field(50010; "Special Programme"; Boolean) { }
        field(50011; "Tuition Exists"; Boolean)
        {
            CalcFormula = exist("Fee By Stage" where("Programme Code" = field(Code),
                                                      "Break Down" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(50012; "Total Regular"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             "Settlement Type" = filter('KUCCPS'),
                                                             Reversed = filter(false)));
            FieldClass = FlowField;
        }
        field(50013; "Total SSP"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             "Settlement Type" = filter(<> 'KUCCPS'),
                                                             Reversed = filter(false)));
            Description = '<>s';
            FieldClass = FlowField;
        }
        field(50014; Duration; Decimal) { }
        field(50015; Prefix; Code[20]) { }
        field(50016; "Entry Tution Fees"; Decimal) { }
        field(50017; "Entry Charges"; Decimal)
        {
            CalcFormula = sum("New Student Charges".Amount where("Programme Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(50018; Y1S1; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y1S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50019; Y1S2; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y1S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50020; Y2S1; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y2S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50021; Y2S2; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y2S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50022; Y3S1; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y3S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50023; Y3S2; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y3S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50024; Y4S1; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y4S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50025; Y4S2; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y4S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50026; "Release Online Results"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Dept Name"; Text[100])
        {
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Department Code")));
            FieldClass = FlowField;
        }
        field(50028; "Graduation Counter"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50029; Y1S3; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y1S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50030; Y2S3; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y2S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50031; Y3S3; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y3S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50032; Y4S3; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y4S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(50033; "Programme Duration(Y)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50134; "Programme Duration Code"; option)
        {
            OptionMembers = Week,Month,Year;
        }
        field(50034; "Retake Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Charge.Code;
        }
        field(50035; Y1S1F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y1S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50036; Y1S2F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y1S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50037; Y2S1F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y2S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50038; Y2S2F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y2S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50039; Y3S1F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y3S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50040; Y3S2F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y3S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50041; Y4S1F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y4S1'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50042; Y4S2F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y4S2'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50043; Y1S3F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y1S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50044; Y2S3F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y2S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50045; Y3S3F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y3S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50046; Y4S3F; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             Stage = const('Y4S3'),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Units Taken" = filter(> 0),
                                                             "Cust Exist" = filter(> 0),
                                                             Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(50047; "Application Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "Old Carriculum"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "GSSP Tuition"; Decimal)
        {
            CalcFormula = sum("Fee By Stage"."Break Down" where("Programme Code" = field(Code),
                                                                 "Stage Code" = filter('Y1S1'),
                                                                 "Settlemet Type" = const('GSSP')));
            FieldClass = FlowField;
        }
        field(50050; "PSSP Tuition"; Decimal)
        {
            CalcFormula = sum("Fee By Stage"."Break Down" where("Programme Code" = field(Code),
                                                                 "Stage Code" = filter('Y1S1'),
                                                                 "Settlemet Type" = const('PSSP')));
            FieldClass = FlowField;
        }

        field(50052; Dean; Code[20])
        {
            CalcFormula = lookup("Dimension Value".DEAN where(Code = field("School Code")));
            FieldClass = FlowField;
        }
        field(50053; "Final Remark"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'CLASSIFIED,GRADUATE';
            OptionMembers = CLASSIFIED,GRADUATE;
        }
        field(50054; "Minimum Units Per Year"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50055; "Application Fee Charge Code"; code[20])
        {
            TableRelation = Charge.code;
            DataClassification = ToBeClassified;
        }
        field(50056; "Thesis Charge Code"; code[20])
        {
            TableRelation = Charge.code;
            DataClassification = ToBeClassified;
        }
        field(50057; "Main Programme Code"; code[20])
        {
            // TableRelation = "Main Programmes".Code;
            DataClassification = ToBeClassified;
        }
        field(50077; "Programme Cluster"; code[20])
        {
            //  TableRelation = "Programme Cluster".code;
            DataClassification = ToBeClassified;
        }
        field(50058; "Minimum Class Attendance %"; Decimal)
        {

            DataClassification = ToBeClassified;
        }
        field(50059; "Total Class Attendance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50061; "CUE Code"; code[20]) { }
        field(50062; "Minimum Free Electives"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50063; "Minimum Gen. Education Electives"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(213; "Admissions Letter Report ID"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(50079; "Student Booked"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             Reversed = const(false),
                                                             "Settlement Type" = field("Settlement Type Filter"),
                                                             "Campus Code" = field("Campus Filter"),
                                                             "Posted" = filter(false),
                                                             "Cust Exist" = filter(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(216; "Short Course"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(217; "Career Prospect"; text[500])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }

    }

    fieldgroups { }

    trigger OnDelete()
    begin

        CReg.Reset;
        CReg.SetRange(CReg.Programme, xRec.Code);
        if CReg.Find('-') then Error('Please note that you can not edit used Programme');

        ProgStages.Reset;
        ProgStages.SetRange(ProgStages."Programme Code", Code);
        if ProgStages.Find('-') then ProgStages.DeleteAll;

        ProgSem.Reset;
        ProgSem.SetRange(ProgSem."Programme Code", Code);
        if ProgSem.Find('-') then ProgSem.DeleteAll;
    end;

    trigger OnInsert()
    begin
        //ERROR('Please note you dont have the rights to add the programme');
    end;

    trigger OnModify()
    begin
        if xRec.Code <> Code then begin
            CReg.Reset;
            CReg.SetRange(CReg.Programme, Code);
            if CReg.Find('-') then Error('Please note that you can not edit used programme');
        end;
    end;

    trigger OnRename()
    begin
        CReg.Reset;
        CReg.SetRange(CReg.Programme, xRec.Code);
        // IF CReg.FIND('-') THEN ERROR('Please note that you can not edit used Programme');
    end;

    var
        Units: Record "Units/Subjects";
        CReg: Record "Course Registration";
        ProgStages: Record "Programme Stages";
        ProgSem: Record "Programme Semesters";
}

