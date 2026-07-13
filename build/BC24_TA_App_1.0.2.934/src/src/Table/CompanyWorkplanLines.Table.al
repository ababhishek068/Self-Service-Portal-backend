table 50541 "Company Workplan Lines"
{
    DataCaptionFields = "Activity Code", "Procurement Workplan Code";
    LookupPageID = "Departmental WP Activities";


    fields
    {
        field(1; "Activity Code"; Code[20]) { }

        field(2; "Activity Description"; Text[250]) { }

        field(3; "Account Type"; Option)
        {
            OptionMembers = Posting;
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            NotBlank = false;

            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                Validate("Dimension Set ID");
            end;
        }

        field(5; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            NotBlank = false;

            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            begin
                Validate("Dimension Set ID");
            end;
        }

        field(6; "Procurement Workplan Code"; Code[20])
        {
            TableRelation = Workplan."Workplan Code." where("Blocked" = const(false));
        }

        field(7; "Converted to G/L Budget"; Boolean) { }

        field(8; "Amount to Transfer"; Decimal) { }

        field(10; "Date to Transfer"; Date) { }

        field(11; Description; Text[100])
        {
            Editable = false;
        }

        field(12; "Converted to Budget by:"; Text[100]) { }

        field(13; "Procurement Method"; Code[20])
        {
            TableRelation = "Procurement Methods"."Code";
        }

        field(15; Quantity; Decimal)
        {
            trigger OnValidate();
            Begin
                "Amount to Transfer" := "Unit Cost" * Quantity;
            end;
        }

        field(16; "Expense Code"; Code[30])
        {
            TableRelation = "Expense Code".Code;
        }

        field(17; "No."; Code[50])
        {
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
                            where(Blocked = const(false))
            else
            if (Type = const(Item)) Item where(Blocked = const(False))

            else
            if (Type = const("Fixed Asset")) "Fixed Asset" where(Blocked = const(False));


            trigger OnValidate();
            Begin
                Clear(Description);

                if Type = Type::Item then Begin
                    Item.RESET;
                    if Item.GET("No.") then Begin
                        Description := Item.Description;
                    end;
                end;

                if Type = Type::"G/L Account" then Begin
                    GLAccount.RESET;
                    if GLAccount.GET("No.") then Begin
                        Description := GLAccount.Name;
                    end;
                end;

                if Type = Type::"Fixed Asset" then Begin
                    FixedAsset.RESET;
                    if FixedAsset.GET("No.") then Begin
                        Description := FixedAsset.Description;
                    end;
                end;

                Workplan.Reset();
                if Workplan.get("Procurement Workplan Code") then begin
                    "Global Dimension 1 Code" := Workplan."Global Dimension 1 Code";
                    DimMgt.ValidateShortcutDimValues(1, "Global Dimension 1 Code", "Dimension Set ID");

                    "Global Dimension 2 Code" := Workplan."Global Dimension 2 Code";
                    DimMgt.ValidateShortcutDimValues(2, "Global Dimension 2 Code", "Dimension Set ID");
                end;
            end;
        }

        field(18; "Type"; Option)
        {
            OptionMembers = " ","G/L Account","Item","Fixed Asset","Disposal";
            trigger OnValidate()
            begin
                Validate("Dimension Set ID");
            end;
        }

        field(19; "Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }

        field(20; "Category Sub Plan"; Option)
        {
            OptionMembers = " ",Youth," Women & PWDs"," General"," Restricted"," RFP";
        }
        field(21; "Unit Cost"; Decimal)
        {
            trigger OnValidate()
            Begin
                Validate(Quantity);
            end;
        }

        field(22; "Type Of Purchase"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Goods","Services","Works","Consultancy";
        }

        field(23; "Prefered Vendor No."; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where("Blocked" = const(" "));

            trigger OnValidate()
            begin
                Clear("Prefered Vendor Name");

                Vendor.Reset();
                Vendor.get("Prefered Vendor No.");
                "Prefered Vendor Name" := UpperCase(Vendor.Name);
            end;
        }

        field(24; "Prefered Vendor Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(25; "Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(26; "Source of Activity Fund"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Source of Funds"."Code." where("Blocked" = const(false));
        }

        field(27; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Set Entry";

            BlankZero = true;
            Editable = false;
        }

        field(28; "Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;
        }

        field(29; "Type of Plan"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Corporate Plan","Budgeting Unit Plan","Deptarmental Plan";
        }


        field(30; "Activity Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

            end;
        }


        field(31; "Activity End  Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

            end;
        }

        field(32; "Planned Procurement Quarter"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Q1","Q2","Q3","Q4";
        }

        field(33; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(1, "Shortcut Dimension 1 Code", "Dimension Set ID");
            end;
        }
        field(34; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(2, "Shortcut Dimension 2 Code", "Dimension Set ID");
            end;
        }

        field(35; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(3, "Shortcut Dimension 3 Code", "Dimension Set ID");
            end;
        }

        field(36; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(4, "Shortcut Dimension 4 Code", "Dimension Set ID");
            end;
        }

        field(37; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(5, "Shortcut Dimension 5 Code", "Dimension Set ID");
            end;
        }

        field(38; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(6, "Shortcut Dimension 6 Code", "Dimension Set ID");
            end;
        }
        field(39; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(7, "Shortcut Dimension 7 Code", "Dimension Set ID");
            end;
        }

        field(40; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(8, "Shortcut Dimension 8 Code", "Dimension Set ID");
            end;
        }


        field(41; "Timing of Activities"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Monthly","Quarterly","Bi-Annualy","Annualy";
        }
    }

    keys
    {
        key(Key1; "Activity Code", "Procurement Workplan Code") { }
    }


    var
        Item: Record "Item";

        GLAccount: Record "G/L Account";

        Vendor: Record "Vendor";

        DimMgt: Codeunit "DimensionManagement";

        FixedAsset: Record "Fixed Asset";

        Workplan: Record "Workplan";
}

