Table 50278 "Asset Transfer"
{
    DrillDownPageID = "Asset Transfer List";
    LookupPageID = "Asset Transfer List";

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                //TEST IF MANUAL NOs ARE ALLOWED
                if "No." <> xRec."No." then begin
                    FASetup.Get;
                    NoSeriesMgt.TestManual(FASetup."Asset Transfer Nos.");
                    "No. Series" := ' ';
                end;
            end;
        }
        field(5; "Raised By"; Code[50])
        {
            Editable = false;
        }
        field(10; "Asset to Transfer"; Code[20])
        {
            TableRelation = if (Type = const(" ")) "Fixed Asset"."No."
            else
            if (Type = const(Item)) Item
            else
            if (Type = const("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                if Type = Type::"Fixed Asset" then
                    FA.Reset;
                FA.SetRange(FA."No.", "Asset to Transfer");
                if FA.Find('-') then begin
                    "Asset Description" := FA.Description;
                    "From Location" := FA."FA Location Code";
                    "From Responsible Employee" := FA."Responsible Employee";
                end;

                if Type = Type::Item then
                    items.Reset;
                items.SetRange(items."No.", "Asset to Transfer");
                if items.Find('-') then begin
                    "Asset Description" := items.Description;
                end;
            end;
        }
        field(15; "Asset Description"; Text[50]) { }
        field(20; "From Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "From Dimension 1 Code");
                if DimVal.Find('-') then
                    "From Dimension 1 Description" := DimVal.Name
                else
                    "From Dimension 1 Description" := ' ';
            end;
        }
        field(25; "From Dimension 1 Description"; Text[50]) { }
        field(30; "From Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "From Dimension 2 Code");
                if DimVal.Find('-') then
                    "From Dimension 2 Description" := DimVal.Name
                else
                    "From Dimension 2 Description" := ' ';
            end;
        }
        field(35; "From Dimension 2 Description"; Text[50]) { }
        field(40; "From Location"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(45; "From Responsible Employee"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                Clear(Employees);
                Employees.SetRange(Employees."No.", "From Responsible Employee");
                if Employees.Find('-') then
                    "From Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name"
                else
                    "From Employee Name" := ' ';
            end;
        }
        field(50; "From Employee Name"; Text[100]) { }
        field(55; "To Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "To Dimension 1 Code");
                if DimVal.Find('-') then
                    "To Dimension 1 Description" := DimVal.Name
                else
                    "To Dimension 1 Description" := ' ';
            end;
        }
        field(60; "To Dimension 1 Description"; Text[50]) { }
        field(65; "To Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "To Dimension 2 Code");
                if DimVal.Find('-') then
                    "To Dimension 2 Description" := DimVal.Name
                else
                    "To Dimension 2 Description" := ' ';
            end;
        }
        field(70; "To Dimension 2 Description"; Text[50]) { }
        field(75; "To Location"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));
        }
        field(80; "To Responsible Employee"; Code[20])
        {
            TableRelation = "HR-Employee";

            trigger OnValidate()
            begin
                Clear(Employees);
                Employees.SetRange(Employees."No.", "To Responsible Employee");
                if Employees.Find('-') then
                    "To Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name"
                else
                    "To Employee Name" := ' ';
            end;
        }
        field(85; "To Employee Name"; Text[100]) { }
        field(90; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(95; Transferred; Boolean)
        {
            Editable = false;
        }
        field(100; Comments; Text[100]) { }
        field(105; "No. Series"; Code[20]) { }
        field(106; "Transfer Type"; Option)
        {
            OptionCaption = ' ,Internal,External';
            OptionMembers = " ",Internal,External;
        }
        field(50000; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR" where(Grouping = filter('ADMIN'));
        }
        field(50001; "Serial No."; Code[20]) { }
        field(50002; Type; Option)
        {
            OptionCaption = ' ,Item,Fixed Asset';
            OptionMembers = " ",Item,"Fixed Asset";
        }
        field(50003; "Destination/Location"; Text[250]) { }
        field(50004; Date; Date) { }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            FASetup.Get;
            FASetup.TestField("Asset Transfer Nos.");
            "No.":=NoSeriesMgt.GetNextNo(FASetup."Asset Transfer Nos.", 0D, true);
        end;

        "Raised By" := UserId;
        Date := Today;
    end;

    var
        FA: Record "Fixed Asset";
        DimVal: Record "Dimension Value";
        Employees: Record "HR-Employee";
        FASetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
        items: Record Item;
}

