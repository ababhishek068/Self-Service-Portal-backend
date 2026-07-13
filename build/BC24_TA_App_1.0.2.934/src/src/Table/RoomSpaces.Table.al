Table 50076 "Room Spaces"
{

    fields
    {
        field(1; "Hostel Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Card"."Asset No";
        }
        field(2; "Room Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Hostel Code"));
        }
        field(3; "Space Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Vaccant,Partially Occupied,Fully Occupied,Black-Listed,Partially Booked,Fully Booked,Reserved';
            OptionMembers = Vaccant,"Partially Occupied","Fully Occupied","Black-Listed","Partially Booked","Fully Booked",Reserved;
        }
        field(9; Booked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Booked Students"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Receipt No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Student Name"; Text[250])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Student No")));
            FieldClass = FlowField;
        }
        field(14; "Black List reason"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Room Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Gender; Option)
        {
            CalcFormula = lookup("Hostel Card".Gender where("Asset No" = field("Hostel Code")));
            FieldClass = FlowField;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(17; "Entry Exist"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Hostel No" = field("Hostel Code"),
                                                       "Room No" = field("Room Code"),
                                                       "Space No" = field("Space Code")));
            FieldClass = FlowField;
        }
        field(18; "Room Not Availlable"; Boolean)
        {
            CalcFormula = lookup("Hostel Block Rooms"."Not Availlable" where("Room Code" = field("Room Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Hostel Code", "Room Code", "Space Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /*
        rmsLedger.RESET;
        //rmsLedger.SETRANGE(rmsLedger."Hostel No","Asset No");
        rmsLedger.SETRANGE(rmsLedger."Room No","Room Code");
        rmsLedger.SETRANGE(rmsLedger."Space No","Space Code");
        IF rmsLedger.FIND('-') THEN BEGIN
          ERROR('Allocations exists for this Space. Clear the space first.');
        END;
         */

    end;
}

