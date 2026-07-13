Table 50374 "Vendor Contacts"
{
    // DrillDownPageID = UnknownPage70134791;
    //  LookupPageID = UnknownPage70134791;

    fields
    {
        field(1; "Code"; Code[10]) { }
        field(2; "Vendor Code"; Code[10])
        {
            TableRelation = Vendor."No.";
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
        key(Key1; "Code", "Vendor Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if Code = '' then begin
            PPSetup.Get;
            PPSetup.TestField(PPSetup."Vendor Nos.");
            Code:=NoSeriesMgt.GetNextNo(PPSetup."Vendor Nos.", 0D, true);
        end;
    end;

    var
        PPSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

