table 50536 "Workplan Activities"
{
    DataCaptionFields = "Activity Code", "Procurement Workplan Code";
    DrillDownPageID = "Departmental WP Activities";
    LookupPageID = "Departmental WP Activities";


    fields
    {
        field(1; "Activity Code"; Code[20]) { }

        field(2; "Activity Description"; Text[250]) { }

        field(3; "Account Type"; Option)
        {
            OptionMembers = "Posting","Begin-Total","End-Total";
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

        field(8; "Amount to Transfer"; Decimal) { BlankZero = true; }

        field(10; "Date to Transfer"; Date) { }

        field(11; Description; Text[100])
        {
            Editable = false;
        }

        field(12; "Converted to Budget by:"; Text[100]) { }

        field(13; "Procurement Method"; Option)
        {   
            TableRelation = "Procurement Methods".Code;
             OptionCaption = 'Quotation Request,Open Tender,Restricted Tender,Low Value Procurement,Direct Procurement,Request for Proposal,EOI';
            OptionMembers = "Quotation Request","Open Tender","Restricted Tender","Low Value Procurement","Direct Procurement","Request for Proposal",EOI;
        }

        field(15; Quantity; Decimal)
        {
            BlankZero = true;

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
                        "Unit of Measure" := Item."Base Unit of Measure";
                        "Unit Cost" := Item."Unit Cost";
                        "Report Grouping" := Item."Inventory Posting Group";
                    end;
                end;

                if Type = Type::"G/L Account" then Begin
                    GLAccount.RESET;
                    if GLAccount.GET("No.") then Begin
                        Description := GLAccount.Name;
                        "Report Grouping" := "No.";
                    end;
                end;

                if Type = Type::"Fixed Asset" then Begin
                    FixedAsset.RESET;
                    if FixedAsset.GET("No.") then Begin
                        Description := FixedAsset.Description;
                        "Report Grouping" := "No.";
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
            OptionMembers = " ","G/L Account","Item","Fixed Asset";
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
            OptionMembers = " ",Youth," Women & PWDs"," Open"," Restricted"," RFP";
        }
        field(21; "Unit Cost"; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            Begin
                Validate(Quantity);
            end;
        }

        field(22; "Type Of Purchase"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Consumable","Fixed Asset","Service","Stock","Non-Stock";
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
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
        field(148; "Activity Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Project","Logical Frame","Performance Contract","Strategy";
        }
        field(141; "WorkPlan Status"; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Cancelled;
            FieldClass = FlowField;
            CalcFormula = lookup(Workplan.Status where("Workplan Code." = field("Procurement Workplan Code")));
        }

        field(42; "Indentation"; Integer)
        {
            Caption = 'Indentation';
            DataClassification = ToBeClassified;
            BlankZero = true;
            Editable = false;
        }

        field(43; "Totalling"; Text[50])
        {
            Caption = 'Totalling';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44; "Qty Used"; Decimal)
        {
            Caption = 'Qty Used';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("WorkPlan No." = field("Procurement Workplan Code"), "No." = field("No.")));
            Editable = false;
        }
        field(45; "Approved Quantity"; Integer)
        {
            Caption = 'Approved Quantity';
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "Approved Total Cost" := "Approved Unit Cost" * "Approved Quantity";
            end;
        }

        field(46; "Approved Unit Cost"; Decimal)
        {
            Caption = 'Approved Unit Cost';
            DataClassification = ToBeClassified;
        }
        field(47; "Supplier Category"; Option)
        {
            Caption = 'Supplier Category';
            DataClassification = ToBeClassified;
            OptionMembers = " ","PWD","Women","Youth","General";
        }
        field(48; "Approved Total Cost"; Decimal)
        {
            BlankZero = true;
            trigger OnValidate();
            Begin
                Validate("Approved Quantity");
            end;
        }
        field(49; "Financial Year"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Financial Periods"."Current Period";
        }
        field(50; "Board Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Ammended"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Modified By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Modified On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(54; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved,Cancelled;
        }
        field(55; "Report Grouping"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Activity Code", "Procurement Workplan Code") { }
    }
    trigger OnModify()
    var

    begin
        //if "WorkPlan Status" = "WorkPlan Status"::Approved then begin
        Ammended := true;
        "Modified By" := UserId;
        "Modified On" := CreateDateTime(Today, Time);
        //end;
    end;


    var
        Item: Record "Item";

        GLAccount: Record "G/L Account";

        Vendor: Record "Vendor";

        DimMgt: Codeunit "DimensionManagement";

        FixedAsset: Record "Fixed Asset";

        Workplan: Record "Workplan";

}

