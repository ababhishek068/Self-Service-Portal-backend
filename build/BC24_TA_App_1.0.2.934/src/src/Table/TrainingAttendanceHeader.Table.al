table 50268 "Training Attendance Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Region List";
    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "End Date"; Date)
        {
            DataClassification = ToBeClassified;

        }

        field(5; "Training College"; code[20])
        {
            TableRelation = "Training Colleges".Code;
        }
        field(9; "Training Code"; code[20])
        {
            TableRelation = "Paramilitary Training".Code;
            trigger OnValidate()
            var
                MilTr: Record "Paramilitary Training";
            begin
                MilTr.Reset();
                MilTr.SetRange(Code, "Training Code");
                if MilTr.Find('-') then
                    "Course Description" := MilTr.Description;
            end;
        }
        field(10; "Course Description"; Text[100])
        {
            TableRelation = "Paramilitary Training".Code;
        }
        field(11; "Barrack"; code[20])
        {
            TableRelation = Barracks.code;
        }
        field(12; "Trainer Leader"; code[20]) { }
        field(7; "No. Series"; code[20]) { }
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
            GenLedgerSetup.TestField(GenLedgerSetup."Training Nos");
            "No" := NoSeriesMgt.GetNextNo(GenLedgerSetup."Training Nos", 0D, true);

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