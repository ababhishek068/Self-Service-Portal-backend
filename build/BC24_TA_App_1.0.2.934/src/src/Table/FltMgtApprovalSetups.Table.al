Table 50861 "Flt Mgt Approval Setups"
{

    fields
    {
        field(1; UserID; Code[20])
        {
            TableRelation = User;
        }
        field(2; "Fleet Management Area"; Option)
        {
            OptionMembers = " ","Vehicle Management",TransportReq,DailyWorksheet,FuelReq,MaintenanceReq;
        }
        field(3; Create; Boolean) { }
        field(4; "Line Manager Approver"; Boolean) { }
        field(5; "Transport Mger Approver"; Boolean) { }
        field(6; "View Only Department"; Boolean) { }
        field(7; "User Department"; Code[20]) { }
        field(8; "Safari Notice Approver"; Boolean) { }
        field(9; "Finance Approver"; Boolean) { }
        field(50000; "IS Director"; Boolean) { }
        field(50001; "IS HRM"; Boolean) { }
        field(50002; "Is Deputy Director"; Boolean) { }
    }

    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

