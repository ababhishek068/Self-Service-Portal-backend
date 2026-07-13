#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50945 "Staff Orientation Checklist"
{

    fields
    {
        field(1;"Employee No";Code[20])
        {
        }
        field(2;Item;Code[10])
        {
        }
        field(3;Description;Text[250])
        {
        }
        field(4;Status;Option)
        {
            OptionCaption = 'Pending,Completed,Not Applicable';
            OptionMembers = Pending,Completed,"Not Applicable";
        }
        field(5;Timeline;Option)
        {
            OptionCaption = 'Prior to Start Date,First Day';
            OptionMembers = "Prior to Start Date","First Day";
        }
    }

    keys
    {
        key(Key1;"Employee No",Item)
        {
            Clustered = true;
        }
        key(Key2;Timeline)
        {
        }
    }

    fieldgroups
    {
    }
}

