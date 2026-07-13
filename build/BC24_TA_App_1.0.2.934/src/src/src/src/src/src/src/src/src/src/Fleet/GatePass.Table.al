Table 50296 "Gate Pass"
{
    // DrillDownPageID = gate p
    // LookupPageID = "Payment Header";

    fields
    {
        field(1; "Gate Pass No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Date Out"; Date) { }
        field(3; "Time Out"; Time) { }
        field(4; "Asset Transfer No"; Code[10])
        {
            TableRelation = "Asset Transfer"."No." where(Status = filter(Approved));

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
        field(7; "Asset From Location"; Code[30]) { }
        field(8; "Asset To Location"; Code[30]) { }
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
        field(50002; Comment; Text[250]) { }
        field(50003; "To Be Returned"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50004; "Employee No"; Code[20])
        {
            Editable = false;
            TableRelation = "HR-Employee";

            trigger OnValidate()
            begin
                Clear(HRemployee);
                HRemployee.SetRange(HRemployee."No.", "Employee No");
                if HRemployee.Find('-') then
                    "Employee Name" := HRemployee."Full Name";
            end;
        }
        field(50005; "Employee Name"; Text[100]) { }
        field(50006; No; Code[20]) { }
        field(50007; "No. Series"; Code[10]) { }
        field(50008; "Serial No."; Code[20]) { }
        field(50009; Station; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, Station);
                if DimVal.Find('-') then
                    "Station Name" := DimVal.Name;
            end;
        }
        field(500010; "Station Name"; Text[100]) { }
        field(500011; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, Department);
                if DimVal.Find('-') then
                    "Department Name" := DimVal.Name;
            end;
        }
        field(500012; "Department Name"; Text[100]) { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; "Gate Pass No.") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if No = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Gate Pass No");
            No:=NoSeriesMgt.GetNextNo(HRSetup."Gate Pass No", 0D, true);
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
        DimVal: Record "Dimension Value";
}

