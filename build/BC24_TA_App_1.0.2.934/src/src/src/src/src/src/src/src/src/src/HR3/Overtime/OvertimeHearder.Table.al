
Table 51429 "Overtime Header-ta"
{

    fields
    {
        field(1;"Overtime ID";Integer)
        {
            AutoIncrement = false;
        }
        field(10;"Employee No.";Code[20])
        {
        }
        field(11;"Total Amount";Decimal)
        {
            CalcFormula = sum("Overtime Lines"."Line Total"  where(PayrollPeriod=field("Payroll Period"))) ;
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Total Amount(LCY)";Decimal)
        {
            CalcFormula = sum("Overtime Lines"."Line Total" where(PayrollPeriod=field("Payroll Period")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;"Period Month";Integer)
        {
            Editable=false;
        }
        field(14;"Period Year";Integer)
        {
            Editable=false;
        }
        field(15;"Payroll Period";Date)
        {
            TableRelation="PR Payroll Periods"."Date Opened" where(Closed=const(false));
            trigger OnValidate()
            var
            noofovertime: Integer;
            begin

                overtime.Reset();
                overtime.SetRange(overtime."Payroll Period","Payroll Period");
                if overtime.Find('-') then begin
                    repeat
                    noofovertime:=noofovertime+1;

                    until overtime.next=0;
                    if noofovertime>1 then begin
                    Error('You cannot have two overtime records for the same payroll period');
                end;
                end;
                
                //noofovertime:=0;
                PayrollCalender.Reset();
                PayrollCalender.SetRange(PayrollCalender."Date Opened","Payroll Period");
                if PayrollCalender.FindFirst() then begin
                "Payroll Code":=PayrollCalender."Period Name";
                "Period Month":=PayrollCalender."Period Month";
                "Period Year":=PayrollCalender."Period Year";
                end;
                
            end;
        }
        field(16;"Payroll Code";Code[20])
        {
            Editable=false;
        }
        field(17;"Job Group";Code[10])
        {
        }
        field(18;Posted;Boolean)
        {
            Editable=false;
        }
        field(19;"Created By";Code[50]){
            Editable=false;
        }
        field(20;"Created on";Date){
            Editable=false;
        }
        field(21;"Date Posted";Date){
            Editable=false;
        }
        field(22;"Posted By";Code[50]){
            Editable=false;
        }
        field(23;"Approve for Payroll";Boolean){
            Editable=false;
        }

        
    }

    keys
    {
        key(Key1;"Overtime ID","Payroll Period")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Posted,false);
    end;

    trigger OnInsert()
    begin
        SetpayrollPeriod();
        SetEmpInfo();
        "Created By":=UserId;
        "Created on":=Today;
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Posted,FALSE);
        if "Approve for Payroll"=true then begin
            Error('You cannot modify this record');

            
        end
    end;

    var
        Employee: Record "HR-Employee";
        CurrExchRate: Record "Currency Exchange Rate";
        PayrollCalender: Record "PR Payroll Periods";
        PayrollTrans: Record "PR Period Transactions";
        //Loans: Record UnknownRecord51516371;
        HR: Record "HR-Employee";
        SCARD: Record "PR Salary Card";
        overtime: record "Overtime Header-ta";
        //MEMB: Record UnknownRecord51516364;

    local procedure SetpayrollPeriod()
    begin
         PayrollCalender.Reset;
         PayrollCalender.SetRange(PayrollCalender.Closed,false);
         if PayrollCalender.FindFirst then begin
          "Period Month":=PayrollCalender."Period Month";
          "Period Year":=PayrollCalender."Period Year";
          "Payroll Period":=PayrollCalender."Date Opened";
         end;
    end;

    local procedure SetEmpInfo()
    begin
        Employee.Reset;
        Employee.SetRange(Employee."No.","Employee No.");
        if Employee.FindFirst then begin
          "Payroll Code":=Employee."Posting Group";
          "Job Group":=Employee."Job Group";
          

        end;
    end;

    local procedure CalculateOvertimeAmount()
    begin
    end;
}

