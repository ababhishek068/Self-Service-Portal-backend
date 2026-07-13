table 50540 "Company Workplan Header"
{
    fields
    {
        field(1; "Code"; Code[20])
        {
            Editable = false;
        }

        field(2; "Description"; Text[250]) { }

        field(3; "Workplan Code"; Code[20])
        {
            TableRelation = Workplan."Workplan Code.";
        }

        field(4; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(5; "No. Series"; Code[20]) { }

        field(6; "Start Date"; Date) { }

        field(7; "End Date"; Date) { }

        field(8; "Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval","Pending Prepayment";
        }
    }


    keys
    {
        key(Key1; "Code") { }
    }

    fieldgroups { }

    trigger OnInsert()
    var
        CompanyWorkplanHeader: Record "Company Workplan Header";
        //NoSeriesMgt: Codeunit "No. Series";
        PurchaseSetup: Record "Purchases & Payables Setup";
        CWPNosLbl: Label 'CWP-00001';
    begin
        PurchaseSetup.GET;
        //PurchaseSetup.TESTFIELD(PurchaseSetup."Company Workplan Nos.");

        //NoSeriesMgt.run();
        //NoSeriesMgt.Run(PurchaseSetup."Company Workplan Nos.", true, true);

        IF "Code" = '' THEN BEGIN
            CompanyWorkplanHeader.RESET;
            IF CompanyWorkplanHeader.FINDLAST THEN BEGIN
                "Code" := INCSTR(CompanyWorkplanHeader."Code")
            END ELSE BEGIN
                "Code" := CWPNosLbl;
            END;
        END;

    end;

    var

}

