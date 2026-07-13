Table 50367 Meetings
{

    fields
    {
        field(1; "Meeting ID"; Code[20]) { }
        field(2; Meeting; Code[100]) { }
        field(3; Date; Date) { }
        field(4; Time; Time) { }
        field(5; Status; Option)
        {
            OptionCaption = 'Open, Ended';
            OptionMembers = Open," Ended";
        }
        field(6; Description; Text[250]) { }
        field(7; AttendeePw; Text[250]) { }
        field(8; ModeratorPw; Text[250]) { }
    }

    keys
    {
        key(Key1; "Meeting ID", "Meeting")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        "Meeting ID" := NoSeriesMgt.GetNextNo('MEETING', 0D, true);
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
}

