Table 50852 "Job_Salary grade/steps"
{
    // LookupPageId = "Job_Salary grade/steps";
    // DrillDownPageId = "Job_Salary grade/steps";

    fields
    {
        field(1; Grade; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee Category"; Code[30])
        {
            TableRelation = "Employee Categories".Code;
        }
        field(3; "Salary Grade code"; Integer)
        {
            TableRelation = "Sal Grades"."Salary Grade";
        }
        field(4; "Grade Level"; Integer) { }
        field(5; "House Allowance"; Decimal) { }
        field(6; "Leave Allowance"; Decimal) { }
        field(7; "Medical Ceilling"; Decimal) { }
        field(8; "Annual Leave Days"; Decimal) { }
        field(9; "Grade Description"; Text[100])
        {
            CalcFormula = lookup("Sal Grades".Description where("Salary Grade" = field("Salary Grade code")));
            FieldClass = FlowField;
        }
        field(10; "Basic Salary"; Decimal) { }
    }

    keys
    {
        key(Key1; "Employee Category", "Salary Grade code", "Grade Level")
        {
            Clustered = true;
        }
        key(Key2; "Grade Level") { }
    }

    fieldgroups { }
}

