Table 50114 "Recruiting Officers History"
{
    fields
    {
        field(1; "No"; Code[30])
        {
            TableRelation = "HR-Employee"."No." where(Status = filter(Active));
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET(No) then Name := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(2; Name; Text[150]) { }
        field(3; "Recruitment Center"; Code[20])
        {
            TableRelation = "Recruitment Centers".Code;
        }
        field(4; Corhot; Code[20])
        {
            TableRelation = Intake.Code where(Current = filter(true));
        }
        field(6; "Recruitment Date"; Date) { }
        field(7; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(8; "Assigned By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
        field(9; "Date Assigned"; Date)
        {
            Editable = false;
        }
        field(10; "Type"; Option)
        {
            OptionMembers = Recruit,Confirm;
        }
    }

    keys
    {
        key(Key1; No, Corhot, "Entry No", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

