Table 50226 "HR Employee Qualification Gaps"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Qualification Code"; Code[20])
        {
            TableRelation = "HR Job Qualifications".Code;
        }
        field(4; "From Date"; Date) { }
        field(5; "To Date"; Date) { }
        field(6; Type; Option)
        {
            OptionMembers = " ",Internal,External,"Previous Position";
        }
        field(7; Description; Text[150]) { }
        field(8; "Institution/Company"; Text[250]) { }
        field(9; Cost; Decimal) { }
        field(10; "Course Grade"; Text[30]) { }
        field(11; "Employee Status"; Option)
        {
            OptionMembers = Active,Inactive,Terminated;
        }
        field(12; Comment; Boolean) { }
        field(13; "Expiration Date"; Date) { }
        field(14; "Qualification Type"; Code[50])
        {
            TableRelation = "HR Lookup Values".Code where(Type = filter(Grade));
        }
        field(15; Qualification; Text[200])
        {
            TableRelation = "HR Jobs Requirements"."Qualification Code" where("Qualification Type" = field("Qualification Type"));

            trigger OnValidate()
            begin
                HRQualifications.Reset;
                if HRQualifications.Get("Qualification Type", Qualification) then
                    Description := HRQualifications.Description;
            end;
        }
        field(16; "Score ID"; Decimal) { }
        field(17; "Grad. Date"; Date) { }
        field(18; Gap; Boolean) { }
        field(19; "Plan No."; Code[20])
        {
            TableRelation = "HR Succession Employee"."Plan No.";
        }
    }

    keys
    {
        key(Key1; "Plan No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        HRQualifications: Record "HR Qualifications";
}

