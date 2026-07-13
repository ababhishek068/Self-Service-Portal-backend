Table 50089 "Student Types"
{


    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; Remarks; Text[150]) { }
        field(4; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,Post Graduate Diploma,PHD,Professional,Pre-University,Course List';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,"Post Graduate Diploma",PHD,Professional,"Pre-University","Course List";
        }
        field(5; "Claim Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Exam Semester"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code;
        }
        field(7; "Current Semester"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code;
        }
        field(8; "Mode of Study"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
        }
        field(9; "Maximum Semester CF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Stud Count"; Integer)
        {
            CalcFormula = count("Student Units" where("Mode of Study" = field(Code),
                                                       Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(11; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(12; "Hostel Booking"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code;
        }
        field(22; "Evaluation Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Evaluation End Date"; Date)
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
}

