table 50317 "Research Questionares Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Research Quiz Header List";
    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Stake Holder"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("Account Type" = filter(Stakeholder));
            trigger OnValidate()
            var
                Cust: Record customer;
            begin
                if Cust.get("Stake Holder") then
                    "Partner Category" := cust."Partner Category";
            end;
        }
        field(3; "Research No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Jobs."No." where(Status = filter(Research));

        }
        field(4; Remarks; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Partner Category"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Partner Category";

        }
        field(6; "Results Type"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Research Results Type"."Results Type";

        }

    }

    keys
    {
        key(Key1; No)
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