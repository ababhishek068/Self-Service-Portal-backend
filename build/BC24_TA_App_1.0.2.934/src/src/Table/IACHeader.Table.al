Table 50821 "IAC Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            TableRelation = "HR-Employee"."No." where(Status = const(Active));

            trigger OnValidate()
            var
                HREmployees: Record "HR-Employee";
            begin

                Clear(Name);
                Clear("ID Passport No.");

                HREmployees.Get("No.");

                Name := UpperCase(HREmployees."Full Name");
                "ID Passport No." := HREmployees."ID Number";
            end;
        }
        field(2; Name; Text[30]) { }
        field(3; "Tel. No."; Code[20]) { }
        field(4; "ID Passport No."; Code[20]) { }
        field(5; "Personell No."; Code[20]) { }
        field(6; "Commitee Position"; Option)
        {
            OptionMembers = ,Member,Secretary,Chairperson,"Technical Support";
        }
        field(7; Sign; Text[30]) { }
        field(8; "LPO Number"; Code[20])
        {
            Editable = false;
        }

        field(9; "Delivery Date"; Date) { }

        field(10; "Delivery Note No."; Text[100]) { }

        field(11; "Contract Amount"; Decimal) { }
        field(12; "Name of Coopted Member"; Text[100]) { }
    }

    keys
    {
        key(Key1; "No.", "LPO Number")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

