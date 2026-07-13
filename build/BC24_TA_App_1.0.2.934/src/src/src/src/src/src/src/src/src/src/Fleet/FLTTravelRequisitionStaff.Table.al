Table 50864 "FLT-Travel Requisition Staff"
{

    fields
    {
        field(1; "Req No"; Code[20]) { }
        field(2; No; Code[20])
        {
            TableRelation = if ("Passenger Type" = const(Employee)) "HR-Employee"."No."
            else
            if ("Passenger Type" = const(Student)) Customer."No." where("Customer Type" = const(Student));

            trigger OnValidate()
            begin
                if HrEmployee.Get(No) then begin
                    Name := HrEmployee."First Name" + ' ' + HrEmployee."Middle Name" + ' ' + HrEmployee."Last Name";
                    Position := HrEmployee."Job Title";
                end;
                if Cust.Get(No) then Name := Cust.Name;
            end;
        }
        field(3; Name; Text[70]) { }
        field(4; Position; Text[200]) { }
        field(5; "Daily Work Ticket"; Code[20]) { }
        field(6; EntryNo; Integer)
        {
            AutoIncrement = true;
        }
        field(7; "Passenger Type"; Option)
        {
            OptionCaption = 'Employee,Student';
            OptionMembers = Employee,Student;
        }
    }

    keys
    {
        key(Key1; "Req No", No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HrEmployee: Record "HR-Employee";
        Cust: Record Customer;
}

