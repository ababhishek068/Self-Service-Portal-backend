Table 50868 "FLT-Vehicle Header"
{
    DrillDownPageID = "Flt Vehicle Card List";
    LookupPageID = "Flt Vehicle Card List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                /*
                IF "No." <> xRec."No." THEN BEGIN
                  FASetup.GET;
                  NoSeriesMgt.TestManual(FASetup."Fixed Asset Nos.");
                  "No. Series" := '';
                END;
                */
                CopyFields();

            end;
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                /*
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                  "Search Description" := Description;
                IF Description <> xRec.Description THEN BEGIN
                  FADeprBook.SETCURRENTKEY("FA No.");
                  FADeprBook.SETRANGE("FA No.","No.");
                  FADeprBook.MODIFYALL(Description,Description);
                END;
                MODIFY(TRUE);
                */

            end;
        }
        field(3; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
        }
        field(4; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(5; "FA Class Code"; Code[10])
        {
            Caption = 'FA Class Code';
            TableRelation = "FA Class";
        }
        field(6; "FA Subclass Code"; Code[10])
        {
            Caption = 'FA Subclass Code';
            TableRelation = "FA Subclass";
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                /*
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                */

            end;
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                /*
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                */

            end;
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(10; "FA Location Code"; Code[10])
        {
            Caption = 'FA Location Code';
            TableRelation = "FA Location";
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(12; "Main Asset/Component"; Option)
        {
            Caption = 'Main Asset/Component';
            Editable = false;
            OptionCaption = ' ,Main Asset,Component';
            OptionMembers = " ","Main Asset",Component;
        }
        field(13; "Component of Main Asset"; Code[20])
        {
            Caption = 'Component of Main Asset';
            Editable = false;
            TableRelation = "Fixed Asset";
        }
        field(14; "Budgeted Asset"; Boolean)
        {
            Caption = 'Budgeted Asset';

            trigger OnValidate()
            begin
                /*
                FAMoveEntries.ChangeBudget(Rec);
                */

            end;
        }
        field(15; "Warranty Date"; Date)
        {
            Caption = 'Warranty Date';
        }
        field(16; "Responsible Employee"; Code[20])
        {
            Caption = 'Responsible Employee';
            TableRelation = "HR-Employee";
        }
        field(17; "Serial No."; Text[30])
        {
            Caption = 'Serial No.';

            trigger OnValidate()
            begin
                "Registration No." := "Serial No.";
                Modify;
            end;
        }
        field(18; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(19; Insured; Boolean)
        {
            CalcFormula = exist("Ins. Coverage Ledger Entry" where("FA No." = field("No."),
                                                                    "Disposed FA" = const(false)));
            Caption = 'Insured';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; Comment; Boolean)
        {
            //  CalcFormula = exist("Comment Line" where ("Table Name"=const(Fixed field("No.")")";
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(22; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(23; "Maintenance Vendor No."; Code[20])
        {
            Caption = 'Maintenance Vendor No.';
            TableRelation = Vendor;
        }
        field(24; "Under Maintenance"; Boolean)
        {
            Caption = 'Under Maintenance';
        }
        field(25; "Next Service Date"; Date)
        {
            Caption = 'Next Service Date';
        }
        field(205; "Last Inspection Date"; Date) { }
        field(26; Inactive; Boolean)
        {
            Caption = 'Inactive';
        }
        field(27; "FA Posting Date Filter"; Date)
        {
            Caption = 'FA Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(28; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(29; "FA Posting Group"; Code[10])
        {
            Caption = 'FA Posting Group';
            TableRelation = "FA Posting Group";
        }
        field(50000; "Capacity"; Integer) { }
        field(50001; "Current Miliege"; Integer) { }
        field(39006075; "Last Service Date"; Date) { }
        field(39006076; "Service Interval"; Option)
        {
            OptionMembers = ,Hour,Day,Week,Month,Quarter,Year;
        }
        field(39006077; "Service Interval Value"; Integer) { }
        field(50077; "Next Service Kilometers"; Decimal) { }
        field(39006078; "Last Service No."; Code[10]) { }
        field(39006079; Type; Option)
        {
            OptionMembers = " ",Vehicle,Machinery;
        }
        field(39006080; Make; Code[10])
        {
            TableRelation = "Flt Make".Code;
        }
        field(39006081; Model; Code[10])
        {
            TableRelation = "FLT-Flt Model".Code;
        }
        field(39006082; "Year Of Manufacture"; Integer) { }
        field(39006083; "Country Of Origin"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(39006084; "Start Reading"; Decimal) { }
        field(39006085; Ownership; Option)
        {
            OptionMembers = " ","First Owner","Second Owner","Third Owner","Fourth Owner","Fifth Owner";
        }
        field(39006086; "Chassis Serial No."; Code[50]) { }
        field(39006087; "Engine Serial No."; Code[50]) { }
        field(39006088; "Horse Power"; Integer) { }
        field(39006089; "Ignition Key Code"; Code[10]) { }
        field(39006090; "Door Key Code"; Code[10]) { }
        field(39006091; "Body Color"; Code[10]) { }
        field(39006092; "Interior Color"; Code[10]) { }
        field(39006093; Cylinders; Integer) { }
        field(39006094; "Wheel Size Rear"; Decimal) { }
        field(39006095; "Wheel Size Front"; Decimal) { }
        field(39006096; "Tire Size Rear"; Code[20]) { }
        field(39006097; "Tire Size Front"; Code[20]) { }
        field(39006098; "Fuel Type"; Option)
        {
            OptionMembers = " ",Petrol,Diesel;
        }
        field(39006099; "Fuel Rating"; Decimal) { }
        field(39006100; "Current Reading"; Decimal) { }
        field(39006101; "Registration No."; Code[10])
        {
            NotBlank = true;
        }
        field(39006102; "Readings Based On"; Option)
        {
            OptionMembers = " ",Hours,Mileage;
        }
        field(39006103; "Total Consumption"; Decimal)
        {
            //  CalcFormula = sum("FA Ledger Entry".Amount where ("FA Posting Type"=filter(Custom field("No.")")";
            //   FieldClass = FlowField;
        }
        field(39006104; "Tare Weight"; Decimal) { }
        field(39006105; Available; Boolean) { }
        field(39006106; "Gross Weight"; Decimal) { }
        field(39006107; "Reason for Unavailability"; Option)
        {
            OptionMembers = " ",Maintenance,Out;
        }
        field(39006108; Selected; Boolean) { }
        field(39006109; "Selected By"; Code[20]) { }
        field(39006110; "Passenger Capacity"; Integer) { }
        field(39006111; Source; Option)
        {
            OptionMembers = " ",Purchased,Donated;
        }
        field(3900611; "Registration Date"; Date)
        {
            Caption = 'Registration  Date';
        }
        field(3900612; "Body"; Code[50]) { }
        field(3900613; "Driver"; Code[20])
        {
            Caption = 'Driver';
            TableRelation = "Flt Driver";
        }
        field(50613; "Driver Reliever"; Code[20])
        {

            TableRelation = "Flt Driver";
        }
        field(3900614; "Vehicle Type"; Option)
        {
            OptionCaption = 'Vehicle,Vessel';
            OptionMembers = Vehicle,Vessel;
        }

    }

    keys
    {
        key(Key1; "No.", "Registration No.")
        {
            Clustered = true;
            SumIndexFields = "Start Reading", "Current Reading";
        }
    }

    fieldgroups { }

    var
        FA: Record "Fixed Asset";

    procedure CopyFields()
    begin

        FA.RESET;
        IF FA.GET("No.") THEN BEGIN

            Description := FA."Search Description";

            "Vendor No." := FA."Vendor No.";
            "Main Asset/Component" := FA."Main Asset/Component";
            "Component of Main Asset" := FA."Component of Main Asset";
            "Budgeted Asset" := FA."Budgeted Asset";
            // "Responsible Employee" := FA."Responsible Employee";
            "Serial No." := FA."Serial No.";
            "Last Date Modified" := FA."Last Date Modified";
            Blocked := FA.Blocked;
            // Picture:=FA.Image;
            "Maintenance Vendor No." := FA."Maintenance Vendor No.";
            "Under Maintenance" := FA."Under Maintenance";
            "Next Service Date" := FA."Next Service Date";
            Inactive := FA.Inactive;
            "No. Series" := FA."No. Series";
            "FA Posting Group" := FA."FA Posting Group";

            Insured := FA.Insured;
            Comment := FA.Comment;
        END;
        /* 
       FA.Reset;
       FA.Get("No."); */
        // TransferFields(FA);
        //"Registration No.":=FA."Registration No";

    end;
}

