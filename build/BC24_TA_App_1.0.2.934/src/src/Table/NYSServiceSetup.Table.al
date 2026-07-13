Table 50175 "NYS Service Setup"
{

    fields
    {
        field(1; "Service Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(111; "Serial Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(2; "Deployment Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Duty Allocation Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Disciplinary Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Complain Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }

        field(10; "Transfer Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Clearance Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Training Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }





    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

