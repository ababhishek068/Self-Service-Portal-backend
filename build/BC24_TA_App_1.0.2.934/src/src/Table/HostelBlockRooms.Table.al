Table 50052 "Hostel Block Rooms"
{

    fields
    {
        field(1; "Hostel Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '"Hostel Card"."Asset No"';
        }
        field(2; "Room Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                hostel.Reset;
                hostel.SetRange(hostel."Asset No", "Hostel Code");
                if hostel.Find('-') then begin
                    "JAB Fees" := hostel."JAB Fees";
                    "SSP Fees" := hostel."SSP Fees";
                    "Special Programme" := hostel."Special Programme";
                    // MODIFY;
                end;
            end;
        }
        field(3; "Bed Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Hostel Code"),
                                                     "Room Code" = field("Room Code"),
                                                     Status = filter(<> "Black-Listed")));
            FieldClass = FlowField;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Vaccant,Partially Occupied,Fully Occupied,Black-Listed,Partially Booked,Fully Booked,Out of Order,Reserved';
            OptionMembers = Vaccant,"Partially Occupied","Fully Occupied","Black-Listed","Partially Booked","Fully Booked","Out of Order",Reserved;

            trigger OnValidate()
            begin
                /* CALCFIELDS("Bed Spaces","Occupied Spaces");
                  IF "Occupied Spaces"=0 THEN BEGIN
                  Status:=Status::Vaccant;
                  MODIFY;
                 END ELSE  IF "Occupied Spaces"<"Bed Spaces" THEN BEGIN
                  Status:=Status::"Partially Occupied";
                  MODIFY;
                  END ELSE IF "Occupied Spaces"="Bed Spaces" THEN BEGIN
                  Status:=Status::"Fully Occupied";
                  MODIFY;
                 END ELSE IF "Occupied Spaces">"Bed Spaces" THEN  ERROR('You can not allocate more than the available spaces!');
                                            */
                if hostel.Get("Hostel Code") then begin
                    hostel.CalcFields(Vaccant);
                    if hostel.Vaccant = 0 then
                        hostel."Booking Status" := hostel."booking status"::"Fully Booked"
                    else
                        hostel."Booking Status" := hostel."booking status"::" ";
                    hostel.Modify;
                end;

            end;
        }
        field(5; "Room Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Reservation Remarks"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Reservation UserID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Reservation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Black List reason"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Occupied Spaces"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Hostel No" = field("Hostel Code"),
                                                       "Room No" = field("Room Code"),
                                                       Status = filter("Fully Booked" | "Fully Occupied")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                /*CALCFIELDS("Bed Spaces","Occupied Spaces");
                 IF "Occupied Spaces"=0 THEN BEGIN
                 Status:=Status::Vaccant;
                 MODIFY;
                END ELSE  IF "Occupied Spaces"<"Bed Spaces" THEN BEGIN
                 Status:=Status::"Partially Occupied";
                 MODIFY;
                 END ELSE IF "Occupied Spaces"="Bed Spaces" THEN BEGIN
                 Status:=Status::"Fully Occupied";
                 MODIFY;
                END ELSE IF "Occupied Spaces">"Bed Spaces" THEN  ERROR('You can not allocate more than the available spaces!');  */

            end;
        }
        field(50005; "JAB Fees"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "SSP Fees"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Special Programme"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Total Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Hostel Code"),
                                                     "Room Code" = field("Room Code")));
            FieldClass = FlowField;
        }
        field(50010; "Vacant Spaces"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Hostel Code"),
                                                     "Room Code" = field("Room Code"),
                                                     Status = filter(Vaccant)));
            FieldClass = FlowField;
        }
        field(50011; "Room Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "No of Spaces"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Not Availlable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; Programme; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Programme.Code;
        }
        field(50015; Stage; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Programme Stages".Code where("Programme Code" = field(Programme));
        }
    }

    keys
    {
        key(Key1; "Hostel Code", "Room Code")
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
        IF rmsLedger.FIND('-') THEN BEGIN
          ERROR('Allocations exists for this Room. Clear the room/spaces first.');
        END;
        
              roomspaces.RESET;
            roomspaces.SETRANGE(roomspaces."Room Code","Room Code");
            roomspaces.SETFILTER(roomspaces.Status,'<>%1',roomspaces.Status::Vaccant);
            IF roomspaces.FIND('-') THEN BEGIN
           //  ERROR('There are some occupied spaces in the room');
            END;
        
            roomspaces.RESET;
            roomspaces.SETRANGE(roomspaces."Room Code","Room Code");
            IF roomspaces.FIND('-') THEN BEGIN
          roomspaces.DELETEALL;
            END;// error('There are some occupied spaces in the room');
        */

    end;

    var
        hostel: Record "Hostel Card";
}

