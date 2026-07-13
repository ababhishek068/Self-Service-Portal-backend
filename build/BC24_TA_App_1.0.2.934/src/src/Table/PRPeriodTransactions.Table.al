Table 50523 "PR Period Transactions"
{
    DrillDownPageId = "PR Period Transaction List";
    LookupPageId = "PR Period Transaction List";
    fields
    {
        field(1; "Employee Code"; Code[50])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Transaction Code"; Text[30])
        {
            TableRelation = "PR Transaction Codes"."Transaction Code";
        }
        field(3; "Group Text"; Text[30]) { }
        field(4; "Transaction Name"; Text[200]) { }
        field(5; Amount; Decimal) { }
        field(6; Balance; Decimal) { }
        field(7; "Original Amount"; Decimal) { }
        field(8; "Group Order"; Integer) { }
        field(9; "Sub Group Order"; Integer) { }
        field(10; "Period Month"; Integer) { }
        field(11; "Period Year"; Integer) { }
        field(12; "Period Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(13; "Payroll Period"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened";
        }

        field(15; "Reference No"; Code[20]) { }
        field(16; "Department Code"; Code[20]) { }
        field(17; Lumpsumitems; Boolean) { }
        field(18; TravelAllowance; Code[20]) { }
        field(19; "GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Company Deduction"; Boolean) { }
        field(21; "Emp Amount"; Decimal) { }
        field(22; "Emp Balance"; Decimal) { }
        field(23; "Journal Account Code"; Code[20]) { }
        field(24; "Journal Account Type"; Option)
        {
            OptionMembers = " ","G/L Account",Customer,Vendor;
        }
        field(25; "Post As"; Option)
        {
            OptionMembers = " ",Debit,Credit;
        }
        field(26; "Loan Number"; Code[10]) { }
        field(27; "coop parameters"; Option)
        {
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,Overtime;
        }

        field(29; "Payment Mode"; Option)
        {
            OptionMembers = " ","Bank Transfer",Cheque,Cash,SACCO;
        }
        field(30; "Location/Division"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }

        field(32; "Cost Centre"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('COSTCENTRE'));
        }

        field(34; "Salary Notch"; Code[20]) { }
        field(35; "Payslip Order"; Integer) { }
        field(36; "No. Of Units"; Decimal) { }
        field(37; "Employee Classification"; Code[20]) { }
        field(38; State; Code[20])
        {
            TableRelation = "Post Code";
        }
        field(39; "New Departmental Code"; Code[20]) { }

        field(41; "Bank Code"; Code[10]) { }
        field(42; "Branch Code"; Code[10]) { }
        field(43; "A/C Number"; Code[20]) { }
        field(44; "Bank Details"; Text[100]) { }
        field(45; "Branch Details"; Text[100]) { }
        field(46; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(47; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(48; "Contract Type"; code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter("Contract Type"));
        }
        field(49; "Transaction Type"; Option)
        {
            OptionCaption = 'Income,Deduction';
            OptionMembers = Income,Deduction;
        }
        field(50; "Posting Group"; Code[20])
        {
            TableRelation = "PR Employee Posting Groups"."Code";
        }
        field(51; "Employee Type"; Option)
        {
            OptionMembers = Normal,Secondary,Intern,Attachee;
        }
        field(52; "Exists in PR Trans Code"; Boolean)
        {
            CalcFormula = exist("PR Transaction Codes" where("Transaction Code" = field("Transaction Code")));
            FieldClass = FlowField;
        }

        field(53; "Period Closed"; Boolean) { }

        field(54; "IPPD Transaction Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }


        field(55; "Previous Payment System"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(type = const("Previous Payment System"));
        }

        field(56; "Old Staff No"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Old Staff No." where("No." = field("Employee Code")));
        }
        field(57; "Transaction Group"; code[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PR Transaction Codes"."Group Code" where("Transaction Code" = field("Transaction Code")));
        }

        field(58; "Current Payroll Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "pr Payroll Periods"."Date Opened";
            caption = 'Previous Period Filter';
        }
        field(59; "Special Transaction"; option)
        {
            OptionMembers = "None","Defined Contribution","Home Ownership Savings Plan","Life Insurance","Owner Occupier Interest","Prescribed Benefit","Salary Arrears","Staff Loan (Interest Varies)","Value of Quarters",Mortgage,"Voluntary Pension","Mortgage Relief","Sacco Loan";

            FieldClass = FlowField;
            CalcFormula = lookup("PR Transaction Codes"."Special Trans Deductions" where("Transaction Code" = field("Transaction Code")));
        }
        field(60; "On Probation"; Boolean)
        {

            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."On Probation" where("No." = field("Employee Code")));
        }
        field(61; "Contract Type1"; code[20])
        {

            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Contract Type" where("No." = field("Employee Code")));
        }
        field(62; "Employee Status"; Option)
        {
            OptionMembers = New,"Pending Approval",Active,InActive;
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee".Status where("No." = field("Employee Code")));
        }
        field(63; "Payment Mode1"; Option)
        {
            OptionMembers = "Bank","Sacco";
            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Payment Mode" where("No." = field("Employee Code")));
        }
        field(65; "Bank Code1"; code[20])
        {

            FieldClass = FlowField;
            CalcFormula = lookup("HR-Employee"."Main Bank" where("No." = field("Employee Code")));
            TableRelation = "PR Bank Accounts"."Bank Code";
        }
        field(66; "Coop Parameter Lk"; option)
        {
            OptionMembers = "none",shares,loan,"loan Interest","Emergency loan","Emergency loan Interest","School Fees loan","School Fees loan Interest",Welfare,Pension,Overtime,"Voluntary Pension";

            FieldClass = FlowField;
            CalcFormula = lookup("PR Transaction Codes"."coop parameters" where("Transaction Code" = field("Transaction Code")));
        }

    }

    keys
    {
        key(Key1; "Employee Code", "Transaction Code", "Period Month", "Period Year", "Reference No", "Payroll Period")
        {
            Clustered = true;
            SumIndexFields = Amount, "No. Of Units";
        }
        key(Key2; "Employee Code", "Period Month", "Period Year", "Group Order", "Sub Group Order", "Payslip Order", "Reference No")
        {
            SumIndexFields = Amount, "No. Of Units";
        }

    }

    fieldgroups { }

    trigger OnDelete()
    begin
        PRPayrollPeriods.Reset;
        if PRPayrollPeriods.Get("Payroll Period") then begin
            if PRPayrollPeriods.Closed = true then begin
                Error(Text001, 'DELETE', "Payroll Period");
            end;
        end;
    end;

    trigger OnInsert()
    begin
        PRPayrollPeriods.Reset;
        if PRPayrollPeriods.Get("Payroll Period") then begin
            if PRPayrollPeriods.Closed = true then begin
                Error(Text001, 'INSERT', "Payroll Period");
            end;
        end;
    end;

    trigger OnModify()
    begin
        /*
        PRPayrollPeriods.RESET;
        IF PRPayrollPeriods.GET("Payroll Period") THEN
        BEGIN
            IF PRPayrollPeriods.Closed = TRUE THEN
            BEGIN
                ERROR(Text001,'MODIFY',"Payroll Period");
            END;
        END;
        */

    end;

    trigger OnRename()
    begin

        PRPayrollPeriods.Reset;
        if PRPayrollPeriods.Get("Payroll Period") then begin
            if PRPayrollPeriods.Closed = true then begin
                Error(Text001, 'RENAME', "Payroll Period");
            end;
        end;
    end;

    var
        PRPayrollPeriods: Record "PR Payroll Periods";
        Text001: label 'You cannot [ %1  ] records in this Payroll Period [ %2  ] because it is CLOSED';
}

