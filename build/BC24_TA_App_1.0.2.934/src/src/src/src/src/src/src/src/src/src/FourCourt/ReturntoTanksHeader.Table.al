table 50162 "Return to Tanks Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Description"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Date"; Date)
        {
            DataClassification = ToBeClassified;

        }


        field(6; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));

        }
        field(7; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shift Allocation".No where(Posted = filter(False));

        }
        field(12; "No. Series"; code[20])
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
            GenLedgerSetup.TestField(GenLedgerSetup."Return to Stock Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Return to Stock Nos",  0D, true);

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