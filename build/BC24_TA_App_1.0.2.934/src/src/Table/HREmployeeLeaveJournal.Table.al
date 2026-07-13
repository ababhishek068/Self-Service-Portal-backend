Table 50839 "HR Employee Leave Journal"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Staff No."; Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if emp.Get("Staff No.") then
                    "Staff Name" := emp."First Name" + ' ' + emp."Middle Name" + ' ' + emp."Last Name";
            end;
        }
        field(3; "Staff Name"; Text[250]) { }
        field(4; "Transaction Description"; Text[150]) { }
        field(5; "Leave Type"; Code[20])
        {
            TableRelation = "Leave Types".Code;
        }
        field(6; "No. of Days"; Decimal) { }
        field(7; "Transaction Type"; Option)
        {
            OptionCaption = ' ,Allocation,Application,Positive Adjustment,Negative Adjustment';
            OptionMembers = " ",Allocation,Application,"Positive Adjustment","Negative Adjustment";
        }
        field(8; "Document No."; Code[20]) { }
        field(9; "Posting Date"; Date) { }
        field(10; "Leave Period"; Integer) { }
        field(11; "Leave Balance"; Decimal) { }
        field(12; "Allow Carry Forward"; Boolean) { }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        emp: Record "HR-Employee";
}

