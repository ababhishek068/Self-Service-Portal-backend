Table 50572 "HMS Setup Radiology Type"
{
    DataCaptionFields = Description, "Code";
    //   DrillDownPageID = UnknownPage70135119;
    //  LookupPageID = UnknownPage70135119;

    fields
    {
        field(1; "Code"; Code[30])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            NotBlank = true;
        }
        field(3; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(4; Amount; Decimal) { }
        field(5; "Insurance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Radiology Section"; Code[20]) { }
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
        fieldgroup(Brick; Description, "Code", "G/L Account") { }
    }
}

