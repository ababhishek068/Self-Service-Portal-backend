table 50456 "HR Misc. Article Information"
{
    fields
    {
        field(1; "Employee No."; Code[20]) { }
        field(2; "Misc. Article Code"; Code[10]) { }
        field(3; "Line No."; Integer) { }
        field(4; Description; Text[100]) { }
        field(5; "From Date"; Date) { }
        field(6; "To Date"; Date) { }
        field(7; "In Use"; Boolean) { }
        field(8; Comment; Boolean) { }
        field(9; "Serial No."; Text[50]) { }
    }
    keys
    {
        key(Key1; "Employee No.", "Misc. Article Code", "Line No.") { }
        key(Key2; "Line No.") { }
    }

}