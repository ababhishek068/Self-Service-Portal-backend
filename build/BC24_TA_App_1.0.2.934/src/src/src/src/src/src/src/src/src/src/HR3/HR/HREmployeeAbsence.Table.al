table 50299 "HR Employee Absence"
{
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status = filter(Active));
        }
        field(2; "Entry No."; Integer) { }
        field(3; "From Date"; Date) { }
        field(4; "To Date"; Date) { }
        field(5; "Cause of Absence Code"; Code[10])
        {
            TableRelation = "Cause of Absence".Code;
        }
        field(6; Description; Text[100]) { }
        field(7; "No of Days"; Decimal) { }
        field(8; "Unit of Measure Code"; Code[10]) { }
        field(11; Comment; Boolean) { }
        field(12; "Quantity (Base)"; Decimal) { }
        field(13; "Qty. per Unit of Measure"; Decimal) { }
    }
    keys
    {
        key(Key1; "Entry No.") { }
        key(Key2; "Employee No.", "From Date") { }
        key(Key3; "Employee No.", "Cause of Absence Code", "From Date") { }
        key(Key4; "Cause of Absence Code", "From Date") { }
        key(Key5; "From Date", "To Date") { }
    }
}