Table 50137 "Travel Document Payment Lines"
{

    fields
    {
        field(1; "Doc No"; Code[20])
        {
            TableRelation = "Project Travel Requests".Code;
        }
        field(2; "Payment Type"; Code[20])
        {
            TableRelation = "Receipts and Payment Types".Code where(Type = filter(Claim));
        }
        field(3; "Staff No"; Code[20])
        {
            TableRelation = "Project Travel Request Lines"."Staff No" where(Code = field("Doc No"));

            trigger OnValidate()
            var
                HREmployee: Record "HR-Employee";
            begin
                HREmployee.Reset;
                HREmployee.SetRange("No.", "Staff No");
                if HREmployee.Find('-') then
                    "Staff Name" := HREmployee."First Name" + ' ' + HREmployee."Middle Name" + ' ' + HREmployee."Last Name";
            end;
        }
        field(4; "Staff Name"; Text[100]) { }
        field(5; Amount; Decimal) { }
        field(6; "Date created"; Date) { }
    }

    keys
    {
        key(Key1; "Doc No", "Payment Type", "Staff No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

