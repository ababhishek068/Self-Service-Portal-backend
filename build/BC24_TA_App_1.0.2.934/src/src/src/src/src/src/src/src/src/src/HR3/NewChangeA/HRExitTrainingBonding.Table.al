table 50678 "HR Exit Training Bonding"
{
    // version HRMIS 2015 VRS1.0

    Caption = 'HR Exit Interview Clearance Items';

    fields
    {
        field(1; "Line No."; Integer) { }
        field(2; "Employee No."; Code[20]) { }
        field(3; "Training Application Code"; Code[20]) { }
        field(4; "Training Description"; Text[250]) { }
        field(5; "Bonding Duration"; DateFormula) { }
        field(6; "Bondage Start Date"; Date)
        {
            Editable = false;
        }
        field(7; "Bondage Release Date"; Date)
        {
            Editable = false;
        }
        field(8; "Cleared for Early Release?"; Boolean)
        {

            trigger OnValidate();
            begin
                "Cleared by" := USERID;
                "Date Cleared" := TODAY;
            end;
        }
        field(9; "Cleared by"; Code[10]) { }
        field(10; "Date Cleared"; Date) { }
    }

    keys
    {
        key(Key1; "Line No.", "Employee No.") { }
    }

    fieldgroups { }
}

