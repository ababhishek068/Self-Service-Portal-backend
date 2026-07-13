Table 50850 "HR Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[10]) { }
        field(2; "Employee-Active"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active)));
            FieldClass = FlowField;
        }
        field(3; "Employee-Male"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Gender = filter(Male),
                                                     Status = filter(Active)));
            FieldClass = FlowField;
        }
        field(4; "Employee-Female"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Gender = filter(Female),
                                                     Status = filter(Active)));
            FieldClass = FlowField;
        }
        field(5; "Employee-InActive"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(<> Active)));
            FieldClass = FlowField;
        }
        field(6; "Employee-Active (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active)));
            FieldClass = FlowField;
        }
        field(7; "Employee-Male (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(8; "Employee-Female (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Gender = filter(Female)));
            FieldClass = FlowField;
        }
        field(9; "Employee-InActive (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(<> Active)));
            FieldClass = FlowField;
        }
        field(10; "Active Casulals (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Employee Type" = filter(Seconded)));
            FieldClass = FlowField;
        }
        field(11; "Active Permanent (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Contract Type" = filter('PERMANENT')));
            FieldClass = FlowField;
        }
        field(12; "Active Casula (Female) (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Employee Type" = filter(Seconded),
                                                     Gender = filter(" ")));
            FieldClass = FlowField;
        }
        field(13; "Active Casula (Male) (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Employee Type" = filter(Seconded),
                                                     Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(14; "Active Permanent (Female) (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Employee Type" = filter(Seconded),
                                                     Gender = filter(" ")));
            FieldClass = FlowField;
        }
        field(15; "Active Permanent (Male) (PR)"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Employee Type" = filter(Primary),
                                                     Gender = filter(Male)));
            FieldClass = FlowField;
        }
        field(16; "New Visitors"; Integer)
        {
            CalcFormula = count("Sec-Visitor Management" where(Status = filter(Arrived),
                                                                "Initiated Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(17; "Active visitors"; Integer)
        {
            CalcFormula = count("Sec-Visitor Management" where(Status = filter(Entered),
                                                                "Initiated Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(18; "Cleared Visitors"; Integer)
        {
            CalcFormula = count("Sec-Visitor Management" where(Status = filter(Cleared),
                                                                "Initiated Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(19; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }

        field(21; "Teaching Staff"; Integer)
        {
            CalcFormula = count("HR-Employee" where("Salary Grade" = filter('TEACHING'),
                                                     Status = filter(Active)));
            FieldClass = FlowField;
        }

        field(28; "Contract Employees"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active),
                                                     "Contract Type" = filter('CONTRACT')));
            FieldClass = FlowField;
        }
        field(50001; "Approved Legal"; Integer)
        {
            CalcFormula = count("Legal Management" where(Status = filter(Approved),
                                                           "Initiated Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(50002; "New Legal"; Integer)
        {
            CalcFormula = count("Legal Management" where(Status = filter(New),
                                                           "Initiated Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(50003; "Posted Legal"; Integer)
        {
            CalcFormula = count("Legal Management" where(Status = filter(Posted),
                                                           "Initiated Date" = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(50004; "Seconded Employees"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active), "Part Time" = filter(false), "Employees Type" = filter(Seconded)));
            FieldClass = FlowField;
        }
        field(50005; "Interns Employees"; Integer)
        {
            CalcFormula = count("HR-Employee" where(Status = filter(Active), "Part Time" = filter(false), "Employees Type" = filter(Interns)));
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

