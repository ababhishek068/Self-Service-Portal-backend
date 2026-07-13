Table 50368 "Meeting Participant"
{

    fields
    {
        field(1; "Meeting ID"; Code[20]) { }
        field(2; Participant; Code[20]) { }
        field(3; "Participant Name"; Text[250]) { }
        field(4; "Type of Participant"; Option)
        {
            OptionCaption = 'Internal, External';
            OptionMembers = Internal," External";
        }
        field(5; Email; Text[100]) { }
        field(6; "Phone Number"; Text[30]) { }
        field(7; "Invite Sent"; Boolean) { }
        field(8; "Is Moderator"; Boolean) { }
    }

    keys
    {
        key(Key1; "Meeting ID", Participant)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

