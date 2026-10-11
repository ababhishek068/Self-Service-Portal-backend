Table 50296 "Gate Pass"
{
    // DrillDownPageID = "Gatepass List";
    //  LookupPageID = "Gatepass List";
    // LookupPageId="Gatepass List";
    // DrillDownPageId="Gatepass List";

    fields
    {
        field(1; "Gate Pass No."; code[20])
        {
            // AutoIncrement = true;
            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                if "Gate Pass No." <> xRec."Gate Pass No." then begin
                    HRSetup.Get;
                    NoSeriesMgt.TestManual(HRSetup."Gate Pass No");
                    "No. Series" := ' ';
                end;
            end;
        }

        field(2; "Date Out"; Date) { }
        field(3; "Time Out"; Time) { }
        field(4; "Transfer No"; Code[10])

        {
            //if (Type = const(Vendor)) Vendor
            //         else if (Type = const(Customer)) Customer;
            TableRelation = if ("Link to" = const("Asset Transfer")) "Asset Transfer"."No." where(Status = filter(Approved))
            else if ("Link to" = const("Transfer Order")) "Transfer Shipment Header"."No." where("Gate Pass No" = filter(''))
            else if ("Link to" = const("Store Issue")) "Store Requistion Header"."No." where(Status = filter(Posted))
            else if ("Link to" = const(Maintenance)) "FLT-Fuel & Maintenance Req."."Requisition No" where(Status = filter(Approved), Type = const(Maintenance));
            //TableRelation = "Asset Transfer"."No." where(Status = filter(Approved));

            trigger OnValidate()
            begin
                TestField("Link to");
                "Date Out" := 0D;
                "Time Out" := 0T;
                "Asset No." := '';
                "Description" := '';
                "From Location" := '';
                "To Location" := '';
                if "Link to" = "Link to"::"Asset Transfer" then begin

                    AssetTrans.Reset;
                    AssetTrans.SetRange(AssetTrans."No.", "Transfer No");
                    if AssetTrans.Find('-') then begin
                        "Date Out" := Today;
                        "Time Out" := Time;
                        "Asset No." := AssetTrans."Asset to Transfer";
                        "Description" := AssetTrans."Asset Description";
                        "From Location" := AssetTrans."From Location";
                        "To Location" := AssetTrans."To Location";
                        "Asset No." := AssetTrans."Tag No";

                    end;
                end else if "Link to" = "Link to"::"Store Issue" then begin

                end else if "Link to" = "Link to"::"Transfer Order" then begin

                end else if "Link to" = "Link to"::"Spares Issuance" then begin

                end else if "Link to" = "Link to"::Maintenance then begin
                    MaintenanceReq.Reset;
                    MaintenanceReq.SetRange("Requisition No", "Transfer No");
                    if MaintenanceReq.FindFirst() then begin
                        "Date Out" := Today;
                        "Time Out" := Time;
                        "Asset No." := MaintenanceReq."Vehicle Reg No";
                        Description := CopyStr(MaintenanceReq.Description, 1, MaxStrLen(Description));
                    end;
                end;
            end;
        }
        field(5; "Asset No."; Code[100])
        {
            Editable = false;
        }
        field(6; "Description"; Text[100])
        {
            Editable = false;
        }
        field(7; "From Location"; Code[30]) { }
        field(8; "To Location"; Code[30]) { }
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
        field(50000; "Responsibility Center"; Code[100])
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
            TableRelation = "HR-Employee"."No." where(Status = filter(Active));

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
        field(50009; Sector; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, Sector);
                if DimVal.Find('-') then
                    "Sector Name" := DimVal.Name;
            end;
        }
        field(50010; "Sector Name"; Text[100]) { }
        field(50011; "Department/District"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Department/District");
                if DimVal.Find('-') then
                    "District/Department Name" := DimVal.Name;
            end;
        }
        field(50012; "District/Department Name"; Text[100]) { }
        field(50013; "Link to"; Option)
        {
            OptionMembers = "","Asset Transfer","Transfer Order","Spares Issuance","Store Issue",Maintenance;
        }
        field(50014; "External Document No"; code[20]) { }
        field(50015; "Division/Branch"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Division/Branch");
                if DimVal.Find('-') then
                    "Division/Branch Name" := DimVal.Name;
            end;

        }
        field(50016; "Division/Branch Name"; text[100]) { }
        field(50017; "Work Station"; Code[20]) { }
        field(50018; "Work Station Name"; Text[100]) { }
        field(50019;"Return Date";Date){}
    }

    keys
    {
        // key(Key1; No)
        // {
        //     Clustered = true;
        // }
        key(Key1; "Gate Pass No.", "Link to") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Gate Pass No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Gate Pass No");
            "Gate Pass No." := NoSeriesMgt.GetNextNo(HRSetup."Gate Pass No", Today, true);
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
        storeissue: Record "Store Requistion Header";
        transferorder: Record "Transfer Header";
        MaintenanceReq: Record "FLT-Fuel & Maintenance Req.";
}

