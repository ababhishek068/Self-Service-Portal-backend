Table 50516 "PR Employee P9 Info"
{

    fields
    {
        field(1; "Employee Code"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Basic Pay"; Decimal) { }
        field(3; Allowances; Decimal) { }
        field(4; Benefits; Decimal) { }
        field(5; "Value Of Quarters"; Decimal) { }
        field(6; "Defined Contribution"; Decimal) { }
        field(7; "Owner Occupier Interest"; Decimal) { }
        field(8; "Gross Pay"; Decimal) { }
        field(9; "Taxable Pay"; Decimal) { }
        field(10; "Tax Charged"; Decimal) { }
        field(11; "Insurance Relief"; Decimal) { }
        field(12; "Tax Relief"; Decimal) { }
        field(13; PAYE; Decimal) { }
        //field(14; Pension; Decimal) { }
        field(15; NHIF; Decimal) { }
        field(16; Deductions; Decimal) { }
        field(17; "Net Pay"; Decimal) { }
        field(18; "Period Month"; Integer) { }
        field(19; "Period Year"; Integer) { }
        field(20; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(21; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }
        field(22; Pension; Decimal) { }
        field(23; HELB; Decimal) { }

    }

    keys
    {
        key(Key1; "Employee Code", "Payroll Period")
        {
            Clustered = true;
            SumIndexFields = "Basic Pay", "Gross Pay", "Net Pay", Allowances, Deductions, PAYE, Pension, NHIF;
        }
    }

    fieldgroups { }
}

