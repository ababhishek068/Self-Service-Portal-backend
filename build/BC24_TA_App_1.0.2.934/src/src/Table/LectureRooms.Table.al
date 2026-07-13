Table 50057 "Lecture Rooms"
{


    fields
    {
        field(1; "Building Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Building.Code;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; Description; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Minimum Capacity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Maximum Capacity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Remarks; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Facilities; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Reserve For"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;

            trigger OnValidate()
            begin
                if "Reserve For" = '' then Reserved := false else Reserved := true;
                Modify;
            end;
        }
        field(9; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Security ID";
        }
        field(10; "No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Room Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Lecture Hall,Lab';
            OptionMembers = "Lecture Hall",Lab;
        }
        field(12; "Lab No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Time Table Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Day Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(15; "Lesson Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(16; "Used Count"; Integer)
        {
            CalcFormula = count("Time Table" where("Day of Week" = field("Day Filter"),
                                                    "Lecture Room" = field(Code),
                                                    Period = field("Lesson Filter"),
                                                    "Mode of Study" = field("Mode of Study Filter")));
            FieldClass = FlowField;
        }
        field(17; "Global Dimension 1"; Code[50])
        {
            CalcFormula = lookup(Building."Global Dimension 1 Code" where(Code = field("Building Code")));
            FieldClass = FlowField;
        }
        field(18; Reserved; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Reserve For Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Reserve For"));

            trigger OnValidate()
            begin
                if "Reserve For" = '' then Reserved := false else Reserved := true;
                Modify;
            end;
        }
        field(20; "Reseverd Count"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Reserved Room" = field(Code),
                                                        "Semester Filter" = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(21; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(22; "Mode of Study Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Student Types".Code;
        }
    }

    keys
    {
        key(Key1; "Building Code", "Code")
        {
            Clustered = true;
        }
        key(Key2; "Time Table Count") { }
    }

    fieldgroups { }
}

