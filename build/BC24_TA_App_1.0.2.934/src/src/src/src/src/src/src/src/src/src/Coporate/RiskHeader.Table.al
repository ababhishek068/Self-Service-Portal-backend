table 50129 "Risk Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Department Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));

        }
        field(3; Period; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Financial Periods"."Period Code";

        }
        field(4; "No. Series"; code[20]) { }

    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        GenLedgerSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
        HREmp: Record "HR-Employee";
        UserSetup: record "User Setup";
    begin
        if "No" = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Risk Nos");
           "No":= NoSeriesMgt.GetNextNo(GenLedgerSetup."Risk Nos",  0D, true);

        end;
        if UserSetup.get(Database.UserId) then
            if HREmp.get(UserSetup."Employee No.") then
                "Department Code" := HREmp."Department Code";
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