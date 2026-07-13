table 50167 "Duties Allocation Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Duties Allocation List";
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
        field(3; "Service Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Units".code where("Service Region" = field("Service Region"));

        }
        field(23; "Service Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

        }
        // field(4; "Service Duty"; code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Service Duties".code;
        // }
        // field(5; "Service Sub Duty"; code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Service Sub Duties".code where("Main Duty" = field("Service Duty"));

        // }
        field(6; "Service Commander"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
        }
        field(7; "Start Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(8; "End Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(9; "Posted"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Posting Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(12; "No. Series"; code[20])
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
        GenLedgerSetup: Record "NYS Service Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Duty Allocation Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Duty Allocation Nos",  0D, true);

        end;

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        TestField(Posted, false);
    end;

    trigger OnRename()
    begin

    end;

}