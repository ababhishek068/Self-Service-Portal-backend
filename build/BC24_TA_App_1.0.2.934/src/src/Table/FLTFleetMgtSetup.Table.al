Table 50862 "FLT-Fleet Mgt Setup"
{
    LookupPageId = "FLT Fleet Mgt Setup";
    fields
    {
        field(1; "Transport Req No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(2; "Daily Work Ticket"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Fuel Register"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Maintenance Request"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; Missing; Code[10]) { }
        field(8; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(9; "missing 2"; Text[30]) { }
        field(10; "Driver Rotation"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Rotation Interval"; DateFormula) { }
        field(12; "Fuel Payment Batch No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Work Ticket No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Safari Notice No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Notification Email"; text[200]) { }
        field(16; "Top Up card Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Driver Rotation")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

