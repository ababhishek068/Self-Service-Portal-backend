Table 50687 "HR Recruitment Stages"
{
    LookupPageID = "HR Recruitment Stages List";

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; Description; Text[30]) { }
        field(3; "Employee Requisition Filter"; code[30])
        {
            TableRelation = "HR Employee Requisitions"."Requisition No.";
            FieldClass = FlowFilter;
        }
        field(4; "Qualified Applicants"; Integer)
        {

            FieldClass = FlowField;
            CalcFormula = count("HR Shortlisting Entry" where("Stage Code" = field(Code), "Requisition No" = field("Employee Requisition Filter")));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

