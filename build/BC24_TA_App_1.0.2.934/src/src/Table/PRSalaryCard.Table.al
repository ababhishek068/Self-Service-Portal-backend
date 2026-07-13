Table 50524 "PR Salary Card"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Basic Pay"; Decimal)
        {

            trigger OnValidate()
            var
                PREmpTrans: Record "PR Employee Transactions";
                PayPeriod: record "PR Payroll Periods";
            begin
                PayPeriod.reset;
                PayPeriod.setrange(Closed, false);
                if PayPeriod.find('-') then begin
                    PREmpTrans.reset;
                    PREmpTrans.setrange(PREmpTrans."Employee Code", "Employee Code");
                    PREmpTrans.setrange(PREmpTrans."Payroll Period", PayPeriod."Date Opened");
                    if PREmpTrans.find('-') then begin
                        repeat
                            PREmpTrans.validate("Transaction Code");
                            PREmpTrans.modify;
                        until PREmpTrans.next = 0;
                    end
                end;
            end;
        }
        field(3; "Payment Mode"; Option)
        {
            Description = 'Bank Transfer,Cheque,Cash,FOSA';
            OptionMembers = "Bank Transfer",Cheque,Cash,FOSA;
        }
        field(4; Currency; Code[10]) { }
        field(5; "Pays Pension"; Boolean) { }
        field(6; "Pays NHIF"; Boolean) { 
            
        }
        field(7; "Pays PAYE"; Boolean) { }
        field(8; "Payslip Message"; Text[100]) { }
        field(9; "Cumm BasicPay"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Group Order" = FILTER(8), "Sub Group Order" = FILTER(0 | 1), "Employee Code" = FIELD("Employee Code"), "Transaction Code" = FILTER(<> 'Total Deductions')));
        }
        field(10; "Cumm GrossPay"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Group Order" = FILTER(8), "Sub Group Order" = FILTER(0 | 1), "Employee Code" = FIELD("Employee Code"), "Transaction Code" = FILTER(<> 'Total Deductions')));
        }
        field(11; "Cumm NetPay"; Decimal)
        {
            Editable = false;
        }
        field(12; "Cumm Allowances"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Group Order" = FILTER(8), "Sub Group Order" = FILTER(0 | 1), "Employee Code" = FIELD("Employee Code"), "Transaction Code" = FILTER(<> 'Total Deductions')));
        }
        field(13; "Cumm Deductions"; Decimal)
        {
            Editable = false;
        }
        field(14; "Suspend Pay"; Boolean)
        {
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if "Suspend Pay" = true then begin
                    if Confirm('Are you sure you want to suspent pay for staff no %1?', false, "Employee Code") = false then exit;
                    HREmp.reset;
                    HREmp.SetRange("No.", "Employee Code");
                    HREmp.FindFirst();
                    HREmp.Status := HREmp.Status::InActive;
                    Message('Employee has been marked as in-active');

                end;

                if "Suspend Pay" = false then begin
                    if Confirm('Are you sure you want to restore pay for staff no %1', false, "Employee Code") = false then exit;
                    HREmp.reset;
                    HREmp.SetRange("No.", "Employee Code");
                    HREmp.FindFirst();
                    HREmp.Status := HREmp.Status::Active;
                    Message('Employee has been marked as active');

                end;
            end;
        }
        field(15; "Suspension Date"; Date) { }
        field(16; "Suspension Reasons"; Text[200]) { }
        field(17; "Period Filter"; Date)
        {
            // FieldClass = FlowFilter;
            // TableRelation = "PR Payroll Periods"."Date Opened";
          // -felix-felix

            FieldClass = FlowField;
            CalcFormula = lookup ("PR Payroll Periods"."Date Opened" where (closed=filter(false)));
        }
        field(18; Exists; Boolean) { }
        field(19; "Cumm PAYE"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("PR Period Transactions".Amount WHERE("Group Order" = FILTER(8), "Sub Group Order" = FILTER(0 | 1), "Employee Code" = FIELD("Employee Code"), "Transaction Code" = FILTER(<> 'Total Deductions')));
        }
        // field(20; "Cumm Pension"; Decimal)
        // {
        //     Editable = false;
        // }
        field(21; "Cumm Pension"; Decimal)
        {
            Editable = false;
        }
        field(22; "Cumm HELB"; Decimal)
        {
            Editable = false;
        }
        field(23; "Cumm NHIF"; Decimal)
        {
            Editable = false;
        }
        field(28; "No. Overtime Day(s) Worked"; Decimal) { }
        field(44; "Days Worked"; Decimal) { }
        field(60004; "No.Of Days PDM"; Integer) { }
        field(60005; "Rate Per Day"; Decimal) { }
        field(60008; "No. of Days Worked"; Decimal) { }
        field(60009; "Is Paid Daily?"; Boolean)
        {
            Editable = false;
        }
        field(60010; "No. of Sundays / Holidays Work"; Decimal) { }
        field(60012; "Not Based on Rates"; Boolean) { }
        field(60013; "Insurance Certificate?"; Boolean) { }
        field(60014; "PAYE Relief?"; Boolean) { }
        field(60018; "De-Activate Personal Relief?"; Boolean) { }
        field(60019; "Gratuity Perc."; Decimal) { }

        field(69020; "PWD Certificate?"; Boolean) { }
        field(40;"Process Advance";Boolean){
            //TableRelation="Staff Advance Header"."Send to payroll" where(Status=filter(Approved),"Send to payroll"=const(true),"Payroll processed"=const(false),Posted=const(false),"Advance Closed"=const(false),"Staff ID"=field("Employee Code"));
        }
        field(41; "Portal Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "PR Payroll Periods"."Date Opened";
        }

    }

    keys
    {
        key(Key1; "Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;
}

