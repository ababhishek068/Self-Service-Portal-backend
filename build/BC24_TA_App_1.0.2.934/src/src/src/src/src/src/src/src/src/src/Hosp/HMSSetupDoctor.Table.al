Table 50563 "HMS Setup Doctor"
{
    DataCaptionFields = "Doctor ID", "Doctors Name";
    //DrillDownPageID = UnknownPage70135105;
    // LookupPageID = UnknownPage70135105;

    fields
    {
        field(1; "Doctor ID"; Code[20])
        {
            Description = 'Stores the reference to the user in the database';
            NotBlank = true;
            TableRelation = Vendor."No.";
        }
        field(2; "Doctors Name"; Text[30])
        {
            Description = 'Stores the reference to the doctor''s name in the database';
            NotBlank = true;
        }
        field(3; "Consultation Code"; Code[20])
        {
            TableRelation = "HMS Charges".Code;
        }
        field(4; "Commission Perc"; Decimal) { }
        field(5; Specialization; Code[20]) { }
        field(6; Telephone; Text[30]) { }
        field(7; "Proffesional Registration No."; Code[20]) { }
        field(8; Resident; Boolean) { }
        field(9; "PIN No"; Text[30]) { }
        field(10; Email; Text[30]) { }
        field(11; Title; Text[30]) { }
        field(12; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(13; "HDF%"; Decimal) { }
        field(14; "Insurance No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Customer."No.";
        }
        field(15; "Pending Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(16; "Completed Filter"; Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(17; "Open Charges"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Doctor ID" = field("Doctor ID"),
                                                                          Claimed = const(false),
                                                                          Medicentre = const(false),
                                                                          Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(18; "Claimed Charges"; Decimal)
        {
            CalcFormula = sum("HMS Patient Charges"."Total Amount" where("Doctor ID" = field("Doctor ID"),
                                                                          Claimed = const(true),
                                                                          Medicentre = const(false),
                                                                          Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(19; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(20; "Consultation Code Cash"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HMS Charges".Code;
        }
    }

    keys
    {
        key(Key1; "Doctor ID")
        {
            Clustered = true;
        }
        key(Key2; "Doctors Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Doctors Name", "Doctor ID") { }
        fieldgroup(Brick; "Doctors Name", "Doctor ID", "Consultation Code") { }
    }
}

