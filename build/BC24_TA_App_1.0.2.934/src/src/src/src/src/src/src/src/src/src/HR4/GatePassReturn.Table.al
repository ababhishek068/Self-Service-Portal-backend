Table 50297 "Gate Pass Return"
{
    DrillDownPageID = "Payment Header";
    LookupPageID = "Payment Header";

    fields
    {
        field(1; "Gate Pass No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Date Out"; Date) { }
        field(3; "Time Out"; Time) { }
        field(4; "Asset Transfer No"; Code[10])
        {
            TableRelation = "Asset Transfer"."No.";

            trigger OnValidate()
            begin
                "Date Out" := 0D;
                "Time Out" := 0T;
                "Asset No." := '';
                "Asset Description" := '';
                "Asset From Location" := '';
                "Asset To Location" := '';

                AssetTrans.Reset;
                AssetTrans.SetRange(AssetTrans."No.", "Asset Transfer No");
                if AssetTrans.Find('-') then begin
                    "Date Out" := Today;
                    "Time Out" := Time;
                    "Asset No." := AssetTrans."Asset to Transfer";
                    "Asset Description" := AssetTrans."Asset Description";
                    "Asset From Location" := AssetTrans."From Location";
                    "Asset To Location" := AssetTrans."To Location";
                end;
            end;
        }
        field(5; "Asset No."; Code[20])
        {
            Editable = false;
        }
        field(6; "Asset Description"; Text[100])
        {
            Editable = false;
        }
        field(7; "Asset From Location"; Code[30])
        {
            Editable = false;
        }
        field(8; "Asset To Location"; Code[30])
        {
            Editable = false;
        }
        field(9; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(10; "Date Created"; Date)
        {
            Editable = false;
        }
        field(11; "Created By"; Code[80])
        {
            Editable = false;
        }
        field(50000; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR" where(Grouping = filter('ADMIN'));
        }
        field(50001; "Returned Status"; Boolean) { }
        field(50002; "ICT/ADMIN Comment"; Text[250]) { }
        field(50003; "To Be Returned"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50004; "Employee No"; Code[20])
        {
            Editable = false;
            TableRelation = "HR-Employee";
        }
        field(50005; "Employee Name"; Text[100]) { }
        field(50006; No; Code[20]) { }
        field(50007; "No. Series"; Code[10]) { }
        field(50008; "Date In"; Date) { }
        field(50009; "Asset Record No"; Code[10])
        {
            TableRelation = "Gate Pass".No;

            trigger OnValidate()
            begin
                "Date Out" := 0D;
                "Time Out" := 0T;
                "Asset No." := '';
                "Asset Description" := '';
                "Asset From Location" := '';
                "Asset To Location" := '';

                Gatepass.Reset;
                Gatepass.SetRange(Gatepass.No, "Asset Record No");
                if Gatepass.Find('-') then begin
                    "Date Out" := Gatepass."Date Out";
                    "Asset No." := Gatepass."Asset No.";
                    "Asset Description" := Gatepass."Asset Description";
                    "Asset From Location" := Gatepass."Asset From Location";
                    "Asset To Location" := Gatepass."Asset To Location";
                    "Employee Name" := Gatepass."Employee Name";
                    "Employee No" := Gatepass."Employee No";
                    "Asset Transfer No" := Gatepass."Asset Transfer No";
                end;
            end;
        }
        field(50010; "Security Comment"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Gate Pass No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if No = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Gate Pass Return No");
            No:=NoSeriesMgt.GetNextNo(HRSetup."Gate Pass Return No",  0D, true);
        end;

        "Date Created" := Today;
        "Created By" := UserId;

        Clear(HRemployee);
        HRemployee.SetRange(HRemployee."User ID", "Created By");
        if HRemployee.Find('-') then
            "Employee Name" := HRemployee."Full Name";
        "Employee No" := HRemployee."No.";
    end;

    var
        AssetTrans: Record "Asset Transfer";
        HRemployee: Record "HR-Employee";
        HRSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
        Gatepass: Record "Gate Pass";
}

