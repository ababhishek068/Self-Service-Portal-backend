table 50326 "HR Confidential Information2"
{
    LookupPageId = "HR Confidential Comment List2";
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