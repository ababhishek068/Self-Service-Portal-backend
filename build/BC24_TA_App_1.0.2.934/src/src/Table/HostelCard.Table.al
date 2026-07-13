Table 50370 "Hostel Card"
{


    fields
    {
        field(1; "Asset No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";
        }
        field(2; Discription; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Total Rooms"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Space Per Room"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Cost Per Occupant"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Male,Female;
        }
        field(7; Location; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Programme; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Cost per Room"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Room Prefix"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Minimum Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Starting No"; Integer)
        {
            DataClassification = ToBeClassified;
            InitValue = 1;
        }
        field(13; "Total Rooms Created"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Hostel No" = field("Asset No")));
            FieldClass = FlowField;
        }
        field(14; "Total Vacant"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Hostel No" = field("Asset No"),
                                                       Status = filter(Vaccant)));
            FieldClass = FlowField;
        }
        field(15; "Total Occupied"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Hostel No" = field("Asset No"),
                                                       Status = filter("Partially Occupied")));
            FieldClass = FlowField;
        }
        field(16; "Total Out of Order"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Hostel No" = field("Asset No"),
                                                       Status = filter("Fully Occupied")));
            FieldClass = FlowField;
        }
        field(17; "Hostel Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Internal,"Out Sourced";
        }
        field(18; "Provider Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(50000; "Campus Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50001; Vaccant; Integer)
        {
            CalcFormula = count("Hostel Block Rooms" where("Hostel Code" = field("Asset No"),
                                                            Status = filter(Vaccant)));
            FieldClass = FlowField;
        }
        field(50002; "Fully Occupied"; Integer)
        {
            CalcFormula = count("Hostel Block Rooms" where("Hostel Code" = field("Asset No"),
                                                            Status = filter("Fully Occupied")));
            FieldClass = FlowField;
        }
        field(50003; Blacklisted; Integer)
        {
            CalcFormula = count("Hostel Block Rooms" where("Hostel Code" = field("Asset No"),
                                                            Status = filter("Black-Listed")));
            FieldClass = FlowField;
        }
        field(50004; "Partially Occupied"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Asset No"),
                                                     Status = filter("Partially Occupied")));
            FieldClass = FlowField;
        }
        field(50005; "JAB Fees"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validateCosts();
            end;
        }
        field(50006; "SSP Fees"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validateCosts();
            end;
        }
        field(50007; "Special Programme"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                validateCosts();
            end;
        }
        field(50008; "Rooms Generated"; Integer)
        {
            CalcFormula = count("Hostel Block Rooms" where("Hostel Code" = field("Asset No")));
            FieldClass = FlowField;
        }
        field(50009; "Room Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Asset No"),
                                                     Status = filter(<> "Black-Listed")));
            FieldClass = FlowField;
        }
        field(50010; "Vaccant Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Asset No"),
                                                     Status = filter(Vaccant),
                                                     "Room Not Availlable" = filter(false)));
            FieldClass = FlowField;
        }
        field(50011; "Occupied Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Asset No"),
                                                     Status = filter("Fully Occupied" | "Fully Booked")));
            FieldClass = FlowField;
        }
        field(50012; "Booked Space Count"; Integer)
        {
            CalcFormula = count("Hostel Booking Agents" where("Hostel Name" = field("Asset No")));
            FieldClass = FlowField;
        }

        field(50913; "Meals Inclusive"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Not Available"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                rooms.Reset;
                rooms.SetRange(rooms."Hostel Code", "Asset No");
                if rooms.Find('-') then begin
                    repeat
                    begin
                        rooms."Not Availlable" := "Not Available";
                        rooms.Modify;
                    end;
                    until rooms.Next = 0;
                end;
            end;
        }
        field(50014; "Reserved Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Asset No"),
                                                     Status = filter(Vaccant),
                                                     "Room Not Availlable" = filter(true)));
            FieldClass = FlowField;
        }
        field(50015; "Booking Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Partially Booked,Fully Booked';
            OptionMembers = " ","Partially Booked","Fully Booked";
        }
        field(50016; "Catering Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Charge.Code;
            trigger OnValidate()
            var
                Charge: record charge;
            begin
                if Charge.get("Catering Charge Code") then
                    "Catering Charge Amount" := Charge.Amount;
            end;
        }
        field(50017; "Catering Charge Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50018; "Hostel Charge"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Charge.Code;
        }
    }

    keys
    {
        key(Key1; "Asset No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        rmsLedger.Reset;
        rmsLedger.SetRange(rmsLedger."Hostel No", "Asset No");
        if rmsLedger.Find('-') then begin
            Error('Allocations exists for this Hostel Block. Clear the rooms/spaces first.');
        end;

        rooms.Reset;
        rooms.SetRange(rooms."Hostel Code", "Asset No");
        if rooms.Find('-') then begin
            rooms.DeleteAll;
        end;

        rmspcs.Reset;
        rmspcs.SetRange(rmspcs."Hostel Code", "Asset No");
        if rmspcs.Find('-') then begin
            rmspcs.DeleteAll;
        end;

        rmsLedger.Reset;
        rmsLedger.SetRange(rmsLedger."Hostel No", "Asset No");
        if rmsLedger.Find('-') then begin
            rmsLedger.DeleteAll;
        end;
    end;

    var
        rooms: Record "Hostel Block Rooms";
        rmspcs: Record "Room Spaces";
        rmsLedger: Record "Hostel Ledger";

    local procedure validateCosts()
    begin
        rooms.Reset;
        rooms.SetRange(rooms."Hostel Code", "Asset No");
        if rooms.Find('-') then begin
            repeat
            begin
                rooms.Validate(rooms."Room Code");
            end;
            until rooms.Next = 0;
        end;
    end;
}

