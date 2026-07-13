table 50244 "ICT Service/Maintenance Req"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Doc No."; Code[20]) { }
        field(2; "Asset No."; Code[50])
        {
            Caption = 'Asset No';
            TableRelation = "ICT Asset Register"."Asset No";
            trigger OnValidate()
            var
                FA: Record "ICT Asset Register";
            begin
                if FA.get("Asset No.") then begin
                    "Asset Description" := Fa."Asset Description";
                    "Assigned Officer" := FA."Assigned Officer";
                    Validate("Assigned Officer");
                    "Asset Owner" := FA."Asset Owner";
                    Validate("Asset Owner");
                    "Asset Location" := Fa."Asset Location";
                end;
            end;
        }
        field(3; "Asset Description"; Text[100]) { }
        field(4; "Assigned Officer"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Assigned Officer") then
                    "Assined Officer Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(5; "Assined Officer Name"; Text[100])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(6; Category; Option)
        {
            OptionMembers = Asset,Application;
        }
        field(7; "Service Date"; Date) { }
        field(8; "Service Status"; Option)
        {
            OptionMembers = New,"Pending Service",Serviced;
        }
        field(9; "Asset Location"; Text[50]) { }
        field(10; "No. Series"; Code[20]) { }
        field(11; "Asset Owner"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Asset Owner") then
                    "Asset Owner Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(12; "Asset Owner Name"; Text[100]) { }
        field(13; "Service Details"; Text[500]) { }
        field(14; "Last Service Date"; Date)
        {
            trigger OnValidate()
            var
                ICTAsset: Record "ICT Asset Register";
            begin
                if ICTAsset.GET("Asset No.") then begin
                    ICTAsset."Last Service Date" := "Last Service Date";
                    ICTAsset.Modify();
                end;
            end;
        }
        field(15; "Next Service Date"; Date)
        {
            trigger OnValidate()
            var
                ICTAsset: Record "ICT Asset Register";
            begin
                if ICTAsset.GET("Asset No.") then begin
                    ICTAsset."Next Service Date" := "Next Service Date";
                    ICTAsset.Modify();
                end;
            end;
        }
        field(16; "Date Created"; Date) { }
        field(17; "Raised By"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Asset Owner") then
                    "Raised By Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(18; "Raised By Name"; Text[100]) { }
        field(19; "Anti-Virus Last Update"; Date)
        {
            trigger OnValidate()
            begin
                "Anti-Virus Next Update" := CalcDate('<1Y>', "Anti-Virus Last Update");
            end;

        }
        field(20; "Anti-Virus Next Update"; Date) { }


    }

    keys
    {
        key(Key1; "Doc No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        AssetSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if "Doc No." = '' then begin
            AssetSetup.Get();
            AssetSetup.TestField("Asset Movement Nos");
            "Doc No.":=NoSeriesMgt.GetNextNo(AssetSetup."Asset Movement Nos", 0D, true);
        end;
        "Date Created" := Today;
    end;

}