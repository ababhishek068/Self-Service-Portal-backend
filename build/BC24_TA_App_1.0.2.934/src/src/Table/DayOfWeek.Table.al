Table 50042 "Day Of Week"
{

    fields
    {
        field(1; Day; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Start Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "End Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Remarks; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Hours; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Programme Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(8; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(9; "Unit Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Filter"),
                                                         "Stage Code" = field("Stage Filter"));
        }
        field(10; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(11; "Lecture Room Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Lecture Rooms".Code;
        }
        field(12; "Class Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Course Classes".Code where(Programme = field("Programme Filter"),
                                                         Stage = field("Stage Filter"));
        }
        field(13; "Student Type"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = ' ,Full Time,Part Time,Distance Learning';
            OptionMembers = " ","Full Time","Part Time","Distance Learning";
        }
        field(14; "Lecturer Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "HR-Employee"."No." where(Lecturer = const(true));
        }
        field(15; "Unit Class Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Units Classes".Code where(Programme = field("Programme Filter"),
                                                        Stage = field("Stage Filter"),
                                                        Unit = field("Unit Class Filter"));
        }

        field(17; "Department Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(18; Exams; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Exam No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(21; "Used Count"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; Active; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", Day)
        {
            Clustered = true;
        }
        key(Key2; "Used Count") { }
    }

    fieldgroups { }
}

