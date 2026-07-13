Table 50088 "Students Hostel Rooms"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Space No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Hostel No"),
                                                              "Room Code" = field("Room No"),
                                                              Status = filter(Vaccant | "Partially Occupied"));

            trigger OnValidate()
            begin
                validateModification();
                CalcFields(Charges);

                Clear(settlementType);
                courseReg.Reset;
                courseReg.SetRange(courseReg."Student No.", Student);
                courseReg.SetRange(courseReg.Semester, Semester);
                //  courseReg.SETRANGE(courseReg."Academic Year","Academic Year");
                if courseReg.Find('-') then begin
                    courseReg.CalcFields("Global Settlement Type");
                    if prog.Get(courseReg.Programme) then begin
                        if prog."Special Programme" then
                            settlementType := Settlementtype::"Special Programme"
                        else
                            if courseReg."Global Settlement Type" = courseReg."Global Settlement Type"::KUCCPS then
                                settlementType := Settlementtype::KUCPPS
                            else
                                if courseReg."Global Settlement Type" = courseReg."Global Settlement Type"::PSSP then settlementType := Settlementtype::SSP;
                    end;
                end;
                Clear(billAmount);
                Rooms.Reset;
                Rooms.SetRange(Rooms."Hostel Code", "Hostel No");
                Rooms.SetRange(Rooms."Room Code", "Room No");
                if Rooms.Find('-') then begin
                    if settlementType = Settlementtype::"Special Programme" then
                        billAmount := Rooms."Special Programme"
                    else
                        if settlementType = Settlementtype::KUCPPS then
                            billAmount := Rooms."JAB Fees"
                        else
                            if settlementType = Settlementtype::SSP then
                                billAmount := Rooms."SSP Fees"
                end;
                Amount := billAmount;
            end;
        }
        field(3; "Room No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Hostel No"),
                                                                    "Vacant Spaces" = filter(> 0));

            trigger OnValidate()
            begin
                validateModification();
            end;
        }
        field(4; "Hostel No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Card"."Asset No" where(Gender = field("Student Gender"));

            trigger OnValidate()
            begin
                validateModification();
            end;
        }
        field(5; "Accomodation Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Allocation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Clearance Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Charges; Decimal)
        {
            CalcFormula = lookup("Hostel Card"."Cost Per Occupant" where("Asset No" = field("Hostel No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Student; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                validateModification();
            end;
        }
        field(10; Billed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Billed Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Semester; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Semesters.Code where("Current Semester" = const(true));
        }
        field(13; Cleared; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Over Paid"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Over Paid Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Eviction Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disciplinary Cases".Code;
        }
        field(17; Gender; Option)
        {
            CalcFormula = lookup(Customer.Gender where("No." = field(Student)));
            FieldClass = FlowField;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(18; "Hostel Assigned"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Hostel Name"; Text[50])
        {
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("Hostel No")));
            FieldClass = FlowField;
        }
        field(50000; "Student Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field(Student)));
            FieldClass = FlowField;
        }
        field(50001; "Academic Year"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Year".Code where(Current = const(true));
        }
        field(50002; Session; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Intake.Code;
        }
        field(50003; Allocated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; Balance; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Transfer to Hostel No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Card"."Asset No" where(Gender = field(Gender));
        }
        field(50007; "Transfer to Room No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Transfer to Hostel No"),
                                                                    "Vacant Spaces" = filter(> 0));
        }
        field(50008; "Transfer to Space No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Transfer to Hostel No"),
                                                              "Room Code" = field("Transfer to Room No"),
                                                              Status = filter(Vaccant));

            trigger OnValidate()
            begin
                Clear(settlementType);
                courseReg.Reset;
                courseReg.SetRange(courseReg."Student No.", Student);
                courseReg.SetRange(courseReg.Semester, Semester);
                //  courseReg.SETRANGE(courseReg."Academic Year","Academic Year");
                if courseReg.Find('-') then begin
                    if prog.Get(courseReg.Programme) then begin
                        if prog."Special Programme" then
                            settlementType := Settlementtype::"Special Programme"
                        else
                            if courseReg."Settlement Type" = 'JAB' then
                                settlementType := Settlementtype::KUCPPS
                            else
                                if courseReg."Settlement Type" = 'SSP' then settlementType := Settlementtype::SSP;
                    end;
                end;
                Clear(billAmount);
                Rooms.Reset;
                Rooms.SetRange(Rooms."Hostel Code", "Hostel No");
                Rooms.SetRange(Rooms."Room Code", "Room No");
                if Rooms.Find('-') then begin
                    if settlementType = Settlementtype::"Special Programme" then
                        billAmount := Rooms."Special Programme"
                    else
                        if settlementType = Settlementtype::KUCPPS then
                            billAmount := Rooms."JAB Fees"
                        else
                            if settlementType = Settlementtype::SSP then
                                billAmount := Rooms."SSP Fees"
                end;

                if billAmount > 0 then Charges := billAmount;
            end;
        }
        field(50009; Transfered; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; Switched; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Switched from Hostel No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Card"."Asset No" where(Gender = field(Gender));
        }
        field(50013; "Switched from Room No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Transfer to Hostel No"),
                                                                    Status = filter(Vaccant | "Partially Occupied"));
        }
        field(50014; "Switched from Space No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Transfer to Hostel No"),
                                                              "Room Code" = field("Transfer to Room No"),
                                                              Status = filter(Vaccant));

            trigger OnValidate()
            begin
                Clear(settlementType);
                courseReg.Reset;
                courseReg.SetRange(courseReg."Student No.", Student);
                courseReg.SetRange(courseReg.Semester, Semester);
                //  courseReg.SETRANGE(courseReg."Academic Year","Academic Year");
                if courseReg.Find('-') then begin
                    if prog.Get(courseReg.Programme) then begin
                        if prog."Special Programme" then
                            settlementType := Settlementtype::"Special Programme"
                        else
                            if courseReg."Settlement Type" = 'JAB' then
                                settlementType := Settlementtype::KUCPPS
                            else
                                if courseReg."Settlement Type" = 'SSP' then settlementType := Settlementtype::SSP;
                    end;
                end;
                Clear(billAmount);
                Rooms.Reset;
                Rooms.SetRange(Rooms."Hostel Code", "Hostel No");
                Rooms.SetRange(Rooms."Room Code", "Room No");
                if Rooms.Find('-') then begin
                    if settlementType = Settlementtype::"Special Programme" then
                        billAmount := Rooms."Special Programme"
                    else
                        if settlementType = Settlementtype::KUCPPS then
                            billAmount := Rooms."JAB Fees"
                        else
                            if settlementType = Settlementtype::SSP then
                                billAmount := Rooms."SSP Fees"
                end;

                if billAmount > 0 then Charges := billAmount;
            end;
        }
        field(50015; "Switched to Hostel No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Card"."Asset No" where(Gender = field(Gender));
        }
        field(50016; "Switched to Room No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Switched to Hostel No"),
                                                                    Status = filter("Fully Occupied" | "Partially Occupied"));
        }
        field(50017; "Switched to Space No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Switched to Hostel No"),
                                                              "Room Code" = field("Switched to Room No"),
                                                              Status = filter("Fully Occupied"));

            trigger OnValidate()
            begin
                Clear(settlementType);
                courseReg.Reset;
                courseReg.SetRange(courseReg."Student No.", Student);
                courseReg.SetRange(courseReg.Semester, Semester);
                //  courseReg.SETRANGE(courseReg."Academic Year","Academic Year");
                if courseReg.Find('-') then begin
                    if prog.Get(courseReg.Programme) then begin
                        if prog."Special Programme" then
                            settlementType := Settlementtype::"Special Programme"
                        else
                            if courseReg."Settlement Type" = 'JAB' then
                                settlementType := Settlementtype::KUCPPS
                            else
                                if courseReg."Settlement Type" = 'SSP' then settlementType := Settlementtype::SSP;
                    end;
                end;
                Clear(billAmount);
                Rooms.Reset;
                Rooms.SetRange(Rooms."Hostel Code", "Hostel No");
                Rooms.SetRange(Rooms."Room Code", "Room No");
                if Rooms.Find('-') then begin
                    if settlementType = Settlementtype::"Special Programme" then
                        billAmount := Rooms."Special Programme"
                    else
                        if settlementType = Settlementtype::KUCPPS then
                            billAmount := Rooms."JAB Fees"
                        else
                            if settlementType = Settlementtype::SSP then
                                billAmount := Rooms."SSP Fees"
                end;

                if billAmount > 0 then Charges := billAmount;
            end;
        }

        field(50019; "Transfed from Room No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Transfer to Hostel No"),
                                                                    Status = filter(Vaccant | "Partially Occupied"));
        }
        field(50020; "Transfed from Space No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Room Spaces"."Space Code" where("Hostel Code" = field("Transfer to Hostel No"),
                                                              "Room Code" = field("Transfer to Room No"),
                                                              Status = filter(Vaccant));

            trigger OnValidate()
            begin
                Clear(settlementType);
                courseReg.Reset;
                courseReg.SetRange(courseReg."Student No.", Student);
                courseReg.SetRange(courseReg.Semester, Semester);
                //  courseReg.SETRANGE(courseReg."Academic Year","Academic Year");
                if courseReg.Find('-') then begin
                    if prog.Get(courseReg.Programme) then begin
                        if prog."Special Programme" then
                            settlementType := Settlementtype::"Special Programme"
                        else
                            if courseReg."Settlement Type" = 'JAB' then
                                settlementType := Settlementtype::KUCPPS
                            else
                                if courseReg."Settlement Type" = 'SSP' then settlementType := Settlementtype::SSP;
                    end;
                end;
                Clear(billAmount);
                Rooms.Reset;
                Rooms.SetRange(Rooms."Hostel Code", "Hostel No");
                Rooms.SetRange(Rooms."Room Code", "Room No");
                if Rooms.Find('-') then begin
                    if settlementType = Settlementtype::"Special Programme" then
                        billAmount := Rooms."Special Programme"
                    else
                        if settlementType = Settlementtype::KUCPPS then
                            billAmount := Rooms."JAB Fees"
                        else
                            if settlementType = Settlementtype::SSP then
                                billAmount := Rooms."SSP Fees"
                end;

                if billAmount > 0 then Charges := billAmount;
            end;
        }
        field(50021; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Booking,Allocated';
            OptionMembers = Booking,Allocated;
        }
        field(50022; "Invoice Printed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Invoice Printed By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Swithed By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Transfered By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Reverse Allocated By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Key Allocated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Key No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Allocated By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Time allocated"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Time Reversed"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Time Transfered"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Time Swithed"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50037; "Date Reversed"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Date Transfered"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; "Date Switched"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Key Allocated By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50041; "Key Allocated Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Key Allocated Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Reversed By"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Switched By"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "Start Date"; Date)
        {
            CalcFormula = lookup("Course Registration"."Registration Date" where("Student No." = field(Student),
                                                                                  Semester = field(Semester)));
            FieldClass = FlowField;
        }

        field(50048; "Settlement Type"; Code[10])
        {
            CalcFormula = lookup("Course Registration"."Settlement Type" where("Student No." = field(Student),
                                                                                Semester = field(Semester)));
            FieldClass = FlowField;
        }
        field(50049; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Space Status"; Option)
        {
            CalcFormula = lookup("Room Spaces".Status where("Hostel Code" = field("Hostel No"),
                                                             "Space Code" = field("Space No")));
            FieldClass = FlowField;
            OptionCaption = 'Vaccant,Partially Occupied,Fully Occupied,Black-Listed,Partially Booked,Fully Booked,Reserved';
            OptionMembers = Vaccant,"Partially Occupied","Fully Occupied","Black-Listed","Partially Booked","Fully Booked",Reserved;
        }
        field(50051; "Booked Space Count"; Integer)
        {
            CalcFormula = count("Hostel Booking Agents" where("Room Space" = field("Space No"),
                                                               "Room No" = field("Room No"),
                                                               "Payment Status" = const(Confirmed)));
            FieldClass = FlowField;
        }
        field(50052; "Vacant Count"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Hostel No"),
                                                     "Room Code" = field("Room No"),
                                                     Status = filter(Vaccant)));
            FieldClass = FlowField;
        }
        field(50053; "Entry Count"; Integer)
        {
            CalcFormula = count("Hostel Ledger" where("Student No" = field(Student)));
            FieldClass = FlowField;
        }
        field(50054; "Space EXists"; Integer)
        {
            CalcFormula = count("Room Spaces" where("Hostel Code" = field("Hostel No"),
                                                     "Room Code" = field("Room No")));
            FieldClass = FlowField;
        }
        field(50055; "Student Count"; Integer)
        {
            CalcFormula = count("Students Hostel Rooms" where(Student = field(Student),
                                                               Cleared = const(false)));
            FieldClass = FlowField;
        }
        field(50056; "Booking Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "Booking Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50058; "Fee Balance"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field(Student)));
            FieldClass = FlowField;
        }
        field(50059; "Bill Accomodation"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Student No." = field(Student),
                                                              Code = filter('ACCOMODATION')));
            FieldClass = FlowField;
        }
        field(50060; Stage; Code[20])
        {
            CalcFormula = lookup("Course Registration".Stage where("Student No." = field(Student),
                                                                    Semester = field(Semester),
                                                                    Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(50061; "Posted Accomodation Amount"; Decimal)
        {
            CalcFormula = sum("Student Charges".Amount where("Student No." = field(Student),
                                                              Semester = field(Semester),
                                                              Reversed = filter(false),
                                                              Recognized = const(true)));
            FieldClass = FlowField;
        }
        field(50062; "Transfed from Hostel No"; Code[20]) { }
        field(50063; "Student Gender"; Option)
        {

            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
    }

    keys
    {
        key(Key1; Student, "Line No", "Student Gender")
        {
            Clustered = true;
        }
        key(Key2; "Hostel No") { }
        key(Key3; "Line No") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

        // validateModification();
    end;

    trigger OnInsert()
    begin
        /*
         AcadYear.RESET;
        AcadYear.SETRANGE(AcadYear.Current,TRUE);
        IF AcadYear.FIND('-') THEN BEGIN
          Sem.RESET;
          Sem.SETRANGE(Sem."Current Semester",TRUE);
          IF Sem.FIND('-') THEN BEGIN
            courseReg.RESET;
            courseReg.SETRANGE(courseReg."Student No.",Student);
          //  courseReg.SETRANGE(courseReg."Academic Year",AcadYear.Code);
            courseReg.SETRANGE(courseReg.Semester,Sem.Code);
            IF NOT (courseReg.FIND('-')) THEN ERROR('The student has not been registered for the current Academic Year.');
              "Academic Year":=AcadYear.Code;
              Semester:=Sem.Code;
              // Pick Accommondation fees and the student balance.
               IF cust.GET(Student) THEN BEGIN
                cust.CALCFIELDS(cust."Balance (LCY)");
                Balance:=cust."Balance (LCY)";
               END;
               stageCharges.RESET;
               stageCharges.SETRANGE(stageCharges."Programme Code",courseReg.Programme);
               stageCharges.SETRANGE(stageCharges."Stage Code",courseReg.Stage);
               stageCharges.SETRANGE(stageCharges."Settlement Type",courseReg."Settlement Type");
               stageCharges.SETRANGE(stageCharges.Code,'ACCOMMODATION');
               IF stageCharges.FIND('-') THEN BEGIN
              //  Charges:=stageCharges.Amount;
               // Billed:=stageCharges.Amount;
                IF cust."Balance (LCY)"<0 THEN BEGIN "Over Paid":=TRUE;
                "Over Paid Amt":=cust."Balance (LCY)"-stageCharges.Amount;
                END;

               END;// ELSE ERROR('Accommodation missing in the fee setup for: Prog:-'+courseReg.Programme+' Stage:- '+courseReg.Stage+' Type:- '+courseReg."Settlement Type");
             //  IF courseReg."Settlement Type"='"SCHOOL BASED"' THEN Charges:=4000;
             //  IF courseReg."Settlement Type"='REGULAR' THEN Charges:=8000;
          END ELSE ERROR('The Current Semester has not been set.\Consult the system administrator.');
        END ELSE ERROR('The Current academic year has not been set.');
          */
        "Allocation Date" := Today;

    end;

    var
        courseReg: Record "Course Registration";
        AcadYear: Record "Academic Year";
        Sem: Record Semesters;
        Rooms: Record "Hostel Block Rooms";
        prog: Record Programme;
        settlementType: Option ,KUCPPS,SSP,"Special Programme";
        billAmount: Decimal;

    local procedure validateModification()
    begin
        if ((Allocated)) then Error('Deletion/Modification of allocated Record is not allowed');

        Sem.Reset;
        Sem.SetRange("Current Semester", true);
        if Sem.Find('-') then Semester := Sem.Code;

        AcadYear.Reset;
        AcadYear.SetRange(Current, true);
        if AcadYear.Find('-') then "Academic Year" := AcadYear.Code;
    end;
}

