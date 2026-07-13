Table 50894 "CshMgt PV Process Road"
{

    fields
    {
        field(1; "From Status Code"; Code[20])
        {
            TableRelation = "CshMgt PV Steps".Code;

            trigger OnValidate()
            begin
                PVSteps.Reset;
                PVSteps.Get("From Status Code");
                "From Status Description" := PVSteps.Description;
            end;
        }
        field(2; "From Status Description"; Text[30]) { }
        field(3; "To Status Code"; Code[20])
        {
            TableRelation = "CshMgt PV Steps".Code;

            trigger OnValidate()
            begin
                PVSteps.Reset;
                PVSteps.Get("To Status Code");
                "To Status Description" := PVSteps.Description;
            end;
        }
        field(4; "To Status Description"; Text[30]) { }
        field(5; Start; Boolean) { }
        field(6; "End"; Boolean) { }
        field(7; "Allow Check Preview"; Boolean) { }
    }

    keys
    {
        key(Key1; "From Status Code", "To Status Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        PVSteps: Record "CshMgt PV Steps";
}

