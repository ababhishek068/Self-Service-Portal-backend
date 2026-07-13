Table 50816 "HR Staff  Induction"
{

    fields
    {
        field(1; "Induction Code"; Code[30]) { }
        field(2; "Employee Code"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if Hr.Get("Employee Code") then
                    "Employee name" := Hr."First Name" + ' ' + Hr."Middle Name" + ' ' + Hr."Last Name";
                Email := Hr."Company E-Mail";
            end;
        }
        field(3; "Employee name"; Text[60]) { }
        field(5; From; Date) { }
        field(6; Todate; Date) { }
        field(7; Duration; Option)
        {
            OptionCaption = ' ,Days,Week,Months,Years';
            OptionMembers = " ",Days,Week,Months,Years;
        }
        field(8; "Days Attended"; Decimal) { }
        field(9; Depatment; Code[10]) { }
        field(10; "Induction Status"; Option)
        {
            OptionMembers = "Not done",Done;
        }
        field(11; "Officer Incharge"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(12; Email; Text[30]) { }
    }

    keys
    {
        key(Key1; "Induction Code", "Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Hr: Record "HR-Employee";
}

