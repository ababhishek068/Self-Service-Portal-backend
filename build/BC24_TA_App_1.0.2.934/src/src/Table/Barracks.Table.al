Table 50203 "Barracks"
{

    LookupPageId = Barracks;
    fields
    {
        field(1; Code; Code[50])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150]) { }
        field(3; "Gender"; option)
        {
            OptionMembers = ,Male,Female;
            DataClassification = ToBeClassified;

        }
        field(4; Capacity; Integer) { }
        field(5; "Paramilitary Academy"; Code[20])
        {
            TableRelation = "Paramilitary Academy".Code;
        }
        field(6; Brigate; Code[20])
        {
            TableRelation = Brigade.Code where("Paramilitary Academy" = field("Paramilitary Academy"));
        }
        field(7; "Skip Booking"; Boolean) { }
    }

    keys
    {
        key(Key1; code)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

