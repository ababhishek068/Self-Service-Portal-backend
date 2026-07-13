table 50704 "Shift Allocation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Shift Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Shift";

        }
        field(4; "Station Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

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
        field(16; "Special Discount"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(17; "Special Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(22; "Opened By"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(18; Open; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(19; "Opening Date"; Date)
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
    procedure AssistEdit(OldCust: Record "Shift Allocation"): Boolean
    var
        Cust: Record "Shift Allocation";
        SalesSetup: Record "Fore Court Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        Cust := Rec;
        SalesSetup.Get();
        SalesSetup.TestField("Shift Allocation Nos");
        Cust."No":=NoSeriesMgt.GetNextNo(SalesSetup."Shift Allocation Nos",0D,true);
            Rec := Cust;
            OnAssistEditOnBeforeExit(Cust);
            exit(true);
        end;
    //end;

    local procedure OnAssistEditOnBeforeExit(var Customer: Record "Shift Allocation")
    begin
    end;

    trigger OnInsert()
    var
        GenLedgerSetup: Record "Fore Court Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Shift Allocation Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Shift Allocation Nos", 0D, true);

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