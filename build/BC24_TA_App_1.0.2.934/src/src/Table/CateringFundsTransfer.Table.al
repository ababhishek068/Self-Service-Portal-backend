Table 50879 "Catering Funds Transfer"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Student No"; Code[20])
        {
            TableRelation = Customer."No." where("Customer Type" = filter(Student));

            trigger OnValidate()
            begin
                if Cust.Get("Student No") then
                    Name := Cust.Name;
            end;
        }
        field(3; Name; Text[100]) { }
        field(4; Date; Date) { }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                if "Transfer Type" = "transfer type"::"To Catering" then begin
                    Cust.Get("Student No");
                    Cust.CalcFields(Cust.Balance);
                    //IF (Cust.Balance+Amount)>0 THEN ERROR('Please note that the amount availlable in Students Account is '+ FORMAT(Cust.Balance));
                end;
                if "Transfer Type" = "transfer type"::"To Fees" then begin
                    Cust.Get("Student No");
                    Cust.CalcFields(Cust."Catering Amount");
                    if (Cust."Catering Amount") < Amount then Error('Please note that the amount availlable in Catering Account is ' + Format(Cust."Catering Amount"));
                end;
            end;
        }
        field(6; Posted; Boolean) { }
        field(7; "Posted By"; Code[20]) { }
        field(8; "Transfer Type"; Option)
        {
            OptionCaption = 'To Catering,To Fees';
            OptionMembers = "To Catering","To Fees";
        }
    }

    keys
    {
        key(Key1; "Line No", "Student No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Cust: Record Customer;
}

