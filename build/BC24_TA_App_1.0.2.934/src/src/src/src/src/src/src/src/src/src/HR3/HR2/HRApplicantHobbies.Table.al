Table 50158 "HR Applicant Hobbies"
{

    fields
    {
        field(1; "Job Application No"; Code[20])
        {
            // TableRelation = Applicants."Application No";
        }
        field(2; Hobby; Text[200]) { }
        field(4; "Applicant No"; Integer) { }
        field(5; Interests; Text[200]) { }
        field(6; "Community Services"; Text[100]) { }
        field(7; "Major Achievements"; Text[100]) { }
        field(8; "User Name"; Code[30]) { }
        field(9; "Email Address"; Code[30]) { }
        field(10; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(11; "Religious Affiliation"; Option)
        {
            OptionCaption = 'Default,Christian,Muslim,Hindu,Other';
            OptionMembers = Default,Christian,Muslim,Hindu,Other;
        }
        field(12; "Attending Church"; Option)
        {
            OptionCaption = 'Default,Yes,No';
            OptionMembers = Default,Yes,No;
        }
        field(13; "Church Address"; Text[150]) { }
        field(14; "Pastors Name"; Text[100]) { }
        field(15; "Church Activities"; Text[200]) { }
        field(16; "Accept Christ"; Text[200]) { }
        field(17; "Personal Ministry"; Text[200]) { }
        field(18; "Applicant Names"; Text[200]) { }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

