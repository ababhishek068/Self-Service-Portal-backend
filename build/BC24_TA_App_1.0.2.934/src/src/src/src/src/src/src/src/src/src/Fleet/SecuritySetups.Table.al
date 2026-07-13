Table 50754 "Security Setups"
{
    LookupPageId = "Security Setups";
    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(2; "Visitors Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(3; "Students Sec. Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(4; "Employee Sec Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50001; "Legal Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50002; "Corporate No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50003; "Gate Pass No"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50004; "Gate Pass Return No"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50005; "Shift Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50006; "Incident Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50007; "Cleaners Shift Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50008; "File Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50009; "Mail Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50010; "Letigation Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50011; "Asset Movement Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50012; "ICT Serrvice/Mnt Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50013; "Risk Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50014; "Case Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
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

