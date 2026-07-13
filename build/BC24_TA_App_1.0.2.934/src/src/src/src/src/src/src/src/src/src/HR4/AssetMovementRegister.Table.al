Table 50086 "Asset Movement Register"
{
    fields
    {
        field(1; "Doc No."; Code[20]) { }
        field(2; "Asset No."; Code[50])
        {
            Caption = 'Asset No';
            TableRelation = "Fixed Asset"."No.";
            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                if FA.get("Asset No.") then
                    "Asset Description" := Fa.Description;
            end;
        }
        field(3; "Asset Description"; Text[100]) { }
        field(4; Requestor; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET(Requestor) then begin
                    HREmp.TestField("Global Dimension 1 Code");
                    "Requestor Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                    "Global Dimension 2 Code" := HREmp."Global Dimension 2 Code";
                    Validate("Global Dimension 2 Code");
                end;
            end;
        }
        field(5; "Requestor Name"; Text[100]) { }
        field(6; "Date Requested"; Date) { }
        field(7; "Date Moved"; Date) { }
        field(8; "Date Returned"; Date) { }
        field(9; Remarks; Text[200]) { }
        field(10; Status; Option)
        {
            OptionMembers = New,Requested,"Request Recieved",Issued,"Request Reject",Returned;
        }
        field(12; "Date Needed"; Date) { }
        field(11; "No. Series"; Code[20]) { }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            var
                DimVal: Record "Dimension Value";
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    "Global Dimension 2 Name" := DimVal.Name;
            end;
        }
        field(14; "Global Dimension 2 Name"; Code[100]) { }
        field(15; Reason; Text[250]) { }
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
            "Doc No.":=NoSeriesMgt.GetNextNo(AssetSetup."Asset Movement Nos",  0D, true);
        end;
        "Date Requested" := Today;
    end;
}

