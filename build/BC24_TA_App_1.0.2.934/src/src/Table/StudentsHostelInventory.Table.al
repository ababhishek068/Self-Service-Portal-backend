Table 50087 "Students Hostel Inventory"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Space No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Hostel No"),
                                                              "Room Code" = field("Room No"),
                                                              Status = filter(Vaccant));
        }
        field(3; "Room No"; Code[20])
        {
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Hostel No"),
                                                                    Status = filter(Vaccant));
        }
        field(4; "Hostel No"; Code[20])
        {
            TableRelation = "Hostel Card"."Asset No" where(Gender = field(Gender));
        }
        field(5; "Accomodation Fee"; Decimal) { }
        field(6; "Allocation Date"; Date) { }
        field(7; "Clearance Date"; Date) { }
        field(8; Charges; Decimal) { }
        field(9; Student; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(10; Billed; Boolean) { }
        field(11; "Billed Date"; Date) { }
        field(12; Semester; Code[20])
        {
            TableRelation = Semesters.Code;
        }
        field(13; Cleared; Boolean) { }
        field(14; "Over Paid"; Boolean) { }
        field(15; "Over Paid Amt"; Decimal) { }
        field(16; "Eviction Code"; Code[20])
        {
            TableRelation = "Disciplinary Cases".Code;
        }
        field(17; Gender; Option)
        {
            CalcFormula = lookup(Customer.Gender where("No." = field(Student)));
            FieldClass = FlowField;
            OptionCaption = ',Male,Female';
            OptionMembers = ,Male,Female;
        }
        field(18; "Hostel Assigned"; Boolean) { }
        field(19; "Hostel Name"; Text[50])
        {
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("Hostel No")));
            FieldClass = FlowField;
        }
        field(20; "Item Code"; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(21; "Item Description"; Text[30]) { }
        field(50000; "Student Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field(Student)));
            FieldClass = FlowField;
        }
        field(50001; "Academic Year"; Code[30])
        {
            TableRelation = "Academic Year".Code;
        }
        field(50002; Session; Code[10])
        {
            TableRelation = Intake.Code;
        }
        field(50003; Allocated; Boolean) { }
    }

    keys
    {
        key(Key1; "Line No", Student)
        {
            Clustered = true;
        }
        key(Key2; "Hostel No") { }
        key(Key3; Student) { }
    }

    fieldgroups { }
}

