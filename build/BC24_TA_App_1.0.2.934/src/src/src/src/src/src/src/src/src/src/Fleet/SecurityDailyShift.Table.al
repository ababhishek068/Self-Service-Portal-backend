table 50273 "Security Daily Shift"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Shift Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Security Shift";

        }
        field(4; "No. Series"; code[20]) { }
        field(5; "Supervisor Remarks"; text[200]) { }
        field(6; "Administration Remarks"; text[200]) { }

    }

    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        FASetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if No = '' then begin
            FASetup.Get;
            FASetup.TestField("Shift Nos");
            No:=NoSeriesMgt.GetNextNo(FASetup."Shift Nos", 0D, true);
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