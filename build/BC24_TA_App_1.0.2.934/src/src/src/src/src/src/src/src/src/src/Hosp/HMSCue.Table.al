Table 50142 "HMS Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(2; Students; Integer)
        {
            CalcFormula = count("HMS Patient" where("Patient Type" = filter(Student)));
            FieldClass = FlowField;
        }
        field(3; Employees; Integer)
        {
            CalcFormula = count("HMS Patient" where("Patient Type" = filter(Employee)));
            FieldClass = FlowField;
        }
        field(4; Dependants; Integer)
        {
            CalcFormula = count("HMS Patient" where("Patient Type" = filter(Dependant)));
            FieldClass = FlowField;
        }
        field(5; "Other Patients"; Integer)
        {
            CalcFormula = count("HMS Patient" where("Patient Type" = filter(Private)));
            FieldClass = FlowField;
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

