table 50331 "PR Employees Salary Scale"
{
    // version Agile Payroll


    fields
    {
        field(1; "Job Group"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER(Grade));
        }
        field(2; "Pointer 1 - Minimum"; Decimal) { }
        field(3; "IA to Pointer  2"; Decimal)
        {
            Description = 'Incremental Amount to Pointer 2';

            trigger OnValidate();
            begin
                "Pointer 2" := "Pointer 1 - Minimum" + "IA to Pointer  2";
            end;
        }
        field(4; "Pointer 2"; Decimal) { }
        field(5; "IA to Pointer  3"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 3" := "Pointer 2" + "IA to Pointer  3";
            end;
        }
        field(6; "Pointer 3"; Decimal) { }
        field(7; "IA to Pointer  4"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 4" := "Pointer 3" + "IA to Pointer  4";
            end;
        }
        field(8; "Pointer 4"; Decimal) { }
        field(9; "IA to Pointer  5"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 5" := "Pointer 4" + "IA to Pointer  5";
            end;
        }
        field(10; "Pointer 5"; Decimal) { }
        field(11; "IA to Pointer  6"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 6" := "Pointer 5" + "IA to Pointer  6";
            end;
        }
        field(12; "Pointer 6"; Decimal) { }
        field(13; "IA to Pointer  7"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 7" := "Pointer 6" + "IA to Pointer  7";
            end;
        }
        field(14; "Pointer 7"; Decimal) { }
        field(15; "IA to Pointer  8"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 8" := "Pointer 7" + "IA to Pointer  8";
            end;
        }
        field(16; "Pointer 8"; Decimal) { }
        field(17; "IA Pointer  9"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 9" := "Pointer 8" + "IA Pointer  9";
            end;
        }
        field(18; "Pointer 9"; Decimal) { }
        field(19; "IA to Pointer  10"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 10" := "Pointer 9" + "IA to Pointer  10";
            end;
        }
        field(20; "Pointer 10"; Decimal) { }
        field(21; "Maximum Pointer"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pointer 10" := "Pointer 9" + "IA to Pointer  10";
            end;
        }
        field(22; "Job Group Description"; Text[250]) { }
    }

    keys
    {
        key(Key1; "Job Group") { }
    }

    fieldgroups { }
}

