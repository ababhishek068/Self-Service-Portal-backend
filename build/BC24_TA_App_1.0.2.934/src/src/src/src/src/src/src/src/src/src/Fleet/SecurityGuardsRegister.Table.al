table 50294 "Security Guards Register"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Guard No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Security Guards".No where("Active Security Company" = filter(true));
            trigger OnValidate()
            var
                Guards: Record "Security Guards";
            begin
                guards.reset;
                guards.setrange(Guards.No, "Guard No");
                if Guards.find('-') then
                    "Guard Name" := Guards.Names;
            end;

        }
        field(3; "Guard Name"; text[150])
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
            CalcFormula = lookup("Security Guards".Supervisor where(No = field("Guard No")));

        }
        field(7; "Active Security Company"; text[200])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Security Company".Description where(Active = filter(true)));

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