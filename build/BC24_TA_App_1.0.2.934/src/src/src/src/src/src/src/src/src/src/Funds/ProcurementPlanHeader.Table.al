Table 50890 "Procurement Plan Header"
{
    DrillDownPageID = "Procurement Plan list";
    LookupPageID = "Procurement Plan list";

    fields
    {
        field(1; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(2; "Global Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(3; "Global Dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(4; "Procurement Plan Period"; Code[20])
        {
            TableRelation = "Procurement Plan Period".Code;
        }
        field(5; "Status"; Option)
        {
            OptionMembers = Open,"Pending Approval","Approved","Rejected";
        }

    }

    keys
    {
        key(Key1; "Budget Name", "Global Dimension 1", "Global Dimension 2", "Procurement Plan Period")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

