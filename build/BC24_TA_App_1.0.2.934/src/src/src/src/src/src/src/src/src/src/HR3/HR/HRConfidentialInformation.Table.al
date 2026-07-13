table 50407 "HR Confidential Information"
{
    fields
    {
        field(1; "Employee No."; Code[20]) { }
        field(2; "Confidential Code"; Code[10]) { }
        field(3; "Line No."; Integer) { }
        field(4; Description; Text[100]) { }
        field(5; Comment; Boolean) { }
    }
    keys
    {
        key(Key1; "Employee No.", "Confidential Code", "Line No.") { }
    }

}