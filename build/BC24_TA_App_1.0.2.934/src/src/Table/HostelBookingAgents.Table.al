Table 50020 "Hostel Booking Agents"
{

    fields
    {
        field(1; No; Code[20])
        {
            // TableRelation = "Admission Form Header"."Admission No.";
        }
        field(2; "Surname Name"; Text[50]) { }
        field(3; Mobile; Code[20]) { }
        field(4; "Other Name"; Code[50]) { }
        field(5; Email; Text[50]) { }
        field(6; Customer; Code[20]) { }
        field(7; "Hostel Name"; Code[20])
        {
            TableRelation = "Hostel Card"."Asset No";
        }
        field(8; "Room No"; Code[10])
        {
            TableRelation = "Hostel Block Rooms"."Room Code" where("Hostel Code" = field("Hostel Name"));
        }
        field(9; Remarks; Text[30]) { }
        field(10; "Room Type"; Text[30]) { }
        field(11; Rate; Decimal) { }
        field(12; Billed; Boolean) { }
        field(13; "Billed Date"; Date) { }
        field(14; "Booked Date"; Date) { }
        field(15; "Check Out Date"; Date) { }
        field(16; Pax; Integer) { }
        field(17; "Total Amount"; Decimal) { }
        field(18; "Room Status"; Option)
        {
            OptionMembers = OCCUPIED,"OUT OF ORDER",VACANT,"SLEEP OUT","EARLY ARRIVAL","CHECK OUT";
        }
        field(19; "Other Names"; Text[50]) { }
        field(20; "Index Number"; Code[50]) { }
        field(21; Course; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(22; "Given  Room"; Boolean)
        {
            Editable = false;
        }
        field(23; Gender; Option)
        {
            OptionCaption = ',Male,Female';
            OptionMembers = ,Male,Female;
        }
        field(24; "Academic Year"; Code[20])
        {
            TableRelation = "Academic Year".Code;
        }
        field(25; Semester; Code[20])
        {
            TableRelation = Semesters.Code;
        }
        field(26; "Room Space"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Room Spaces"."Space Code";
        }
        field(27; "Payment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,Confirmed,Rejected';
            OptionMembers = Pending,Confirmed,Rejected;

            trigger OnValidate()
            begin
                /* if "Payment Status" = "payment status"::Pending then begin
                    if AdmissionFormHeader.Get(No) then begin
                        AdmissionFormHeader.CalcFields("Paid Fees");
                        AdmissionFormHeader.CalcFields("Tuition Fees");
                        AdmissionFormHeader.CalcFields("Charges Fees");
                        if AdmissionFormHeader."Paid Fees" >= (AdmissionFormHeader."Tuition Fees" + AdmissionFormHeader."Charges Fees" + "Total Amount") then begin
                            "Payment Status" := "payment status"::Confirmed;
                            Modify;
                        end;
                    end;
                end; */
            end;
        }
        field(28; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(29; "Total Fees Payable"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Paid Fees"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Booking Timestamp"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Booking Count"; Integer)
        {
            CalcFormula = count("Hostel Booking Agents" where("Room Space" = field("Room Space"),
                                                               "Payment Status" = const(Confirmed)));
            FieldClass = FlowField;
        }
        field(33; "Allocation Count"; Integer)
        {
            CalcFormula = count("Students Hostel Rooms" where("Space No" = field("Room Space"),
                                                               Billed = const(true),
                                                               Cleared = const(false)));
            FieldClass = FlowField;
        }
        field(34; "Admitted Student No"; Code[20])
        {
            CalcFormula = lookup(Customer."No." where("Application No." = field(No)));
            FieldClass = FlowField;
        }
        field(35; "Student No"; Code[20])
        {
            CalcFormula = lookup(Customer."No." where("Application No." = field(No)));
            FieldClass = FlowField;
        }
        field(36; "Paid Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Bank Transactions Buffer".Amount where("Student No." = field(No)));

        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /*IF  ADM.GET(AdmissionFormHeader."Admission No.")  THEN BEGIN
          ADM.INIT;
         // IF  Rec.GET(AdmissionFormHeader."Admission No.")  THEN BEGIN
            ADM."Surname Name":=AdmissionFormHeader.Surname;
            ADM."Other Name":=AdmissionFormHeader."Other Names";
            ADM."Booked Date":=TODAY;
            ADM."Index Number":=AdmissionFormHeader."Index Number";
            ADM.Gender:=AdmissionFormHeader.Gender;
            ADM.INSERT;



       END ;
       */

    end;

    var
    //AdmissionFormHeader: Record "Admission Form Header";
    // Semesters: Record Semesters;
    // ADM: Record "Admission Form Header";
}

