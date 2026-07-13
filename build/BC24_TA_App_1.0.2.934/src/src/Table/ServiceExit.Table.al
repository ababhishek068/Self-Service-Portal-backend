table 50177 "Service Exit"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Service Clearance List";
    fields
    {
        field(1; No; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Service No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Registration Form"."Service Number" where(Status = filter(<> Exited));
            trigger OnValidate()
            var
                RegForm: Record "Registration Form";
            begin
                if RegForm.get("Service No") then
                    Names := RegForm."Full Names";
            end;
        }
        field(3; Names; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; Date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Discharge Reason"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Exit Modes".Code;

        }
        field(6; Remarks; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(7; "No. Series"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Status"; option)
        {
            OptionMembers = New,"Pending Approval",Approved,Cancelled;
        }
        field(9; Posted; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(10; "Date Posted"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Posted By"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Date of Discharge"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Course Undertaken"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
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
            GenLedgerSetup.TestField(GenLedgerSetup."Clearance Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Clearance Nos",  0D, true);

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