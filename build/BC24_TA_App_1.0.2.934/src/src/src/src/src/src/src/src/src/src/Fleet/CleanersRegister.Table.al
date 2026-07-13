table 50325 "Cleaners Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Cleaner No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cleaners".No where("Active Cleaning Company" = filter(true));
            trigger OnValidate()
            var
                Guards: Record Cleaners;
            begin
                guards.reset;
                guards.setrange(Guards.No, "Cleaner No");
                if Guards.find('-') then
                    "Name" := Guards.Names;
            end;

        }
        field(3; "Name"; text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Allocated Section"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Security Sections".Code;
        }
        field(6; "Shift Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Security Shift".code;

        }
        field(8; "Supervisor"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Security Guards".Supervisor where(No = field("Cleaner No")));

        }
        field(7; "Active Cleaning Company"; text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cleaning Company".Description where(Active = filter(true)));

        }
        field(9; "Time In"; Time)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Time Out"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Line No", Date, "Shift Code")
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