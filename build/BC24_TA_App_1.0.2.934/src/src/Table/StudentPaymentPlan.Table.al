table 50251 "Student Payment Plan"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Student No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

        }
        field(2; "Semester"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.code;

        }
        field(3; "Installment No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Installment Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Expected Payment"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100.00;
            MinValue = 0;

        }
        field(7; "Defaulted"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Penalized"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Semester Invoice"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = sum("Student Charges".Amount where("Student No." = field("Student No"), Semester = field(Semester), Recognized = filter(true)));
        }
        field(10; "Last Notif Date"; date) { }
    }

    keys
    {
        key(PK; "Student No", Semester, "Installment No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}