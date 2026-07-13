Table 50381 "Phase Reporting Schedules"
{

    fields
    {
        field(1; Phase; Code[20])
        {
            TableRelation = "Grant Phases";
        }
        field(2; "Table ID"; Option)
        {
            OptionMembers = Partner,Donor;
        }
        field(3; "Partner/Donor"; Code[10])
        {
            TableRelation = if ("Table ID" = const(Partner)) "Project Partners" where("Grant No" = field(Project))
            else
            if ("Table ID" = const(Donor)) "Project Donors" where("Grant No" = field(Project));
        }
        field(4; Project; Code[10])
        {
            TableRelation = Jobs;
        }
        field(5; Months; Text[130]) { }
        field(6; "Reporting Date"; Date) { }
        field(7; Notified; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(8; "Audit Dates"; Date) { }
        field(50000; AlertSent; Boolean) { }
    }

    keys
    {
        key(Key1; Phase, "Table ID", Project, "Partner/Donor", "Reporting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

