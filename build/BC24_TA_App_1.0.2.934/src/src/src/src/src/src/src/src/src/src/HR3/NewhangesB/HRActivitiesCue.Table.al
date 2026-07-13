table 50511 "HR Activities Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[30]) { }

        field(2; "Active Employees"; Integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Count("HR-Employee" where(Status = filter(Active), "Employees Type" = filter(<> Interns)));
        }

        field(3; "In-Active Employees"; Integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Count("HR-Employee" WHERE(Status = CONST(InActive), "Employees Type" = filter(<> Interns)));
        }

        field(4; "All Jobs"; Integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("HR Jobs");

        }

        field(5; "Male Employees"; Integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("HR-Employee" where(Gender = const(Male)));
        }

        field(6; "Female Employees"; Integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("HR-Employee" where(Gender = const(Female)));
        }

        field(7; "Current Payroll Period"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PR Payroll Periods"."Date Opened" where(Closed = const(false)));
        }

        field(8; "Net Pay"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('NPAY'),
                            "Period Closed" = const(false)));
                            //"Period Closed" = const(false), "Period Year" = filter(2022)));
            DecimalPlaces = 0 : 0;
        }

        field(9; "Basic Pay"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('BPAY'),
                            "Period Closed" = const(false)));
                             //"Period Closed" = const(false), "Period Year" = filter(2022)));
            DecimalPlaces = 0 : 0;
        }


        field(10; "Contract Staff"; Integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = Count("HR-Employee" WHERE("Employee Contract Type" = filter(Contract)));
        }
        field(11; "Permanent Staff"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("HR-Employee" where(Status = filter(Active), "Part Time" = filter(false),
                                                     "Employees Type" = filter(Permanent)));

            FieldClass = FlowField;
        }

        field(12; "Seconded Staff"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("HR-Employee" where(Status = filter(Active), "Part Time" = filter(false),
                                                     "Employees Type" = filter(Seconded)));

            FieldClass = FlowField;
        }

        field(13; "Staff on Leave"; Integer) { }
        field(114; "Staff on Leave Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("HR-Employee" where("On Leave" = filter(true)));
        }

        field(14; "Contracts Due"; Integer) { }

        field(15; "Retirement Report"; Integer) { }

        field(16; "Allowances"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Group Order" = const(3),
                            "Period Closed" = const(false)));
            DecimalPlaces = 0 : 0;
        }
        // field(17; "Deductions"; Decimal)
        // {
        //     BlankZero = true;
        //     FieldClass = FlowField;
        //     CalcFormula = sum("PR Period Transactions".Amount where("Group Text" = const('DEDUCTIONS'),
        //                     "Period Closed" = const(false)));
        //     DecimalPlaces = 0 : 0;
        // }

        field(18; "NHIF"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('NHIF'),
                            "Period Closed" = const(false), "Period Year" = filter(2022)));
            DecimalPlaces = 0 : 0;
        }

        field(19; "Pension"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('Pension'),
                            "Period Closed" = const(false)));
            DecimalPlaces = 0 : 0;
        }

        field(20; "PAYE"; Decimal)
        {
            BlankZero = true;
            Caption='Income Tax';
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('PAYE'),
                            "Period Closed" = const(false)));
            DecimalPlaces = 0 : 0;
        }

        field(21; "Pension-Employee"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('507'),
                            "Period Closed" = const(false)));
            DecimalPlaces = 0 : 0;
        }

        field(22; "Pension-Employer"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Employer Deductions".Amount where("Transaction Code" = const('507'),
                            "Period Closed" = const(false)));
            DecimalPlaces = 0 : 0;
        }

        // field(23; "Voluntary Pension"; Decimal)
        // {
        //     BlankZero = true;
        //     FieldClass = FlowField;
        //     CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('D52'),
        //                     "Period Closed" = const(false), "Period Year" = filter(2022)));
        //     DecimalPlaces = 0 : 0;
        // }

        field(24; "Voluntary Pension"; Decimal)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = sum("PR Period Transactions".Amount where("Transaction Code" = const('D53'),
                            "Period Closed" = const(false)));
            DecimalPlaces = 0 : 0;
        }

        field(25; "Probation Report"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
        }
        field(26; "Registered Male"; integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Registration Form" where("Gender" = const(Male), Status = const(Pending)));

        }
        field(27; "Registered Female"; integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Registration Form" where("Gender" = const(Female), Status = const(Pending)));

        }
        field(28; "Registered Disabled"; integer)
        {
            BlankZero = true;
            FieldClass = FlowField;
            CalcFormula = count("Registration Form" where("Is Disable" = const(true), Status = const(Pending)));
        }
    }

    keys
    {
        key(Key1; "Primary Key") { }
    }

    fieldgroups { }
}

