Table 50053 "Hostel Ledger"
{


    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = false;
        }
        field(2; "Hostel No"; Code[20])
        {
            TableRelation = "Hostel Card"."Asset No";
        }
        field(3; "Room No"; Code[20])
        {
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Hostel No"));
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Vaccant,Partially Occupied,Fully Occupied,Black-Listed,Partially Booked,Fully Booked';
            OptionMembers = Vaccant,"Partially Occupied","Fully Occupied","Black-Listed","Partially Booked","Fully Booked";
        }
        field(5; "Room Cost"; Decimal) { }
        field(6; "Student No"; Code[20]) { }
        field(7; "Receipt No"; Code[20]) { }
        field(8; "Space No"; Code[20])
        {
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Hostel No"),
                                                              "Room Code" = field("Room No"));
        }
        field(9; Booked; Boolean) { }
        field(10; "Booked Students"; Code[20])
        {
            CalcFormula = lookup("Students Hostel Rooms".Student where("Space No" = field("Space No"),
                                                                        Semester = field("Semester Filter")));
            FieldClass = FlowField;
        }
        field(11; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(12; "Students Count"; Integer)
        {
            CalcFormula = count("Students Hostel Rooms" where("Space No" = field("Space No"),
                                                               Semester = field("Semester Filter"),
                                                               Allocated = filter(true)));
            FieldClass = FlowField;
        }
        field(13; Gender; Option)
        {
            CalcFormula = lookup("Hostel Card".Gender where("Asset No" = field("Hostel No")));
            FieldClass = FlowField;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(14; "Reservation Remarks"; Text[100]) { }
        field(15; "Reservation UserID"; Code[20]) { }
        field(16; "Reservation Date"; Date) { }
        field(50000; Campus; Code[20])
        {
            CalcFormula = lookup("Hostel Card"."Campus Code" where("Asset No" = field("Hostel No")));
            FieldClass = FlowField;
        }
        field(50001; "Hostel Name"; Text[100])
        {
            CalcFormula = lookup("Hostel Card".Discription where("Asset No" = field("Hostel No")));
            FieldClass = FlowField;
        }
        field(50002; Semester; Code[20]) { }
        field(50003; "Academic Year"; Code[20])
        {
            TableRelation = "Academic Year".Code;
        }
        field(50004; "User ID"; Code[100])
        {
            CalcFormula = lookup("Students Hostel Rooms"."Allocated By" where("Space No" = field("Space No"),
                                                                               "Room No" = field("Room No"),
                                                                               "Hostel No" = field("Hostel No"),
                                                                               Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(50005; "Allocation Count"; Integer)
        {
            CalcFormula = count("Students Hostel Rooms" where(Allocated = filter(true),
                                                               "Space No" = field("Space No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Space No", "Room No", "Hostel No")
        {
            Clustered = true;
        }
        key(Key2; "Hostel No") { }
        key(Key3; "Student No") { }
        key(Key4; "Room No", Status) { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /*
         CLEAR(counts);
         LedgerHistory.RESET;
         IF LedgerHistory.FIND('-') THEN BEGIN
          counts:=LedgerHistory.COUNT;
         END;
          roomSpaces.RESET;
         roomSpaces.SETRANGE(roomSpaces."Hostel Code","Hostel No");
         roomSpaces.SETRANGE(roomSpaces."Room Code","Room No");
         roomSpaces.SETRANGE(roomSpaces."Space Code","Space No");
         IF roomSpaces.FIND('-') THEN BEGIN
         roomSpaces.Status:=roomSpaces.Status::Vaccant;
         roomSpaces."Student No":='';
         roomSpaces."Receipt No":='';
         roomSpaces.MODIFY;
         LedgerHistory.INIT;
         LedgerHistory."Space No":="Space No";
         LedgerHistory."Room No":="Room No";
         LedgerHistory."Hostel No":="Hostel No";
         LedgerHistory.No:=counts+1;
         LedgerHistory.Status:=LedgerHistory.Status::"Fully Occupied";
         LedgerHistory."Room Cost":="Room Cost";
         LedgerHistory."Student No":="Student No";
         LedgerHistory."Receipt No":="Receipt No";
         LedgerHistory.Booked:=Booked;
         LedgerHistory."Reservation Remarks":="Reservation Remarks";
         LedgerHistory."Reservation UserID":="Reservation UserID";
         LedgerHistory."Reservation Date":="Reservation Date";
         LedgerHistory.Semester:=Semester;
         LedgerHistory."Semester Filter":="Semester Filter";
         LedgerHistory."Booked Students":="Booked Students";
         LedgerHistory."Students Count":="Students Count";
         LedgerHistory.Gender:=Gender;
         LedgerHistory.Campus:= Campus;
         LedgerHistory."Hostel Name":="Hostel Name";
         LedgerHistory.INSERT;
         END;
         */

    end;

    trigger OnInsert()
    begin
        Status := Status::"Fully Occupied"
    end;
}

