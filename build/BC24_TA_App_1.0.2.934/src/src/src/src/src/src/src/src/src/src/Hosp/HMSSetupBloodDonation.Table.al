Table 50577 "HMS Setup Blood Donation"
{
    //LookupPageID = UnknownPage70135129;

    fields
    {
        field(1; Donor; Code[20])
        {
            Description = 'Stores the reference to the donor code';
            NotBlank = true;
            TableRelation = "HMS Setup Blood Group".Code;
        }
        field(2; Recipient; Code[20])
        {
            Description = 'Stores the reference to the recipient code';
            NotBlank = true;
            TableRelation = "HMS Setup Blood Group".Code;
        }
        field(3; Remarks; Text[100])
        {
            Description = 'Stores any remarks that the user might make in relation to the donation matrix';
        }
    }

    keys
    {
        key(Key1; Donor, Recipient)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

