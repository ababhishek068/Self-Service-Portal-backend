Table 50295 "Asset Information Register"
{
    //DrillDownPageID = register
    //LookupPageID = UnknownPage70135419;

    fields
    {
        field(1; "Asset No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Reg Code"; Code[50])
        {
            // Caption = 'Reg No., Code, Chassis No., LR No, Serial No., Size in Sqr Feet';
            // Description = 'Reg No., Code, Chassis No., LR No, Serial No., Size in Sqr Feet';
            Caption = 'Asset No';
            TableRelation = "Fixed Asset"."No.";
            trigger OnValidate()
            var
                FA: Record "Fixed Asset";
            begin
                if FA.get("Reg Code") then
                    "Asset Description" := Fa.Description;

                // AssetInfoReg.Reset;
                // AssetInfoReg.SetRange(AssetInfoReg."Reg Code", "Reg Code");
                // if AssetInfoReg.Find('-') then Error('Reg Code [ %1 ] already exists');
            end;
        }
        field(3; "Asset Description"; Text[100]) { }
        field(4; "Cost of Asset"; Decimal) { }
        field(5; "Date Acquired / Installed."; Date) { }
        field(6; "Asset Category"; Option)
        {
            OptionMembers = " ","Office Equipment";
        }
        field(7; "Repairs and Maintenance Cost"; Decimal) { }
        field(8; "Serial Number"; Code[20]) { }
        field(9; "Location/Office"; Text[50]) { }
        field(10; "Assigned Staff"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET("Assigned Staff") then
                    "Staff Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(11; "Staff Name"; Text[100])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(12; "Last Service Date"; Date) { }
        field(13; "Duration of Next Service"; DateFormula)
        {
            trigger OnValidate()
            begin
                "Next Service Date" := CalcDate("Duration of Next Service", "Last Service Date");
            end;
        }
        field(14; "Next Service Date"; Date) { }
        field(15; "Any Other Information"; Text[200]) { }
    }

    keys
    {
        key(Key1; "Asset No.", "Assigned Staff")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

