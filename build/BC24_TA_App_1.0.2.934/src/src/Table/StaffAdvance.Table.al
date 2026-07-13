Table 50034 "Staff Advance"
{

    fields
    {
        field(1; "Staff No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee";
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.Get("Staff No") then begin
                    "Staff Name" := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
                end;
            end;
        }
        field(2; "Staff Name"; Text[100]) { }
        field(3; Amount; Decimal) { }
        field(4; "Date Opened"; Date)
        {
            TableRelation = "PR Payroll Periods"."Date Opened" where(Closed = filter(false));
            trigger OnValidate()
            var
                prPayrollPeriod: Record "PR Payroll Periods";
            begin
                if prPayrollPeriod.Get("Date Opened") then begin
                    "Period Month" := prPayrollPeriod."Period Month";
                    "Period Year" := prPayrollPeriod."Period Year";
                    "Period Name" := prPayrollPeriod."Period Name";
                end;
            end;
        }
        field(5; "Period Month"; Integer)
        {
            Editable = true;
        }
        field(6; "Period Year"; Integer)
        {
            Editable = true;
        }
        field(7; "Period Name"; Text[30])
        {
            Editable = true;
        }
        field(8; Status; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Canceled,Posted;
        }
        field(9; "Account No."; Code[20])
        {
            Editable = true;
            TableRelation = Customer."No." where("Customer Posting Group" = filter('STAFF ACCOUNTS'));
        }
        field(10; Payee; text[100])
        {
            Editable = true;
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if Cust.Get("Account No.") then
                    Payee := Cust.Name;
            end;
        }
    }

    keys
    {
        key(Key1; "Staff No", "Date Opened")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //NextNo:=NoSeriesMgt.GetNextNo('TICKETNO',TODAY,TRUE);
        //"Ticket Number" := NextNo;
    end;
}

