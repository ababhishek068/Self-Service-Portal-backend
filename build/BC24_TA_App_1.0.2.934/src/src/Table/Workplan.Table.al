table 50537 "Workplan"
{

    DrillDownPageID = "Workplan List";
    LookupPageID = "Workplan List";
    Caption = 'Departmental Workplans';

    fields
    {
        field(1; "Workplan Code."; Code[20]) { }

        field(2; "Workplan Description"; Text[100]) { }

        field(3; Blocked; Boolean) { }

        field(4; "Budget Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value";
        }

        field(5; "Budget Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value";
        }

        field(6; "Budget Dimension 3 Code"; Code[20])
        {
            TableRelation = Dimension;
        }

        field(7; "Budget Dimension 4 Code"; Code[20])
        {
            TableRelation = Dimension;
        }
        field(8; "Closed"; Boolean) { }
        field(28; "Status"; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Cancelled;
            editable = false;
        }

        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(1, "Global Dimension 1 Code", "Dimension Set ID");
            end;
        }

        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            var
                DimMgt: Codeunit DimensionManagement;
            begin
                DimMgt.ValidateShortcutDimValues(2, "Global Dimension 2 Code", "Dimension Set ID");
            end;
        }

        field(11; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(12; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(13; "Dimension Set ID"; Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(14; "Shortcut Dimension 1 Code"; Code[20])
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
        field(15; "Shortcut Dimension 2 Code"; Code[20])
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

        field(16; "Shortcut Dimension 3 Code"; Code[20])
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

        field(17; "Shortcut Dimension 4 Code"; Code[20])
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

        field(18; "Shortcut Dimension 5 Code"; Code[20])
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

        field(19; "Shortcut Dimension 6 Code"; Code[20])
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
        field(20; "Shortcut Dimension 7 Code"; Code[20])
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

        field(21; "Shortcut Dimension 8 Code"; Code[20])
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
        field(22; "Board Approved"; Boolean) { }
        field(23; "Financial Year"; Code[20])
        {
            TableRelation = "Financial Periods"."Period Code";
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Workplan Code.") { }
    }

    fieldgroups { }

    trigger OnDelete();
    begin
        WorkplanActivities.RESET;
        WorkplanActivities.SETRANGE(WorkplanActivities."Procurement Workplan Code", "Workplan Code.");
        WorkplanActivities.DELETEALL(TRUE)
    end;

    var
        WorkplanActivities: Record "Workplan Activities";
}

