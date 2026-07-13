Table 50277 "Time Table Header"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Programme; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(3; Stage; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Programme Stages".Code;
        }
        field(4; Semester; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code;
        }
        field(5; Campus; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(6; Day; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Day Of Week".Day;
        }
        field(7; Lecturer; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." where(Lecturer = filter(True));
        }
        field(8; "Lecturer Room"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Lecture Rooms".Code;
        }
        field(20; "Max Hours Continiously"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Max Hours Weekly"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Max Days Per Week"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Max Lecturer Hours Daily"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Max Lecturer Days Per Week"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Max Class Capacity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Max Class Weekly"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(27; Released; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(37; "User Preset Classes"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(28; "Released By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29; "Released On"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "Last Opened By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; "Last Opened On"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "Mode of Study"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Student Types".Code;
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
        if GenSetup.Get() then begin
            GenSetup."Current TT Code" := Code;
            GenSetup.Modify;
        end;
    end;

    trigger OnModify()
    begin
        if GenSetup.Get() then begin
            GenSetup."Current TT Code" := Code;
            GenSetup.Modify;
        end;
    end;

    trigger OnRename()
    begin
        if GenSetup.Get() then begin
            GenSetup."Current TT Code" := Code;
            GenSetup.Modify;
        end;
    end;

    var
        GenSetup: Record "General Set-Up";
}

