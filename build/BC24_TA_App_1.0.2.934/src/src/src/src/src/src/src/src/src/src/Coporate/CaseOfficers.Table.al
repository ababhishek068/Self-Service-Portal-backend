table 50016 "Case Officers"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Case No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Employee No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." where("Investigating Officer" = const(true));
            trigger OnValidate()
            var
                HREmp: record "HR-Employee";
            begin
                if HREmp.get("Employee No") then
                    Name := HREmp."First Name" + ' ' + HREmp."Last Name";
            end;

        }
        field(4; "Name"; text[200])
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; "Case No", "Line No")
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