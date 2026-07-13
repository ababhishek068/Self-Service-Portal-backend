Table 50153 "HMS Doctor Queue"
{

    fields
    {
        field(1; "Patient No"; Code[20])
        {
            TableRelation = "HMS Patient"."Patient No.";
        }
        field(2; "Visit No"; Code[20]) { }
        field(3; "Document No"; Code[20])
        {
            TableRelation = if (Type = const('CONSULTATION')) "HMS Treatment Form Header"."Treatment No." where("Treatment No." = field("Document No"))
            else
            if (Type = const('LABORATORY')) "HMS Laboratory Form Header"."Laboratory No." where("Laboratory No." = field("Document No"))
            else
            if (Type = const('RADIOLOGY')) "HMS Radiology Form Header"."Radiology No." where("Radiology No." = field("Document No"));
        }
        field(4; Type; Code[20]) { }
        field(5; "Doctor ID"; Code[20]) { }
        field(6; Status; Option)
        {
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(7; Date; Date) { }
        field(8; Time; Time) { }
        field(9; "Closed Time"; Time) { }
        field(10; "Closed Date"; Date) { }
        field(11; "Queue Type"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Patient No", "Visit No", "Document No")
        {
            Clustered = true;
        }
        key(Key2; "Visit No") { }
        key(Key3; "Document No") { }
        key(Key4; "Queue Type") { }
    }

    fieldgroups { }
}

