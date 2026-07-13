Table 50103 "Admissions Number Setup"
{

    fields
    {
        field(1; Degree; Code[20])
        {
            Description = 'Stores the code to the degree';
            TableRelation = Programme.Code;
        }
        field(2; "Degree Name"; Text[200])
        {
            CalcFormula = lookup(Programme.Description where(Code = field(Degree)));
            Description = 'Stores the name of the degree';
            FieldClass = FlowField;
        }
        field(3; "Programme Prefix"; Code[20])
        {
            Description = 'Stores the prefix of the code in the database';
        }
        field(4; "No. Series"; Code[20])
        {
            Description = 'Stores the numbering series for the code in the database';
            TableRelation = "No. Series".Code;
        }
        field(5; Year; Code[20])
        {
            Description = 'Stores the year in the database';
        }
        field(6; "JAB Prefix"; Code[20]) { }
        field(50000; "SSP Prefix"; Code[20]) { }
        field(50001; "Reporting Date"; Date) { }

    }

    keys
    {
        key(Key1; Degree)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

