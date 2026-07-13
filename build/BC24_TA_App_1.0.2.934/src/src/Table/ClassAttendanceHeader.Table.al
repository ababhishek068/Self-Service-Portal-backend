Table 50104 "Class Attendance Header."
{
    //DrillDownPageID = "Class Attendance List";
    // LookupPageID = "Class Attendance List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Programe Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(3; "Stage Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programe Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(4; "Semester Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code;
        }
        field(5; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programe Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; "Week Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Weeks Codes".Code;
        }
        field(7; "Lecturer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
        }
        field(8; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Posted Count"; Integer)
        {
            CalcFormula = count("Class Attendance Lines" where(Code = field(Code),
                                                                Posted = const(true)));
            FieldClass = FlowField;
        }
        field(10; "Lesson Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Campus Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }

        field(12; "Mode of Study"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
        }
        field(13; "Sequence No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Counter; Integer)
        {
            CalcFormula = count("Class Attendance Header." where("Unit Code" = field("Unit Code"),
                                                                  "Week Code" = field("Week Code"),
                                                                  "Lecturer Code" = field("Lecturer Code"),
                                                                  "Campus Code" = field("Campus Code"),
                                                                  "Semester Code" = field("Semester Code")));
            FieldClass = FlowField;
        }
        field(15; "Status"; Option)
        {
            OptionMembers = New,"Pending Approval",Approved;
            DataClassification = ToBeClassified;
        }
        field(16; "Posted"; boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Posting Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Day Code"; code[20])
        {
            TableRelation = "Day Of Week".Day;
            DataClassification = ToBeClassified;
        }
        field(19; "Present Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Class Attendance Lines" where(Code = field(Code), "Attendance Type" = filter(Present)));
        }
        field(22; "Absent Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Class Attendance Lines" where(Code = field(Code), "Attendance Type" = filter(Absent)));
        }
        field(23; "Section"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Course Classes".Code;
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

    trigger OnInsert()
    begin
        if Code = '' then begin
            GenSetup.Get;
            GenSetup.TestField(GenSetup."Class Allocation Nos.");
            Code:=NoSeriesMgt.GetNextNo(GenSetup."Class Allocation Nos.", 0D, true);
        end;
    end;

    var
        GenSetup: Record "General Set-Up";
        NoSeriesMgt: Codeunit "No. Series";
}

