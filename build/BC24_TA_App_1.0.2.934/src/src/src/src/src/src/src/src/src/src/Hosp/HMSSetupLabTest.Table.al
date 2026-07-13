Table 50568 "HMS Setup Lab Test"
{
    DataCaptionFields = "Code", Description;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100]) { }
        field(3; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; Amount; Decimal) { }
        field(5; "Insurance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Test Type"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Description) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description, "Code") { }
        fieldgroup(Brick; Description, "Code", Amount) { }
    }
}

