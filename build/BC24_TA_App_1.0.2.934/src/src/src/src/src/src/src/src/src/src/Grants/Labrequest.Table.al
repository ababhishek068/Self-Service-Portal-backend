Table 50395 "Lab request"
{
    // DrillDownPageID = UnknownPage70134739;
    //  LookupPageID = UnknownPage70134739;

    fields
    {
        field(1; "Proposal No."; Code[50])
        {
            TableRelation = Jobs."No.";
        }
        field(3; "Study Purpose/Use"; Text[100]) { }
        field(4; "Study Synopsis Attached"; Boolean) { }
        field(5; "Lab Testing Algorithm Known"; Boolean) { }
        field(6; "Test schedule/Vol./Repertoire"; Text[100]) { }
        field(7; "All Test Covered by Test List"; Boolean) { }
        field(8; "Test List Description"; Text[100])
        {
            Description = 'l';
        }
        field(9; "Specimen/Isolates Processing"; Boolean) { }
        field(10; "Specimen/Isolates Process Desc"; Text[100]) { }
        field(11; "Special Storage Required"; Boolean) { }
        field(12; "Destroy Samples Per Protocol"; Boolean) { }
        field(13; "Samples need to be Shipped"; Boolean) { }
        field(14; "Samples Shipped Desc"; Text[100]) { }
        field(15; "Special Data/H.copy Storage"; Boolean) { }
        field(16; "Special Data/H.copy Desc."; Text[100]) { }
        field(17; "Special Staff/working hrs Req."; Boolean) { }
        field(18; "Special Staff/working hrs Desc"; Text[100]) { }
        field(19; "Exp/Imp Permits Required"; Option)
        {
            OptionCaption = 'Yes,No,Pending';
            OptionMembers = Yes,No,Pending;
        }
        field(20; "IREC Approval"; Option)
        {
            OptionCaption = 'Yes,No,Pending';
            OptionMembers = Yes,No,Pending;
        }
        field(21; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(22; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
        }
    }

    keys
    {
        key(Key1; "Proposal No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

