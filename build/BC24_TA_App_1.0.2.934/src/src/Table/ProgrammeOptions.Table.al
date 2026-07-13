Table 50071 "Programme Options"
{
    DrillDownPageID = "Programme Option";
    LookupPageID = "Programme Option";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; "Stage Code"; Code[20])
        {
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Code"));
        }
        field(3; "Code"; Code[50])
        {
            NotBlank = true;
        }
        field(4; Desription; Text[150]) { }
        field(5; "Graduation Units"; Integer) { }
        field(6; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(7; "Units Count"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field("Programme Code"),
                                                        "Programme Option" = field(Code)));
            FieldClass = FlowField;
        }
        field(8; "Minimum Pass Cores"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Minimum Pass Free Elective"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(82; "Minimum Gen. Elective"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Minmum Pass All"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Option Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Required Unit1"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Code"),
                                                         "Programme Option" = field(Code),
                                                         "Unit Type" = filter(Required | Core));
        }
        field(12; "Required Unit2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Code"),
                                                         "Programme Option" = field(Code),
                                                         "Unit Type" = filter(Required | Core));
        }
        field(13; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(14; "Registered Students"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Options = field(Code),
                                                             Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", "Programme Code", "Stage Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

