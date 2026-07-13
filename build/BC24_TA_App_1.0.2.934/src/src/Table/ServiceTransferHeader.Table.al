table 50166 "Service Transfer Header"
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
        field(4; "Service Duty"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Duties".code;
        }
        field(5; "Service Sub Duty"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Sub Duties".code where("Main Duty" = field("Service Duty"));

        }
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
        field(13; "New Service Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Units".code where("Service Region" = field("New Service Region"));

        }
        field(33; "New Service Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

        }
        field(14; "New Service Duty"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Duties".code;
        }
        field(15; "New Service Sub Duty"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Sub Duties".code where("Main Duty" = field("New Service Duty"));

        }
        field(16; "New Service Commander"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No.";
        }
        field(17; "Status"; option)
        {
            Editable = false;
            OptionMembers = New,"Pending Approval",Approved,Cancelled;
        }
        field(18; "Transfer Reason"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(19; "Type of Transfer"; option)
        {
            OptionMembers = Permanent,Detachment,"Course Placement";
        }
        field(20; "Expected Release Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Expected Arrival Date"; Date)
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
            GenLedgerSetup.TestField(GenLedgerSetup."Transfer Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Transfer Nos",  0D, true);

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