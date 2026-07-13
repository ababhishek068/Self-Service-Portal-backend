table 50262 "Student Status"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Student Status";
    DrillDownPageId = "Student Status";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Students Count"; integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count(Customer where("Academic Status" = field(Code)));
        }
    }

    keys
    {
        key(Key1; code)
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