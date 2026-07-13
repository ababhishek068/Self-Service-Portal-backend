Table 50443 "Donor Contacts"
{
    DrillDownPageID = "Donor Contacts List";
    LookupPageID = "Donor Contacts List";

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; "Donor Code"; Code[10])
        {
            TableRelation = Customer."No.";
        }
        field(3; Name; Text[100]) { }
        field(4; Address; Text[100]) { }
        field(5; "Address 2"; Text[100]) { }
        field(6; Email; Text[100]) { }
        field(7; "Telephone No"; Text[100]) { }
        field(8; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; City; Text[30]) { }
        field(10; Contact; Text[50]) { }
    }

    keys
    {
        key(Key1; "Code", "Donor Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Code = '' then begin
            JobSetup.Get;
            JobSetup.TestField(JobSetup."Donor Contact Nos");
            Code:=NoSeriesMgt.GetNextNo(JobSetup."Donor Contact Nos",0D, true);
        end;
    end;

    var
        JobSetup: Record "Jobs-Setup";
        NoSeriesMgt: Codeunit "No. Series";

    procedure InsertDonorNos()
    begin
        if Code = '' then begin
            JobSetup.Get;
            JobSetup.TestField(JobSetup."Donor Contact Nos");
            Code:=NoSeriesMgt.GetNextNo(JobSetup."Donor Contact Nos",  0D,true);
        end;
    end;
}

