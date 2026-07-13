Table 50235 "Programme Entry Subjects"
{


    fields
    {
        field(1; Programme; Code[20])
        {
            TableRelation = Programme.Code;
        }
        field(2; Subject; Code[20])
        {
            TableRelation = "Application Setup Subjects".Code;
        }
        field(3; "Minimum Grade"; Code[20])
        {
            TableRelation = "Application Setup Grade".Code;

            trigger OnValidate()
            begin
                if GradeSetUp.Get("Minimum Grade") then begin
                    "Minimum Points" := GradeSetUp.Points
                end;
            end;
        }
        field(4; "Minimum Points"; Decimal) { }
    }

    keys
    {
        key(Key1; Programme, Subject)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        GradeSetUp: Record "Application Setup Grade";
}

