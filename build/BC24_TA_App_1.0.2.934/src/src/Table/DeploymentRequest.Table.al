Table 50211 "Deployment Request"
{
    LookupPageId = "Deployment List";

    fields
    {
        field(1; No; Code[50]) { }
        field(2; Description; Text[150]) { }
        field(3; Date; date) { }
        field(4; "Requested Service M/W"; Integer) { }
        field(5; "Availlable Accomodation"; Integer) { }
        field(6; "Requested Start Date"; date) { }
        field(7; "Project End Date"; date) { }
        field(8; "Service Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Service Units".code where("Service Region" = field("Service Region"));

        }
        field(23; "Service Region"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

        }
        field(9; "Service Duties"; Code[20])
        {
            TableRelation = "Service Duties";
        }
        field(10; "Status"; option)
        {
            OptionMembers = New,"Pending Approval",Approved,Cancelled;
            trigger OnValidate()
            begin
                if ((Status = Status::Approved) and ("Document Level" = "Document Level"::Requisition)) then begin
                    Status := Status::New;
                    "Document Level" := "Document Level"::Allocation;
                    Modify();
                end;
            end;
        }
        field(11; "Project Status"; option)
        {
            OptionMembers = ,"Active",Completed,Cancelled;
        }
        field(12; "Posted"; Boolean) { }
        field(13; "Posted By"; code[20]) { }
        field(14; "Date Posted"; date) { }
        field(15; "No. Series"; code[20]) { }
        field(16; "Document Level"; option)
        {
            OptionMembers = Requisition,Allocation,Confirmation;
        }
        field(17; "User ID"; code[30]) { }
        field(18; "Expected Date"; date) { }
        field(19; "Arrival Date"; date) { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        GenLedgerSetup: Record "NYS Service Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin

        if No = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Deployment Nos");
            "No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Deployment Nos", 0D,true);

        end;
        "User ID" := Database.UserId;
    end;

    trigger OnDelete()
    begin
        TestField(Posted, false);
    end;
}

