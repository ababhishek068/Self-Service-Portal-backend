table 50164 "Dipping Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Dipping Time"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Morning,Evening;

        }

        field(6; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }

        field(8; Description; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(9; "No. Series"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(14; Posted; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

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
    var
        GenLedgerSetup: Record "Fore Court Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Dipping Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Dipping Nos",0D, true);

        end;

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