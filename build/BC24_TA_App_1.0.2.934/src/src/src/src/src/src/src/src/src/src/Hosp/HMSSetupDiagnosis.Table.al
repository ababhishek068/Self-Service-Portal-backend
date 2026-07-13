Table 50564 "HMS Setup Diagnosis"
{
    DataCaptionFields = Description, "Code";
    // DrillDownPageID = UnknownPage70135107;
    // LookupPageID = UnknownPage70135107;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            NotBlank = true;
        }
        field(3; "Male Counter"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field(Code),
                                                                      Gender = filter(Male),
                                                                      "Treatment Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(4; "Female Counter"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field(Code),
                                                                      Gender = filter(Female),
                                                                      "Treatment Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(5; "Total Treatments"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field(Code),
                                                                      "Treatment Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(6; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(7; Edit; Boolean) { }
        field(8; "New Appointments"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field(Code),
                                                                      "Treatment Date" = field("Date Filter"),
                                                                      "Patient Appointments" = const(1)));
            FieldClass = FlowField;
        }
        field(9; Diagnosis; Code[200]) { }
        field(10; "Total Treatments Under 5"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field(Code),
                                                                      "Treatment Date" = field("Date Filter"),
                                                                      "Age in Years" = filter(<= 5)));
            FieldClass = FlowField;
        }
        field(11; "Total Treatments Over 5"; Integer)
        {
            CalcFormula = count("HMS Treatment Form Diagnosis" where("Diagnosis No." = field(Code),
                                                                      "Treatment Date" = field("Date Filter"),
                                                                      "Age in Years" = filter(> 5)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Description) { }
        key(Key3; Diagnosis) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description, "Code") { }
        fieldgroup(Brick; Description, "Code") { }
    }
}

