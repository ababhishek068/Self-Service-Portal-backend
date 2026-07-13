table 50085 "Student Payment Plan Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Semester; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.code;
        }
        field(2; "Installment No"; Integer) { }
        field(3; "Installment Percentage"; Decimal) { }
        field(4; "Due Date"; date) { }
    }

    keys
    {
        key(Key1; Semester, "Installment No")
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