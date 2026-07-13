table 50323 "Cleaners"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Names; text[120])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "ID Number"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(4; Gender; option)
        {
            OptionMembers = ,Male,Female;
            DataClassification = ToBeClassified;

        }
        field(5; "Cleaning Company"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Active Cleaning Company"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cleaning Company".Active where(No = field("Cleaning Company")));

        }
    }

    keys
    {
        key(PK; No, "Cleaning Company")
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