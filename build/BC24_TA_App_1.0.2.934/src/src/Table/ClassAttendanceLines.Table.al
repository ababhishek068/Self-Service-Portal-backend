Table 50102 "Class Attendance Lines"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("Customer Type" = const(Student));

            trigger OnValidate()
            begin
                if ClassH.Get(Code) then begin
                    Programme := ClassH."Programe Code";
                    Semester := ClassH."Semester Code";
                    Stage := ClassH."Stage Code";
                    "Unit Code" := ClassH."Unit Code";
                    "Week Code" := ClassH."Week Code";
                end;
                if Cust.Get("Student No") then
                    Names := Cust.Name;
            end;
        }
        field(3; Attendance; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Programme; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(5; Semester; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field(Programme));
        }
        field(6; Stage; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field(Programme),
                                                         "Stage Code" = field(Stage));
        }
        field(8; "Week Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Weeks Codes".Code;
        }
        field(9; Names; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Posted by"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Lecturer Code"; Code[20])
        {
            CalcFormula = lookup("Class Attendance Header."."Lecturer Code" where(Code = field(Code)));
            FieldClass = FlowField;
            TableRelation = "HR-Employee"."No." where(Lecturer = const(True));
        }
        field(14; "Attendance Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Present,Absent';
            OptionMembers = " ",Present,Absent;

            trigger OnValidate()
            begin
                if "Attendance Type" = "attendance type"::Present then
                    Attendance := 1
                else
                    Attendance := 0;
            end;
        }
        field(15; "Claim Batch No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Sequence No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Stud Campus"; Code[20])
        {
            CalcFormula = lookup(Customer."Global Dimension 1 Code" where("No." = field("Student No")));
            FieldClass = FlowField;
        }

        field(50001; "Lecturer Present"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Lecturer Absent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", "Student No", "Sequence No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        ClassH: Record "Class Attendance Header.";
        Cust: Record Customer;
}

